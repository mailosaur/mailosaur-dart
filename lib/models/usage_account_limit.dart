class UsageAccountLimit {
  final int limit;
  final int current;

  const UsageAccountLimit({
    this.limit = 0,
    this.current = 0,
  });

  factory UsageAccountLimit.fromJson(Map<String, dynamic> json) {
    return UsageAccountLimit(
      limit: json['limit'] ?? 0,
      current: json['current'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'limit': limit,
      'current': current,
    };
  }
}
