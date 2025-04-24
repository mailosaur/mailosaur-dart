import 'spam_assassin_rule.dart';

class SpamFilterResults {
  final List<SpamAssassinRule> spamAssassin;

  const SpamFilterResults({
    this.spamAssassin = const [],
  });

  factory SpamFilterResults.fromJson(Map<String, dynamic> json) {
    return SpamFilterResults(
      spamAssassin: json['spamAssassin'] != null
          ? List<SpamAssassinRule>.from(
              json['spamAssassin'].map((item) => SpamAssassinRule.fromJson(item)))
          : const [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'spamAssassin': spamAssassin.map((item) => item.toJson()).toList(),
    };
  }
}
