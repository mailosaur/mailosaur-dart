class SpamAssassinRule {
  final double score;
  final String rule;
  final String description;

  const SpamAssassinRule({
    this.score = 0.0,
    this.rule = '',
    this.description = '',
  });

  factory SpamAssassinRule.fromJson(Map<String, dynamic> json) {
    return SpamAssassinRule(
      score: (json['score'] as num?)?.toDouble() ?? 0.0,
      rule: json['rule'] ?? '',
      description: json['description'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'score': score,
      'rule': rule,
      'description': description,
    };
  }
}
