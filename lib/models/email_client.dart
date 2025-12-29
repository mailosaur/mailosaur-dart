class EmailClient {
  final String label;
  final String name;

  const EmailClient({
    this.label = '',
    this.name = '',
  });

  factory EmailClient.fromJson(Map<String, dynamic> json) {
    return EmailClient(
      label: json['label'] ?? '',
      name: json['name'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'label': label,
      'name': name,
    };
  }
}
