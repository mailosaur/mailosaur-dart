class MessageHeader {
  final String field;
  final String value;

  const MessageHeader({
    this.field = '',
    this.value = '',
  });

  factory MessageHeader.fromJson(Map<String, dynamic> json) {
    return MessageHeader(
      field: json['field'] ?? '',
      value: json['value'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'field': field,
      'value': value,
    };
  }
}
