import 'dart:io';
import 'package:test/test.dart';
import 'mailer.dart';
import 'dart:convert';
import 'package:mailosaur/mailosaur.dart';

void main() {
  group('Files Tests', () {
    late MailosaurClient client;
    late Message email;

    setUpAll(() async {
      final apiKey = Platform.environment['MAILOSAUR_API_KEY'];
      final baseUrl = Platform.environment['MAILOSAUR_BASE_URL'];
      final server = Platform.environment['MAILOSAUR_SERVER'];
      
      if (apiKey == null || apiKey.isEmpty || server == null || server.isEmpty) {
        throw Exception("Missing necessary environment variables - refer to README.md");
      }

      client = MailosaurClient(apiKey, baseUrl);

      await client.messages.deleteAll(server);

      final host = Platform.environment['MAILOSAUR_SMTP_HOST'] ?? 'mailosaur.net';
      final testEmailAddress = 'files_test@$server.$host';

      await Mailer.sendEmail(client, server, sendToAddress: testEmailAddress);

      final criteria = SearchCriteria(sentTo: testEmailAddress);
      email = await client.messages.get(server, criteria);
    });

    test('Get email', () async {
      final result = client.files.getEmail(email.id);
      final bytes = await result.toList();
      final content = utf8.decode(bytes.expand((chunk) => chunk).toList());
      expect(content, isNotNull);
      expect(content.length, greaterThan(1));
      expect(content.contains(email.subject), isTrue);
    });

    test('Get attachment', () async {
      final attachment = email.attachments[0];
      final result = client.files.getAttachment(attachment.id);
      expect(result, isNotNull);

      int fileLength = 0;
      await for (final chunk in result) {
        fileLength += chunk.length;
      }
      expect(fileLength, equals(attachment.length));
    });
  });
}
