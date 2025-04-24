class DeviceCreateOptions {
  final String name;
  final String sharedSecret;

  const DeviceCreateOptions({
    this.name = '',
    this.sharedSecret = '',
  });

  factory DeviceCreateOptions.fromJson(Map<String, dynamic> json) {
    return DeviceCreateOptions(
      name: json['name'] ?? '',
      sharedSecret: json['sharedSecret'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'sharedSecret': sharedSecret,
    };
  }
}
