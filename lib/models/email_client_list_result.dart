import 'email_client.dart';

class EmailClientListResult {
  List<EmailClient> items;

  EmailClientListResult({
    required this.items,
  });

  factory EmailClientListResult.fromJson(Map<String, dynamic> json) {
    return EmailClientListResult(
      items: List<EmailClient>.from(
        json['items']?.map((item) => EmailClient.fromJson(item)) ?? [],
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'items': items.map((item) => item.toJson()).toList(),
    };
  }
}
