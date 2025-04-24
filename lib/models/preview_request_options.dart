import 'preview_request.dart';

class PreviewRequestOptions {
  List<PreviewRequest>? previews;

  PreviewRequestOptions({
    this.previews,
  });

  factory PreviewRequestOptions.fromJson(Map<String, dynamic> json) {
    return PreviewRequestOptions(
      previews: json['previews'] != null
          ? List<PreviewRequest>.from(
              json['previews'].map((item) => PreviewRequest.fromJson(item)))
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'previews': previews?.map((item) => item.toJson()).toList(),
    };
  }
}
