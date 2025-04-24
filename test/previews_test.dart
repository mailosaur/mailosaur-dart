import 'dart:io';
import 'package:test/test.dart';
import 'mailer.dart';
import 'package:mailosaur/mailosaur.dart';

void main() {
  group('Previews Tests', () {
    late MailosaurClient client;
    late String server;

    setUpAll(() {
      final apiKey = Platform.environment['MAILOSAUR_API_KEY'];
      final baseUrl = Platform.environment['MAILOSAUR_BASE_URL'];
      server = Platform.environment['MAILOSAUR_PREVIEWS_SERVER'] ?? '';

      if (apiKey == null || apiKey.isEmpty) {
        throw Exception("Missing necessary environment variables - refer to README.md");
      }

      client = MailosaurClient(apiKey, baseUrl: baseUrl);
    });

    test('List email clients', () async {
      final result = await client.previews.listEmailClients();
      expect(result.items, isNotNull);
      expect(result.items.length, greaterThan(1));
    });

    test('Generate previews', () async {
      if (server.isEmpty) {
        print('SKIPPED: Requires server with previews enabled');
        return;
      }

      final randomString = List.generate(10, (index) => String.fromCharCode(65 + index)).join();
      final host = Platform.environment['MAILOSAUR_SMTP_HOST'] ?? 'mailosaur.net';
      final testEmailAddress = "$randomString@$server.$host";

      await Mailer.sendEmail(client, server, sendToAddress: testEmailAddress);

      final criteria = SearchCriteria(sentTo: testEmailAddress);
      final email = await client.messages.get(server, criteria);

      final request = PreviewRequestOptions(previews: [
        PreviewRequest(emailClient: 'OL2021')
      ]);

      final result = await client.messages.generatePreviews(email.id, request);

      expect(result.items, isNotNull);
      expect(result.items.length, greaterThan(0));

      // Ensure we can download one of the generated previews
      final file = client.files.getPreview(result.items[0].id);
      expect(file, isNotNull);
    });
  });
}
