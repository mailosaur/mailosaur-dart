import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mailosaur/mailosaur.dart';

class Previews {
  final http.BaseClient client;
  final String baseUrl;

  Previews(this.client, this.baseUrl);

  Future<PreviewEmailClientListResult> listEmailClients() async {
    final url = Uri.parse('${baseUrl}api/previews/clients');
    final response = await client.get(url);

    if (response.statusCode != 200) {
      throw MailosaurError(response);
    }

    return PreviewEmailClientListResult.fromJson(jsonDecode(response.body));
  }
}
