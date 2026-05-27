import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mailosaur/mailosaur.dart';

/// Operations for finding, retrieving, creating, forwarding, replying to, and
/// deleting the email and SMS messages received by your Mailosaur inboxes (servers).
///
/// Accessed via `client.messages`.
class Messages {
  final http.BaseClient client;
  final String baseUrl;

  Messages(this.client, this.baseUrl);

  /// Waits for a message to be found, returning as soon as a message matching
  /// the given `criteria` within the inbox (server) identified by `server` is found.
  ///
  /// This is the most efficient method of looking up a message, so we recommend
  /// using it wherever possible. The search waits up to `timeout` milliseconds,
  /// only considers messages received after `receivedAfter`, and orders results
  /// according to `dir`.
  ///
  /// Returns a [Future] resolving to the first [Message] matching the criteria.
  ///
  /// Throws a [MailosaurError] with error type `no_messages_found` if no
  /// matching message exists, or `search_timeout` if no matching message
  /// arrives before the timeout elapses.
  Future<Message> get(String server, SearchCriteria criteria, {int timeout = 10000, int? receivedAfter, String? dir}) async {
    if (server.length != 8) {
      throw Exception("Must provide a valid Server ID.");
    }

    final result = await search(server, criteria, timeout: timeout, receivedAfter: receivedAfter, dir: dir);
    return await getById(result.items[0].id);
  }

  /// Retrieves the detail for a single message identified by `id`.
  ///
  /// Must be used in conjunction with either [list] or [search] in order to
  /// obtain the unique identifier for the required message.
  ///
  /// Returns a [Future] resolving to the full [Message].
  Future<Message> getById(String id) async {
    final url = Uri.parse('${baseUrl}api/messages/$id');
    final response = await client.get(url);

    if (response.statusCode != 200) {
      throw MailosaurError(response);
    }

    return Message.fromJson(jsonDecode(response.body));
  }

  /// Permanently deletes the message identified by `id`, along with any
  /// attachments related to the message.
  ///
  /// This operation cannot be undone. Returns a [Future] that completes once
  /// the message has been deleted.
  Future<void> delete(String id) async {
    final url = Uri.parse('${baseUrl}api/messages/$id');
    final response = await client.delete(url);

    if (response.statusCode != 204) {
      throw MailosaurError(response);
    }
  }

  /// Returns a list of your messages in summary form, for the inbox (server)
  /// identified by `server`.
  ///
  /// The summaries are returned sorted by received date, with the most
  /// recently-received messages appearing first. Use `page` and `itemsPerPage`
  /// to paginate, `receivedAfter` to only include messages received after a
  /// given time, and `dir` to control sort order.
  ///
  /// Returns a [Future] resolving to a [MessageListResult] containing the
  /// message summaries.
  Future<MessageListResult> list(String server, {int? page, int? itemsPerPage, int? receivedAfter, String? dir}) async {
    final url = Uri.parse('${baseUrl}api/messages');

    final params = {
      'server': server,
      'page': page?.toString(),
      'itemsPerPage': itemsPerPage?.toString(),
      'receivedAfter': receivedAfter?.toString(),
      'dir': dir
    }..removeWhere((key, value) => value == null);

    final response = await client.get(url.replace(queryParameters: params));

    if (response.statusCode != 200) {
      throw MailosaurError(response);
    }

    return MessageListResult.fromJson(jsonDecode(response.body));
  }

  /// Permanently deletes all messages within the inbox (server) identified by `server`.
  ///
  /// This operation cannot be undone. Returns a [Future] that completes once
  /// all messages within the inbox (server) have been deleted.
  Future<void> deleteAll(String server) async {
    final url = Uri.parse('${baseUrl}api/messages');
    final params = {'server': server};

    final response = await client.delete(url.replace(queryParameters: params));

    if (response.statusCode != 204) {
      throw MailosaurError(response);
    }
  }

  /// Returns a list of messages matching the given `criteria`, in summary form,
  /// for the inbox (server) identified by `server`.
  ///
  /// The messages are returned sorted by received date, with the most
  /// recently-received messages appearing first. Use `page` and `itemsPerPage`
  /// to paginate, `receivedAfter` to only include messages received after a
  /// given time, `dir` to control sort order, and `timeout` to wait (in
  /// milliseconds) for a matching message to arrive.
  ///
  /// Returns a [Future] resolving to a [MessageListResult] containing the
  /// matching message summaries.
  ///
  /// Throws a [MailosaurError] with error type `search_timeout` if no matching
  /// message is found before the timeout elapses, unless `errorOnTimeout` is
  /// set to false.
  Future<MessageListResult> search(String server, SearchCriteria criteria, {int? page, int? itemsPerPage, int? timeout, int? receivedAfter, bool errorOnTimeout = true, String? dir}) async {
    final url = Uri.parse('${baseUrl}api/messages/search');

    final params = {
      'server': server,
      'page': page?.toString(),
      'itemsPerPage': itemsPerPage?.toString(),
      'receivedAfter': receivedAfter?.toString(),
      'dir': dir
    }..removeWhere((key, value) => value == null);

    if (timeout == null) {
      final response = await client.post(url.replace(queryParameters: params), body: jsonEncode(criteria));

      if (response.statusCode != 200) {
        throw MailosaurError(response);
      }

      return MessageListResult.fromJson(jsonDecode(response.body));
    }

    final stopwatch = Stopwatch()..start();
    while (true) {
      final response = await client.post(url.replace(queryParameters: params), body: jsonEncode(criteria));

      if (response.statusCode != 200) {
        throw MailosaurError(response);
      }

      final result = MessageListResult.fromJson(jsonDecode(response.body));
      if (result.items.isNotEmpty) {
        return result;
      }

      if (stopwatch.elapsedMilliseconds > timeout) {
        if (errorOnTimeout) {
          throw MailosaurError(response);
        }
        return MessageListResult();
      }

      final delay = response.headers['x-ms-delay'];
      final delayDuration = delay != null ? int.tryParse(delay) ?? 1000 : 1000;
      await Future.delayed(Duration(milliseconds: delayDuration));
    }
  }

  /// Creates a new message that can be sent to a verified email address, within
  /// the inbox (server) identified by `server` and using the given `options`.
  ///
  /// This is useful in scenarios where you want an email to trigger a workflow
  /// in your product.
  ///
  /// Returns a [Future] resolving to the newly-created [Message].
  Future<Message> create(String server, MessageCreateOptions options) async {
    final url = Uri.parse('${baseUrl}api/messages');
    final params = {'server': server};

    final response = await client.post(url.replace(queryParameters: params), body: jsonEncode(options));

    if (response.statusCode != 200) {
      throw MailosaurError(response);
    }

    return Message.fromJson(jsonDecode(response.body));
  }

  /// Forwards the message identified by `id` to a verified email address, using
  /// the given `options`.
  ///
  /// This is useful for simulating a user forwarding one of your email messages.
  ///
  /// Returns a [Future] resolving to the forwarded [Message].
  Future<Message> forward(String id, MessageForwardOptions options) async {
    final url = Uri.parse('${baseUrl}api/messages/$id/forward');
    final response = await client.post(url, body: jsonEncode(options));

    if (response.statusCode != 200) {
      throw MailosaurError(response);
    }

    return Message.fromJson(jsonDecode(response.body));
  }

  /// Sends a reply to the message identified by `id`, using the given `options`.
  ///
  /// This is useful for simulating a user replying to one of your email or SMS
  /// messages.
  ///
  /// Returns a [Future] resolving to the reply [Message].
  Future<Message> reply(String id, MessageReplyOptions options) async {
    final url = Uri.parse('${baseUrl}api/messages/$id/reply');
    final response = await client.post(url, body: jsonEncode(options));

    if (response.statusCode != 200) {
      throw MailosaurError(response);
    }

    return Message.fromJson(jsonDecode(response.body));
  }

  /// Generates screenshots of the email identified by `id` rendered in the
  /// email clients specified by `options`.
  ///
  /// Returns a [Future] resolving to a [PreviewListResult] containing the
  /// generated previews.
  Future<PreviewListResult> generatePreviews(String id, PreviewRequestOptions options) async {
    final url = Uri.parse('${baseUrl}api/messages/$id/screenshots');
    final response = await client.post(url, body: jsonEncode(options));

    if (response.statusCode != 200) {
      throw MailosaurError(response);
    }

    return PreviewListResult.fromJson(jsonDecode(response.body));
  }
}
