import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mailosaur/mailosaur.dart';

class Analysis {
  final http.BaseClient client;
  final String baseUrl;

  Analysis(this.client, this.baseUrl);

  Future<SpamAnalysisResult> spam(String email) async {
    final url = Uri.parse('${baseUrl}api/analysis/spam/$email');
    final response = await client.get(url);

    if (response.statusCode != 200) {
      throw MailosaurError(response.statusCode, 'Failed to perform spam analysis', response.body);
    }

    return SpamAnalysisResult.fromJson(jsonDecode(response.body));
  }

  Future<DeliverabilityReport> deliverability(String email) async {
    final url = Uri.parse('${baseUrl}api/analysis/deliverability/$email');
    final response = await client.get(url);

    if (response.statusCode != 200) {
      throw MailosaurError(response.statusCode, 'Failed to perform deliverability analysis', response.body);
    }

    return DeliverabilityReport.fromJson(jsonDecode(response.body));
  }
}
