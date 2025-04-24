import 'message_summary.dart';

class MessageListResult {
  final List<MessageSummary> items;

  const MessageListResult({
    this.items = const [],
  });

  factory MessageListResult.fromJson(Map<String, dynamic> json) {
    return MessageListResult(
      items: json['items'] != null
          ? List<MessageSummary>.from(
              json['items'].map((item) => MessageSummary.fromJson(item)))
          : const [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'items': items.map((item) => item.toJson()).toList(),
    };
  }
}
