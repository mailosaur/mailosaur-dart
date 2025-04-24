import 'spam_assassin_rule.dart';

class SpamAssassinResult {
  final double score;
  final String result;
  final List<SpamAssassinRule> rules;

  const SpamAssassinResult({
    this.score = 0.0,
    this.result = '',
    this.rules = const [],
  });

  factory SpamAssassinResult.fromJson(Map<String, dynamic> json) {
    return SpamAssassinResult(
      score: (json['score'] as num?)?.toDouble() ?? 0.0,
      result: json['result'] ?? '',
      rules: json['rules'] != null
          ? List<SpamAssassinRule>.from(
              json['rules'].map((item) => SpamAssassinRule.fromJson(item)))
          : const [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'score': score,
      'result': result,
      'rules': rules.map((item) => item.toJson()).toList(),
    };
  }
}
