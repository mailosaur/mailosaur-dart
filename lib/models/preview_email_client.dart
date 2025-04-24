class PreviewEmailClient {
  final String id;
  final String name;
  final String platformGroup;
  final String platformType;
  final String platformVersion;
  final bool canDisableImages;
  final String status;

  const PreviewEmailClient({
    this.id = '',
    this.name = '',
    this.platformGroup = '',
    this.platformType = '',
    this.platformVersion = '',
    this.canDisableImages = false,
    this.status = '',
  });

  factory PreviewEmailClient.fromJson(Map<String, dynamic> json) {
    return PreviewEmailClient(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      platformGroup: json['platformGroup'] ?? '',
      platformType: json['platformType'] ?? '',
      platformVersion: json['platformVersion'] ?? '',
      canDisableImages: json['canDisableImages'] ?? false,
      status: json['status'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'platformGroup': platformGroup,
      'platformType': platformType,
      'platformVersion': platformVersion,
      'canDisableImages': canDisableImages,
      'status': status,
    };
  }
}
