import 'dart:io';
import 'package:test/test.dart';
import 'package:mailosaur/mailosaur.dart';

void main() {
  group('Usage Tests', () {
    late MailosaurClient client;

    setUpAll(() {
      final apiKey = Platform.environment['MAILOSAUR_API_KEY'];
      final baseUrl = Platform.environment['MAILOSAUR_BASE_URL'];
      
      if (apiKey == null || apiKey.isEmpty) {
        throw Exception("Missing necessary environment variables - refer to README.md");
      }

      client = MailosaurClient(apiKey, baseUrl: baseUrl);
    });

    test('Account limits', () async {
      final result = await client.usage.limits();
      expect(result.servers.limit, greaterThan(0));
      expect(result.users.limit, greaterThan(0));
      expect(result.email.limit, greaterThan(0));
      expect(result.sms.limit, greaterThan(0));
    });

    test('Transactions list', () async {
      final result = await client.usage.transactions();
      expect(result.length, greaterThan(1));
      expect(result[0].timestamp, isNotNull);
      expect(result[0].email, isNotNull);
      expect(result[0].sms, isNotNull);
    });
  });
}
