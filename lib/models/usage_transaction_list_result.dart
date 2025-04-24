import 'usage_transaction.dart';

class UsageTransactionListResult {
  List<UsageTransaction> items;

  UsageTransactionListResult({
    this.items = const [],
  });

  factory UsageTransactionListResult.fromJson(Map<String, dynamic> json) {
    return UsageTransactionListResult(
      items: json['items'] != null
          ? List<UsageTransaction>.from(json['items'].map((item) => UsageTransaction.fromJson(item)))
          : const [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'items': items.map((item) => item.toJson()).toList(),
    };
  }
}
