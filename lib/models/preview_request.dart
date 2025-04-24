class PreviewRequest {
  final String emailClient;
  final bool disableImages;

  const PreviewRequest({
    required this.emailClient,
    this.disableImages = false,
  });

  factory PreviewRequest.fromJson(Map<String, dynamic> json) {
    return PreviewRequest(
      emailClient: json['emailClient'],
      disableImages: json['disableImages'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'emailClient': emailClient,
      'disableImages': disableImages,
    };
  }
}
