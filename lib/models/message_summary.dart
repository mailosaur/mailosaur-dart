import 'message_address.dart';

class MessageSummary {
  final String id;
  final String type;
  final String server;
  final List<MessageAddress> from;
  final List<MessageAddress> to;
  final List<MessageAddress> cc;
  final List<MessageAddress> bcc;
  final String received;
  final String subject;
  final String summary;
  final int attachments;

  const MessageSummary({
    this.id = '',
    this.type = '',
    this.server = '',
    this.from = const [],
    this.to = const [],
    this.cc = const [],
    this.bcc = const [],
    this.received = '',
    this.subject = '',
    this.summary = '',
    this.attachments = 0,
  });

  factory MessageSummary.fromJson(Map<String, dynamic> json) {
    return MessageSummary(
      id: json['id'] ?? '',
      type: json['type'] ?? '',
      server: json['server'] ?? '',
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
      summary: json['summary'] ?? '',
      attachments: json['attachments'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'server': server,
      'from': from.map((item) => item.toJson()).toList(),
      'to': to.map((item) => item.toJson()).toList(),
      'cc': cc.map((item) => item.toJson()).toList(),
      'bcc': bcc.map((item) => item.toJson()).toList(),
      'received': received,
      'subject': subject,
      'summary': summary,
      'attachments': attachments,
    };
  }
}
