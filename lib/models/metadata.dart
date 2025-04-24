import 'message_address.dart';
import 'message_header.dart';

class Metadata {
  final List<MessageHeader> headers;
  final String ehlo;
  final String mailFrom;
  final List<MessageAddress> rcptTo;

  const Metadata({
    this.headers = const [],
    this.ehlo = '',
    this.mailFrom = '',
    this.rcptTo = const [],
  });

  factory Metadata.fromJson(Map<String, dynamic> json) {
    return Metadata(
      headers: json['headers'] != null
          ? List<MessageHeader>.from(
              json['headers'].map((item) => MessageHeader.fromJson(item)))
          : const [],
      ehlo: json['ehlo'] ?? '',
      mailFrom: json['mailFrom'] ?? '',
      rcptTo: json['rcptTo'] != null
          ? List<MessageAddress>.from(
              json['rcptTo'].map((item) => MessageAddress.fromJson(item)))
          : const [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'headers': headers.map((item) => item.toJson()).toList(),
      'ehlo': ehlo,
      'mailFrom': mailFrom,
      'rcptTo': rcptTo.map((item) => item.toJson()).toList(),
    };
  }
}
