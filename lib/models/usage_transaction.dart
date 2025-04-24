class UsageTransaction {
  final DateTime? timestamp;
  final int email;
  final int sms;

  const UsageTransaction({
    this.timestamp,
    this.email = 0,
    this.sms = 0,
  });

  factory UsageTransaction.fromJson(Map<String, dynamic> json) {
    return UsageTransaction(
      timestamp: json['timestamp'] != null
          ? DateTime.parse(json['timestamp'])
          : null,
      email: json['email'],
      sms: json['sms'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'timestamp': timestamp?.toIso8601String(),
      'email': email,
      'sms': sms,
    };
  }
}
