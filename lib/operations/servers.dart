import 'dart:io';
import 'dart:math';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mailosaur/mailosaur.dart';

/// Operations for creating and managing your Mailosaur inboxes (servers) — they
/// group your tests together, each with its own domain and
/// SMTP/POP3/IMAP credentials.
///
/// Accessed via `client.servers`.
class Servers {
  final http.BaseClient client;
  final String baseUrl;

  Servers(this.client, this.baseUrl);

  /// Generates a random email address by appending a random string in front of
  /// the domain name of the inbox (server) identified by `server`.
  ///
  /// Returns a random email address ending in the domain of the inbox (server).
  String generateEmailAddress(String server) {
    final host = Platform.environment['MAILOSAUR_SMTP_HOST'] ?? 'mailosaur.net';
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
    final rand = Random();
    final randomString = String.fromCharCodes(
      List.generate(10, (_) => chars.codeUnitAt(rand.nextInt(chars.length)))
    );
    return "$randomString@$server.$host";
  }

  /// Returns a list of your inboxes (servers), sorted in alphabetical order.
  ///
  /// Returns a [Future] resolving to a [ServerListResult] containing your inboxes (servers).
  Future<ServerListResult> list() async {
    final url = Uri.parse('${baseUrl}api/servers');
    final response = await client.get(url);

    if (response.statusCode != 200) {
      throw MailosaurError(response);
    }

    return ServerListResult.fromJson(jsonDecode(response.body));
  }

  /// Creates a new inbox (server), using the options given in
  /// `serverCreateOptions`.
  ///
  /// Returns a [Future] resolving to the newly-created [Server].
  Future<Server> create(ServerCreateOptions serverCreateOptions) async {
    final url = Uri.parse('${baseUrl}api/servers');
    final response = await client.post(url, body: jsonEncode(serverCreateOptions.toJson()));

    if (response.statusCode != 200) {
      throw MailosaurError(response);
    }

    return Server.fromJson(jsonDecode(response.body));
  }

  /// Retrieves the detail for the single inbox (server) identified by `id`.
  ///
  /// Returns a [Future] resolving to the [Server].
  Future<Server> get(String id) async {
    final url = Uri.parse('${baseUrl}api/servers/$id');
    final response = await client.get(url);

    if (response.statusCode != 200) {
      throw MailosaurError(response);
    }

    return Server.fromJson(jsonDecode(response.body));
  }

  /// Retrieves the password for the inbox (server) identified by `id`.
  ///
  /// This password can be used for SMTP, POP3, and IMAP connectivity.
  ///
  /// Returns a [Future] resolving to the password for the inbox (server).
  Future<String> getPassword(String id) async {
    final url = Uri.parse('${baseUrl}api/servers/$id/password');
    final response = await client.get(url);

    if (response.statusCode != 200) {
      throw MailosaurError(response);
    }

    final data = jsonDecode(response.body);
    return data['value'];
  }

  /// Permanently deletes the inbox (server) identified by `id`.
  ///
  /// This will also delete all messages, associated attachments, etc. within
  /// the inbox (server). This operation cannot be undone. Returns a [Future] that
  /// completes once the inbox (server) has been deleted.
  Future<void> delete(String id) async {
    final url = Uri.parse('${baseUrl}api/servers/$id');
    final response = await client.delete(url);

    if (response.statusCode != 204) {
      throw MailosaurError(response);
    }
  }

  /// Updates the attributes of the inbox (server) identified by `id`, applying the
  /// values supplied in `server`.
  ///
  /// Returns a [Future] resolving to the updated inbox (server).
  Future<Map<String, dynamic>> update(String id, Map<String, dynamic> server) async {
    final url = Uri.parse('${baseUrl}api/servers/$id');
    final response = await client.put(url, body: jsonEncode(server));

    if (response.statusCode != 200) {
      throw MailosaurError(response);
    }

    return jsonDecode(response.body);
  }
}
