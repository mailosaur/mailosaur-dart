import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mailosaur/mailosaur.dart';

/// Operations for inspecting your account's usage limits and recent
/// transactional usage.
///
/// These endpoints require authentication with an account-level API key.
/// Accessed via `client.usage`.
class Usage {
  final http.BaseClient client;
  final String baseUrl;

  Usage(this.client, this.baseUrl);

  /// Retrieves account usage limits, detailing the current limits and usage for
  /// your account.
  ///
  /// This endpoint requires authentication with an account-level API key.
  ///
  /// Returns a [Future] resolving to the [UsageAccountLimits] for your account.
  Future<UsageAccountLimits> limits() async {
    final url = Uri.parse('${baseUrl}api/usage/limits');
    final response = await client.get(url);

    if (response.statusCode != 200) {
      throw MailosaurError(response);
    }

    return UsageAccountLimits.fromJson(jsonDecode(response.body));
  }

  /// Retrieves the last 31 days of transactional usage.
  ///
  /// This endpoint requires authentication with an account-level API key.
  ///
  /// Returns a [Future] resolving to a list of [UsageTransaction] for the last
  /// 31 days.
  Future<List<UsageTransaction>> transactions() async {
    final url = Uri.parse('${baseUrl}api/usage/transactions');
    final response = await client.get(url);

    if (response.statusCode != 200) {
      throw MailosaurError(response);
    }

    final data = jsonDecode(response.body);
    return (data['items'] as List<dynamic>)
        .map((item) => UsageTransaction.fromJson(item))
        .toList();
  }
}
