class ServerCreateOptions {
  final String name;

  const ServerCreateOptions({
    this.name = '',
  });

  factory ServerCreateOptions.fromJson(Map<String, dynamic> json) {
    return ServerCreateOptions(
      name: json['name'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
    };
  }
}
