import 'attachment.dart';

class MessageReplyOptions {
  final String text;
  final String html;
  final String cc;
  final List<Attachment> attachments;

  const MessageReplyOptions({
    this.text = '',
    this.html = '',
    this.cc = '',
    this.attachments = const [],
  });

  factory MessageReplyOptions.fromJson(Map<String, dynamic> json) {
    return MessageReplyOptions(
      text: json['text'] ?? '',
      html: json['html'] ?? '',
      cc: json['cc'] ?? '',
      attachments: json['attachments'] != null
          ? List<Attachment>.from(
              json['attachments'].map((item) => Attachment.fromJson(item)))
          : const [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'html': html,
      'cc': cc,
      'attachments': attachments.map((item) => item.toJson()).toList(),
    };
  }
}
