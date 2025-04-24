import 'dart:io';
import 'package:test/test.dart';
import 'mailer.dart';
import 'dart:convert';
import 'package:mailosaur/mailosaur.dart';

void main() {
  group('Emails Tests', () {
    late MailosaurClient client;
    late String server;
    late String verifiedDomain;
    late List<MessageSummary> emails;

    setUpAll(() async {
      final apiKey = Platform.environment['MAILOSAUR_API_KEY'];
      final baseUrl = Platform.environment['MAILOSAUR_BASE_URL'];
      server = Platform.environment['MAILOSAUR_SERVER'] ?? '';
      verifiedDomain = Platform.environment['MAILOSAUR_VERIFIED_DOMAIN'] ?? '';

      if (apiKey == null || apiKey.isEmpty || server.isEmpty) {
        throw Exception("Missing necessary environment variables - refer to README.md");
      }

      client = MailosaurClient(apiKey, baseUrl);

      await client.messages.deleteAll(server);

      await Mailer.sendEmails(client, server, 5);

      final result = await client.messages.list(server);
      emails = result.items;
    });

    test('List emails', () {
      expect(emails.length, equals(5));
      for (final email in emails) {
        expect(email.id, isNotNull);
        expect(email.subject, isNotNull);
      }
    });

    test('List emails, filter on received after date', () async {
      final pastDate = DateTime.now().millisecondsSinceEpoch - Duration(minutes: 10).inMilliseconds;
      final pastEmails = (await client.messages.list(server, receivedAfter: pastDate)).items;
      expect(pastEmails.length, greaterThan(0));

      final futureEmails = (await client.messages.list(server, receivedAfter: DateTime.now().millisecondsSinceEpoch + Duration(seconds: 1).inMilliseconds)).items;
      expect(futureEmails.length, equals(0));
    });

    test('get, return a match once found', () async {
      final host = Platform.environment['MAILOSAUR_SMTP_HOST'] ?? 'mailosaur.net';
      final testEmailAddress = 'wait_for_test@$server.$host';

      await Mailer.sendEmail(client, server, sendToAddress: testEmailAddress);

      final criteria = SearchCriteria(sentTo: testEmailAddress);
      final email = await client.messages.get(server, criteria);
      expect(email.id, isNotNull);
      expect(email.subject, isNotNull);
      
      // Clean up after test
      await client.messages.delete(email.id);
    });

    test('getById, return a single email', () async {
      final emailToRetrieve = emails[0];
      final email = await client.messages.getById(emailToRetrieve.id);
      expect(email.id, equals(emailToRetrieve.id));
      expect(email.subject, equals(emailToRetrieve.subject));
    });

    test('getById, throw an error if email not found', () async {
      try {
        await client.messages.getById('efe907e9-74ed-4113-a3e0-a3d41d914765');
        fail('Expected an exception for a non-existent email ID.');
      } catch (e) {
        expect(e, isA<Exception>());
      }
    });

    test('Search, throw exception if no criteria error', () async {
      try {
        await client.messages.search(server, SearchCriteria());
        fail('Expected an exception for missing search criteria.');
      } catch (e) {
        expect(e, isA<Exception>());
      }
    });

    test('Search, return empty array if errors suppressed', () async {
      final criteria = SearchCriteria(sentFrom: 'neverfound@example.com');
      final results = await client.messages.search(server, criteria, timeout: 1, errorOnTimeout: false);
      expect(results.items.length, equals(0));
    });

    test('Search emails by sentFrom, return matching results', () async {
      final targetEmail = emails[1];
      final criteria = SearchCriteria(sentFrom: targetEmail.from[0].email);
      final results = await client.messages.search(server, criteria);
      expect(results.items.length, equals(1));
      expect(results.items[0].from[0].email, equals(targetEmail.from[0].email));
      expect(results.items[0].subject, equals(targetEmail.subject));
    });

    test('Search emails by sentTo, return matching results', () async {
      final targetEmail = emails[1];
      final criteria = SearchCriteria(sentTo: targetEmail.to[0].email);
      final results = await client.messages.search(server, criteria);
      expect(results.items.length, equals(1));
      expect(results.items[0].to[0].email, equals(targetEmail.to[0].email));
      expect(results.items[0].subject, equals(targetEmail.subject));
    });

    test('Search emails by body, return matching results', () async {
      final targetEmail = emails[1];
      final uniqueString = targetEmail.subject.substring(0, 10);
      final criteria = SearchCriteria(body: '$uniqueString html');
      final results = await client.messages.search(server, criteria);
      expect(results.items.length, equals(1));
      expect(results.items[0].to[0].email, equals(targetEmail.to[0].email));
      expect(results.items[0].subject, equals(targetEmail.subject));
    });

    test('Search emails by subject, return matching results', () async {
      final targetEmail = emails[1];
      final uniqueString = targetEmail.subject.substring(0, 10);
      final criteria = SearchCriteria(subject: uniqueString);
      final results = await client.messages.search(server, criteria);
      expect(results.items.length, equals(1));
      expect(results.items[0].to[0].email, equals(targetEmail.to[0].email));
      expect(results.items[0].subject, equals(targetEmail.subject));
    });

    test('Search emails with match all criteria', () async {
      final targetEmail = emails[1];
      final uniqueString = targetEmail.subject.substring(0, 10);
      final criteria = SearchCriteria(subject: uniqueString, body: 'this is a link', match: 'ALL');
      final results = await client.messages.search(server, criteria);
      expect(results.items.length, equals(1));
    });

    test('Search emails with match any criteria', () async {
      final targetEmail = emails[1];
      final uniqueString = targetEmail.subject.substring(0, 10);
      final criteria = SearchCriteria(subject: uniqueString, body: 'this is a link', match: 'ANY');
      final results = await client.messages.search(server, criteria);
      expect(results.items.length, equals(5));
    });

    test('Search emails with special characters', () async {
      final criteria = SearchCriteria(subject: 'Search with ellipsis … and emoji 👨🏿‍🚒');
      final results = await client.messages.search(server, criteria);
      expect(results.items.length, equals(0));
    }, skip: true);

     test('Perform a spam analysis on an email', () async {
      final targetId = emails[0].id;
      final result = await client.analysis.spam(targetId);

      for (final rule in result.spamFilterResults.spamAssassin) {
        expect(rule.rule, isNotNull);
        expect(rule.description, isNotNull);
      }
    });

    test('Perform a deliverability report on an email', () async {
      final targetId = emails[0].id;
      final result = await client.analysis.deliverability(targetId);

      expect(result, isNotNull);
      expect(result.spf, isNotNull);
      expect(result.dmarc, isNotNull);

      for (final dkim in result.dkim) {
        expect(dkim, isNotNull);
      }

      expect(result.blockLists, isNotNull);
      for (final blockList in result.blockLists) {
        expect(blockList.id, isNotNull);
        expect(blockList.name, isNotNull);
      }

      expect(result.content, isNotNull);
      expect(result.dnsRecords, isNotNull);
      expect(result.dnsRecords.a, isNotNull);
      expect(result.dnsRecords.mx, isNotNull);
      expect(result.dnsRecords.ptr, isNotNull);

      expect(result.spamAssassin, isNotNull);
      expect(result.spamAssassin.result, isNotNull);
      expect(result.spamAssassin.score, isNotNull);
      for (final rule in result.spamAssassin.rules) {
        expect(rule.rule, isNotNull);
        expect(rule.description, isNotNull);
      }
    });

    test('Delete an email', () async {
      final targetEmailId = emails[4].id;
      await client.messages.delete(targetEmailId);

      // Attempting to delete again should fail
      try {
        await client.messages.delete(targetEmailId);
        fail('Expected an exception when deleting a non-existent email.');
      } catch (e) {
        expect(e, isA<Exception>());
      }
    });

    test('Create and send email with text', () async {
      if (verifiedDomain.isEmpty) {
        print('SKIPPED: Requires verified domain secret');
        return;
      }

      final subject = 'New message';
      final options = MessageCreateOptions(
        to: 'anything@$verifiedDomain',
        send: true,
        subject: subject,
        text: 'This is a new email',
      );
      final message = await client.messages.create(server, options);
      expect(message.id, isNotNull);
      expect(message.subject, equals(subject));
    });

    test('Create and send email with HTML', () async {
      if (verifiedDomain.isEmpty) {
        print('SKIPPED: Requires verified domain secret');
        return;
      }

      final subject = 'New HTML message';
      final options = MessageCreateOptions(
        to: 'anything@$verifiedDomain',
        send: true,
        subject: subject,
        html: '<p>This is a new email.</p>',
      );
      final message = await client.messages.create(server, options);
      expect(message.id, isNotNull);
      expect(message.subject, equals(subject));
    });

    test('Create and send email with CC', () async {
      if (verifiedDomain.isEmpty) {
        print('SKIPPED: Requires verified domain secret');
        return;
      }

      final subject = 'CC message';
      final ccRecipient = 'someoneelse@$verifiedDomain';
      final options = MessageCreateOptions(
        to: 'anything@$verifiedDomain',
        send: true,
        subject: subject,
        html: '<p>This is a new email.</p>',
        cc: ccRecipient,
      );
      final message = await client.messages.create(server, options);

      expect(message.id, isNotNull);
      expect(message.subject, equals(subject));
      expect(message.cc.length, equals(1));
      expect(message.cc[0].email, equals(ccRecipient));
    });

    test('Create and send email with attachment', () async {
      if (verifiedDomain.isEmpty) {
        print('SKIPPED: Requires verified domain secret');
        return;
      }

      final subject = 'New message with attachment';
      final file = File('test/resources/cat.png');
      final attachment = Attachment(
        fileName: 'cat.png',
        content: base64Encode(file.readAsBytesSync()),
        contentType: 'image/png',
      );
      final options = MessageCreateOptions(
        to: 'anything@$verifiedDomain',
        send: true,
        subject: subject,
        html: '<p>This is a new email.</p>',
        attachments: [attachment],
      );
      final message = await client.messages.create(server, options);

      expect(message.attachments.length, equals(1));
      final file1 = message.attachments[0];
      expect(file1.id, isNotNull);
      expect(file1.url, isNotNull);
      expect(file1.fileName, equals('cat.png'));
      expect(file1.contentType, equals('image/png'));
    });

        test('Forward email with text', () async {
      if (verifiedDomain.isEmpty) {
        print('SKIPPED: Requires verified domain secret');
        return;
      }

      final body = 'Forwarded message';

      final targetEmail = emails[0];
      final options = MessageForwardOptions(
        to: 'anything@$verifiedDomain',
        text: body,
      );
      final forwardedMessage = await client.messages.forward(targetEmail.id, options);

      expect(forwardedMessage.id, isNotNull);
      expect(forwardedMessage.text.body, contains(body));
    });

    test('Forward email with HTML', () async {
      if (verifiedDomain.isEmpty) {
        print('SKIPPED: Requires verified domain secret');
        return;
      }

      final body = '<p>Forwarded <strong>HTML</strong> message.</p>';

      final targetEmail = emails[0];
      final options = MessageForwardOptions(
        to: 'anything@$verifiedDomain',
        html: body,
      );
      final forwardedMessage = await client.messages.forward(targetEmail.id, options);

      expect(forwardedMessage.id, isNotNull);
      expect(forwardedMessage.html.body, contains(body));
    });

    test('Forward email with cc recipient', () async {
      if (verifiedDomain.isEmpty) {
        print('SKIPPED: Requires verified domain secret');
        return;
      }

      final body = '<p>Forwarded <strong>HTML</strong> message.</p>';

      final targetEmail = emails[0];
      final ccRecipient = 'someoneelse@$verifiedDomain';
      final options = MessageForwardOptions(
        to: 'anything@$verifiedDomain',
        html: body,
        cc: ccRecipient,
      );
      final forwardedMessage = await client.messages.forward(targetEmail.id, options);

      expect(forwardedMessage.id, isNotNull);
      expect(forwardedMessage.html.body, contains(body));
      expect(forwardedMessage.cc.length, equals(1));
      expect(forwardedMessage.cc[0].email, equals(ccRecipient));
    });

    test('Reply to email with text', () async {
      if (verifiedDomain.isEmpty) {
        print('SKIPPED: Requires verified domain secret');
        return;
      }

      final body = 'Reply message';

      final targetEmail = emails[0];
      final options = MessageReplyOptions(
        text: body,
      );
      final replyMessage = await client.messages.reply(targetEmail.id, options);

      expect(replyMessage.id, isNotNull);
      expect(replyMessage.text.body, contains(body));
    });

    test('Reply to email with HTML', () async {
      if (verifiedDomain.isEmpty) {
        print('SKIPPED: Requires verified domain secret');
        return;
      }

      final body = '<p>Reply <strong>HTML</strong> message.</p>';

      final targetEmail = emails[0];
      final options = MessageReplyOptions(
        html: body,
      );
      final replyMessage = await client.messages.reply(targetEmail.id, options);

      expect(replyMessage.id, isNotNull);
      expect(replyMessage.html.body, contains(body));
    });

    test('Reply to email with CC', () async {
      if (verifiedDomain.isEmpty) {
        print('SKIPPED: Requires verified domain secret');
        return;
      }

      final body = '<p>Reply <strong>HTML</strong> message.</p>';

      final targetEmail = emails[0];
      final ccRecipient = 'someoneelse@$verifiedDomain';
      final options = MessageReplyOptions(
        html: body,
        cc: ccRecipient,
      );
      final replyMessage = await client.messages.reply(targetEmail.id, options);

      expect(replyMessage.id, isNotNull);
      expect(replyMessage.html.body, contains(body));
      expect(replyMessage.cc.length, equals(1));
      expect(replyMessage.cc[0].email, equals(ccRecipient));
    });

    test('Reply to email with attachments', () async {
      if (verifiedDomain.isEmpty) {
        print('SKIPPED: Requires verified domain secret');
        return;
      }

      final targetEmail = emails[0];
      final file = File('test/resources/cat.png');
      final attachment = Attachment(
        fileName: 'cat.png',
        content: base64Encode(file.readAsBytesSync()),
        contentType: 'image/png',
      );
      final options = MessageReplyOptions(
        html: '<p>Replying to this email.</p>',
        attachments: [attachment],
      );
      final replyMessage = await client.messages.reply(targetEmail.id, options);

      expect(replyMessage.attachments.length, equals(1));
      final file1 = replyMessage.attachments[0];
      expect(file1.id, isNotNull);
      expect(file1.url, isNotNull);
      expect(file1.fileName, equals('cat.png'));
      expect(file1.contentType, equals('image/png'));
    });
  });
}
