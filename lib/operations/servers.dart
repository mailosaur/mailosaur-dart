import 'dart:io';
import 'dart:math';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mailosaur/mailosaur.dart';

class Servers {
  final http.BaseClient client;
  final String baseUrl;

  Servers(this.client, this.baseUrl);

  String generateEmailAddress(String server) {
    final host = Platform.environment['MAILOSAUR_SMTP_HOST'] ?? 'mailosaur.net';
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
    final rand = Random();
    final randomString = String.fromCharCodes(
      List.generate(10, (_) => chars.codeUnitAt(rand.nextInt(chars.length)))
    );
    return "$randomString@$server.$host";
  }

  Future<ServerListResult> list() async {
    final url = Uri.parse('${baseUrl}api/servers');
    final response = await client.get(url);

    if (response.statusCode != 200) {
      throw MailosaurError(response);
    }

    return ServerListResult.fromJson(jsonDecode(response.body));
  }

  Future<Server> create(ServerCreateOptions serverCreateOptions) async {
    final url = Uri.parse('${baseUrl}api/servers');
    final response = await client.post(url, body: jsonEncode(serverCreateOptions.toJson()));

    if (response.statusCode != 200) {
      throw MailosaurError(response);
    }

    return Server.fromJson(jsonDecode(response.body));
  }

  Future<Server> get(String id) async {
    final url = Uri.parse('${baseUrl}api/servers/$id');
    final response = await client.get(url);

    if (response.statusCode != 200) {
      throw MailosaurError(response);
    }

    return Server.fromJson(jsonDecode(response.body));
  }

  Future<String> getPassword(String id) async {
    final url = Uri.parse('${baseUrl}api/servers/$id/password');
    final response = await client.get(url);

    if (response.statusCode != 200) {
      throw MailosaurError(response);
    }

    final data = jsonDecode(response.body);
    return data['value'];
  }

  Future<void> delete(String id) async {
    final url = Uri.parse('${baseUrl}api/servers/$id');
    final response = await client.delete(url);

    if (response.statusCode != 204) {
      throw MailosaurError(response);
    }
  }

  Future<Map<String, dynamic>> update(String id, Map<String, dynamic> server) async {
    final url = Uri.parse('${baseUrl}api/servers/$id');
    final response = await client.put(url, body: jsonEncode(server));

    if (response.statusCode != 200) {
      throw MailosaurError(response);
    }

    return jsonDecode(response.body);
  }
}
