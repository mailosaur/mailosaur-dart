class Preview {
  final String id;
  final String emailClient;
  final bool disableImages;

  const Preview({
    this.id = '',
    this.emailClient = '',
    this.disableImages = false,
  });

  factory Preview.fromJson(Map<String, dynamic> json) {
    return Preview(
      id: json['id'] ?? '',
      emailClient: json['emailClient'] ?? '',
      disableImages: json['disableImages'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'emailClient': emailClient,
      'disableImages': disableImages,
    };
  }
}
