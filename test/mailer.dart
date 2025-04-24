import 'dart:io';
import 'dart:math';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

class Mailer {
  static final String html = File('test/resources/testEmail.html').readAsStringSync();
  static final String text = File('test/resources/testEmail.txt').readAsStringSync();
  static final String verifiedDomain = (Platform.environment['MAILOSAUR_VERIFIED_DOMAIN']?.isNotEmpty ?? false)
    ? Platform.environment['MAILOSAUR_VERIFIED_DOMAIN']!
    : 'mailosaur.net';

  static Future<void> sendEmails(dynamic client, String server, int quantity) async {
    for (int i = 0; i < quantity; i++) {
      await sendEmail(client, server);
    }
  }

  static Future<void> sendEmail(dynamic client, String server, { String? sendToAddress }) async {
    final String host = Platform.environment['MAILOSAUR_SMTP_HOST'] ?? 'mailosaur.net';
    final int port = int.parse(Platform.environment['MAILOSAUR_SMTP_PORT'] ?? '25');

    final String randomString = String.fromCharCodes(
      List.generate(10, (index) => Random().nextInt(26) + 65),
    );

    final String randomToAddress = sendToAddress ?? '$randomString@$server.$verifiedDomain';

    final message = Message()
      ..from = Address('$randomString@$verifiedDomain', '$randomString $randomString')
      ..recipients.add(Address(randomToAddress, '$randomString $randomString'))
      ..subject = '$randomString subject'
      ..text = text.replaceAll('REPLACED_DURING_TEST', randomString)
      ..html = html.replaceAll('REPLACED_DURING_TEST', randomString);

    // Attach cat.png
    final catImage = File('test/resources/cat.png');
    message.attachments.add(FileAttachment(catImage)
      ..cid = 'ii_1435fadb31d523f6'
      ..location = Location.inline);

    // Attach dog.png
    final dogImage = File('test/resources/dog.png');
    message.attachments.add(FileAttachment(dogImage)
      ..location = Location.attachment);

    final smtpServer = SmtpServer(host, port: port);

    try {
      print('Sending email to $randomToAddress $host $port');
      await send(message, smtpServer);
    } catch (e) {
      print('Failed to send email: $e');
    }
  }
}
