import 'dart:io';
import 'package:test/test.dart';
import 'package:mailosaur/mailosaur.dart';

void main() {
  group('Errors Tests', () {
    late MailosaurClient client;

    setUpAll(() async {
      final apiKey = Platform.environment['MAILOSAUR_API_KEY'];
      final baseUrl = Platform.environment['MAILOSAUR_BASE_URL'];
      
      if (apiKey == null || apiKey.isEmpty) {
        throw Exception("Missing necessary environment variables - refer to README.md");
      }

      client = MailosaurClient(apiKey, baseUrl: baseUrl);
    });

    test('Unauthorized', () async {
      final client = MailosaurClient("invalid_key");
      try {
        await client.servers.list();
        fail('Expected an exception to be thrown');
      } catch (e) {
        expect(e, isA<MailosaurError>());
        expect(e.toString(), contains('Authentication failed, check your API key.'));
      }
    });

    test('Not Found', () async {
      try {
        await client.servers.get("not_found");
        fail('Expected an exception to be thrown');
      } catch (e) {
        expect(e, isA<MailosaurError>());
        expect(e.toString(), contains('Not found, check input parameters.'));
      }
    });

    test('Bad Request', () async {
      try {
        await client.servers.create(ServerCreateOptions());
        fail('Expected an exception to be thrown');
      } catch (e) {
        expect(e, isA<MailosaurError>());
        expect(e.toString(), contains('Servers need a name'));
      }
    });
  });
}
