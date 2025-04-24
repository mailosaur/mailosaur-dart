import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mailosaur/mailosaur.dart';

class Usage {
  final http.BaseClient client;
  final String baseUrl;

  Usage(this.client, this.baseUrl);

  Future<UsageAccountLimits> limits() async {
    final url = Uri.parse('${baseUrl}api/usage/limits');
    final response = await client.get(url);

    if (response.statusCode != 200) {
      throw MailosaurError(response.statusCode, 'Failed to retrieve account usage limits', response.body);
    }

    return UsageAccountLimits.fromJson(jsonDecode(response.body));
  }

  Future<List<UsageTransaction>> transactions() async {
    final url = Uri.parse('${baseUrl}api/usage/transactions');
    final response = await client.get(url);

    if (response.statusCode != 200) {
      throw MailosaurError(response.statusCode, 'Failed to retrieve usage transactions', response.body);
    }

    final data = jsonDecode(response.body);
    return (data['items'] as List<dynamic>)
        .map((item) => UsageTransaction.fromJson(item))
        .toList();
  }
}
