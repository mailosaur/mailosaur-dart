import 'attachment.dart';

class MessageCreateOptions {
  final String to;
  final String cc;
  final String from;
  final bool send;
  final String subject;
  final String text;
  final String html;
  final List<Attachment> attachments;

  const MessageCreateOptions({
    this.to = '',
    this.cc = '',
    this.from = '',
    this.send = false,
    this.subject = '',
    this.text = '',
    this.html = '',
    this.attachments = const [],
  });

  factory MessageCreateOptions.fromJson(Map<String, dynamic> json) {
    return MessageCreateOptions(
      to: json['to'] ?? '',
      cc: json['cc'] ?? '',
      from: json['from'] ?? '',
      send: json['send'] ?? false,
      subject: json['subject'] ?? '',
      text: json['text'] ?? '',
      html: json['html'] ?? '',
      attachments: json['attachments'] != null
          ? List<Attachment>.from(
              json['attachments'].map((item) => Attachment.fromJson(item)))
          : const [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'to': to,
      'cc': cc,
      'from': from,
      'send': send,
      'subject': subject,
      'text': text,
      'html': html,
      'attachments': attachments.map((item) => item.toJson()).toList(),
    };
  }
}
