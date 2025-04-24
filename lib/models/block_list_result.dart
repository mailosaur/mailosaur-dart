class BlockListResult {
  final String id;
  final String name;
  final String result;

  const BlockListResult({
    this.id = '',
    this.name = '',
    this.result = '',
  });

  factory BlockListResult.fromJson(Map<String, dynamic> json) {
    return BlockListResult(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      result: json['result'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'result': result,
    };
  }
}
