import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mailosaur/mailosaur.dart';

/// Operations for discovering the email clients available for generating email
/// previews (screenshots of an email rendered in real clients).
///
/// Accessed via `client.previews`.
class Previews {
  final http.BaseClient client;
  final String baseUrl;

  Previews(this.client, this.baseUrl);

  /// Lists all email clients that can be used to generate email previews.
  ///
  /// Returns a [Future] resolving to an [EmailClientListResult] of available
  /// email clients.
  Future<EmailClientListResult> listEmailClients() async {
    final url = Uri.parse('${baseUrl}api/screenshots/clients');
    final response = await client.get(url);

    if (response.statusCode != 200) {
      throw MailosaurError(response);
    }

    return EmailClientListResult.fromJson(jsonDecode(response.body));
  }
}
