class EmailAuthenticationResult {
  final String result;
  final String description;
  final String rawValue;
  final Map<String, String> tags;

  const EmailAuthenticationResult({
    this.result = '',
    this.description = '',
    this.rawValue = '',
    this.tags = const {},
  });

  factory EmailAuthenticationResult.fromJson(Map<String, dynamic> json) {
    return EmailAuthenticationResult(
      result: json['result'] ?? '',
      description: json['description'] ?? '',
      rawValue: json['rawValue'] ?? '',
      tags: json['tags'] != null ? Map<String, String>.from(json['tags']) : const {},
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'result': result,
      'description': description,
      'rawValue': rawValue,
      'tags': tags,
    };
  }
}
