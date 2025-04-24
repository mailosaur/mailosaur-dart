import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mailosaur/mailosaur.dart';

class Servers {
  final http.BaseClient client;
  final String baseUrl;

  Servers(this.client, this.baseUrl);

  Future<String> generateEmailAddress(String server) async {
    final host = Platform.environment['MAILOSAUR_SMTP_HOST'] ?? 'mailosaur.net';
    final randomString = List.generate(10, (index) => (index % 2 == 0 ? 'A' : '0')).join();
    return "$randomString@$server.$host";
  }

  Future<ServerListResult> list() async {
    final url = Uri.parse('${baseUrl}api/servers');
    final response = await client.get(url);

    if (response.statusCode != 200) {
      throw MailosaurError(response.statusCode, 'Failed to list servers', response.body);
    }

    return ServerListResult.fromJson(jsonDecode(response.body));
  }

  Future<Server> create(ServerCreateOptions serverCreateOptions) async {
    final url = Uri.parse('${baseUrl}api/servers');
    final response = await client.post(url, body: jsonEncode(serverCreateOptions.toJson()));

    if (response.statusCode != 200) {
      throw MailosaurError(response.statusCode, 'Failed to create server', response.body);
    }

    return Server.fromJson(jsonDecode(response.body));
  }

  Future<Server> get(String id) async {
    final url = Uri.parse('${baseUrl}api/servers/$id');
    final response = await client.get(url);

    if (response.statusCode != 200) {
      throw MailosaurError(response.statusCode, 'Failed to retrieve server', response.body);
    }

    return Server.fromJson(jsonDecode(response.body));
  }

  Future<String> getPassword(String id) async {
    final url = Uri.parse('${baseUrl}api/servers/$id/password');
    final response = await client.get(url);

    if (response.statusCode != 200) {
      throw MailosaurError(response.statusCode, 'Failed to retrieve server password', response.body);
    }

    final data = jsonDecode(response.body);
    return data['value'];
  }

  Future<void> delete(String id) async {
    final url = Uri.parse('${baseUrl}api/servers/$id');
    final response = await client.delete(url);

    if (response.statusCode != 204) {
      throw MailosaurError(response.statusCode, 'Failed to delete server', response.body);
    }
  }

  Future<Map<String, dynamic>> update(String id, Map<String, dynamic> server) async {
    final url = Uri.parse('${baseUrl}api/servers/$id');
    final response = await client.put(url, body: jsonEncode(server));

    if (response.statusCode != 200) {
      throw MailosaurError(response.statusCode, 'Failed to update server', response.body);
    }

    return jsonDecode(response.body);
  }
}
