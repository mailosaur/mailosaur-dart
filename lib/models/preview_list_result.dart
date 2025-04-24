import 'preview.dart';

class PreviewListResult {
  List<Preview> items;

  PreviewListResult({
    required this.items,
  });

  factory PreviewListResult.fromJson(Map<String, dynamic> json) {
    return PreviewListResult(
      items: List<Preview>.from(
        json['items']?.map((item) => Preview.fromJson(item)) ?? [],
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'items': items?.map((item) => item.toJson()).toList(),
    };
  }
}
