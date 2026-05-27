import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mailosaur/mailosaur.dart';

/// Operations for analyzing the content and deliverability of an email,
/// including SpamAssassin scoring and per-provider deliverability reports.
///
/// Accessed via `client.analysis`.
class Analysis {
  final http.BaseClient client;
  final String baseUrl;

  Analysis(this.client, this.baseUrl);

  /// Performs a spam analysis of the message identified by `email`.
  ///
  /// Returns a [Future] resolving to a [SpamAnalysisResult] containing the spam
  /// score and filter results.
  Future<SpamAnalysisResult> spam(String email) async {
    final url = Uri.parse('${baseUrl}api/analysis/spam/$email');
    final response = await client.get(url);

    if (response.statusCode != 200) {
      throw MailosaurError(response);
    }

    return SpamAnalysisResult.fromJson(jsonDecode(response.body));
  }

  /// Performs a deliverability report of the message identified by `email`.
  ///
  /// Returns a [Future] resolving to a [DeliverabilityReport] for the email.
  Future<DeliverabilityReport> deliverability(String email) async {
    final url = Uri.parse('${baseUrl}api/analysis/deliverability/$email');
    final response = await client.get(url);

    if (response.statusCode != 200) {
      throw MailosaurError(response);
    }

    return DeliverabilityReport.fromJson(jsonDecode(response.body));
  }
}
