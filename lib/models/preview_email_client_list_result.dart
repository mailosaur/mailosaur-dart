import 'preview_email_client.dart';

class PreviewEmailClientListResult {
  List<PreviewEmailClient> items;

  PreviewEmailClientListResult({
    required this.items,
  });

  factory PreviewEmailClientListResult.fromJson(Map<String, dynamic> json) {
    return PreviewEmailClientListResult(
      items: List<PreviewEmailClient>.from(
        json['items']?.map((item) => PreviewEmailClient.fromJson(item)) ?? [],
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'items': items.map((item) => item.toJson()).toList(),
    };
  }
}
