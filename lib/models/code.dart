class Code {
  final String value;

  const Code({
    this.value = '',
  });

  factory Code.fromJson(Map<String, dynamic> json) {
    return Code(
      value: json['value'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'value': value,
    };
  }
}
