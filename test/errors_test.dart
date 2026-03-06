import 'dart:io';
import 'package:test/test.dart';
import 'package:mailosaur/mailosaur.dart';

void main() {
  group('Errors Tests', () {
    late MailosaurClient client;

    setUpAll(() async {
      final baseUrl = Platform.environment['MAILOSAUR_BASE_URL'];
      client = MailosaurClient(baseUrl: baseUrl);
    });

    test('Unauthorized', () async {
      final client = MailosaurClient(apiKey: "invalid_key");
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
