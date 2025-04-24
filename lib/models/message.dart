import 'attachment.dart';
import 'message_address.dart';
import 'message_content.dart';
import 'metadata.dart';

class Message {
  final String id;
  final String type;
  final List<MessageAddress> from;
  final List<MessageAddress> to;
  final List<MessageAddress> cc;
  final List<MessageAddress> bcc;
  final String received;
  final String subject;
  final MessageContent html;
  final MessageContent text;
  final List<Attachment> attachments;
  final Metadata metadata;
  final String server;

  const Message({
    this.id = '',
    this.type = '',
    this.from = const [],
    this.to = const [],
    this.cc = const [],
    this.bcc = const [],
    this.received = '',
    this.subject = '',
    this.html = const MessageContent(),
    this.text = const MessageContent(),
    this.attachments = const [],
    this.metadata = const Metadata(),
    this.server = '',
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'] ?? '',
      type: json['type'] ?? '',
      from: json['from'] != null
          ? List<MessageAddress>.from(
              json['from'].map((item) => MessageAddress.fromJson(item)))
          : const [],
      to: json['to'] != null
          ? List<MessageAddress>.from(
              json['to'].map((item) => MessageAddress.fromJson(item)))
          : const [],
      cc: json['cc'] != null
          ? List<MessageAddress>.from(
              json['cc'].map((item) => MessageAddress.fromJson(item)))
          : const [],
      bcc: json['bcc'] != null
          ? List<MessageAddress>.from(
              json['bcc'].map((item) => MessageAddress.fromJson(item)))
          : const [],
      received: json['received'] ?? '',
      subject: json['subject'] ?? '',
      html: json['html'] != null ? MessageContent.fromJson(json['html']) : const MessageContent(),
      text: json['text'] != null ? MessageContent.fromJson(json['text']) : const MessageContent(),
      attachments: json['attachments'] != null
          ? List<Attachment>.from(
              json['attachments'].map((item) => Attachment.fromJson(item)))
          : const [],
      metadata: json['metadata'] != null
          ? Metadata.fromJson(json['metadata'])
          : const Metadata(),
      server: json['server'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'from': from.map((item) => item.toJson()).toList(),
      'to': to.map((item) => item.toJson()).toList(),
      'cc': cc.map((item) => item.toJson()).toList(),
      'bcc': bcc.map((item) => item.toJson()).toList(),
      'received': received,
      'subject': subject,
      'html': html.toJson(),
      'text': text.toJson(),
      'attachments': attachments.map((item) => item.toJson()).toList(),
      'metadata': metadata.toJson(),
      'server': server,
    };
  }
}
