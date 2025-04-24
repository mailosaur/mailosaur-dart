import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mailosaur/mailosaur.dart';

class Messages {
  final http.BaseClient client;
  final String baseUrl;

  Messages(this.client, this.baseUrl);

  Future<Message> get(String server, SearchCriteria criteria, {int timeout = 10000, int? receivedAfter, String? dir}) async {
    if (server.length != 8) {
      throw Exception("Must provide a valid Server ID.");
    }

    final result = await search(server, criteria, timeout: timeout, receivedAfter: receivedAfter, dir: dir);
    return await getById(result.items?[0].id ?? '');
  }

  Future<Message> getById(String id) async {
    final url = Uri.parse('${baseUrl}api/messages/$id');
    final response = await client.get(url);

    if (response.statusCode != 200) {
      throw MailosaurError(response.statusCode, 'Failed to retrieve message', response.body);
    }

    return Message.fromJson(jsonDecode(response.body));
  }

  Future<void> delete(String id) async {
    final url = Uri.parse('${baseUrl}api/messages/$id');
    final response = await client.delete(url);

    if (response.statusCode != 204) {
      throw MailosaurError(response.statusCode, 'Failed to delete message', response.body);
    }
  }

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
      throw MailosaurError(response.statusCode, 'Failed to list messages', response.body);
    }

    return MessageListResult.fromJson(jsonDecode(response.body));
  }

  Future<void> deleteAll(String server) async {
    final url = Uri.parse('${baseUrl}api/messages');
    final params = {'server': server};

    final response = await client.delete(url.replace(queryParameters: params));

    if (response.statusCode != 204) {
      throw MailosaurError(response.statusCode, 'Failed to delete all messages', response.body);
    }
  }

  Future<MessageListResult> search(String server, SearchCriteria criteria, {int? page, int? itemsPerPage, int? timeout, int? receivedAfter, bool errorOnTimeout = true, String? dir}) async {
    final url = Uri.parse('${baseUrl}api/messages/search');

    final params = {
      'server': server,
      'page': page?.toString(),
      'itemsPerPage': itemsPerPage?.toString(),
      'receivedAfter': receivedAfter?.toString(),
      'dir': dir
    }..removeWhere((key, value) => value == null);

    final stopwatch = Stopwatch()..start();
    while (true) {
      final response = await client.post(url.replace(queryParameters: params), body: jsonEncode(criteria));

      if (response.statusCode != 200) {
        throw MailosaurError(response.statusCode, 'Failed to search messages', response.body);
      }

      final result = MessageListResult.fromJson(jsonDecode(response.body));
      if (result.items != null && result.items.isNotEmpty) {
        return result;
      }

      if (timeout != null && stopwatch.elapsedMilliseconds > timeout) {
        if (errorOnTimeout) {
          throw MailosaurError(response.statusCode, 'Search timed out', response.body);
        } else {
          return MessageListResult();
        }
      }

      final delay = response.headers['x-ms-delay'];
      final delayDuration = delay != null ? int.tryParse(delay) ?? 1000 : 1000;
      await Future.delayed(Duration(milliseconds: delayDuration));
    }
  }

  Future<Message> create(String server, MessageCreateOptions options) async {
    final url = Uri.parse('${baseUrl}api/messages');
    final params = {'server': server};

    final response = await client.post(url.replace(queryParameters: params), body: jsonEncode(options));

    if (response.statusCode != 200) {
      throw MailosaurError(response.statusCode, 'Failed to create message', response.body);
    }

    return Message.fromJson(jsonDecode(response.body));
  }

  Future<Message> forward(String id, MessageForwardOptions options) async {
    final url = Uri.parse('${baseUrl}api/messages/$id/forward');
    final response = await client.post(url, body: jsonEncode(options));

    if (response.statusCode != 200) {
      throw MailosaurError(response.statusCode, 'Failed to forward message', response.body);
    }

    return jsonDecode(response.body);
  }

  Future<Message> reply(String id, MessageReplyOptions options) async {
    final url = Uri.parse('${baseUrl}api/messages/$id/reply');
    final response = await client.post(url, body: jsonEncode(options));

    if (response.statusCode != 200) {
      throw MailosaurError(response.statusCode, 'Failed to reply to message', response.body);
    }

    return jsonDecode(response.body);
  }

  Future<PreviewListResult> generatePreviews(String id, PreviewRequestOptions options) async {
    final url = Uri.parse('${baseUrl}api/messages/$id/previews');
    final response = await client.post(url, body: jsonEncode(options));

    if (response.statusCode != 200) {
      throw MailosaurError(response.statusCode, 'Failed to generate previews', response.body);
    }

    return PreviewListResult.fromJson(jsonDecode(response.body));
  }
}
