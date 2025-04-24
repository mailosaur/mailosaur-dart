import 'spam_filter_results.dart';

class SpamAnalysisResult {
  final SpamFilterResults spamFilterResults;
  final double score;

  const SpamAnalysisResult({
    required this.spamFilterResults,
    this.score = 0.0,
  });

  factory SpamAnalysisResult.fromJson(Map<String, dynamic> json) {
    return SpamAnalysisResult(
      spamFilterResults: SpamFilterResults.fromJson(json['spamFilterResults']),
      score: (json['score'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'spamFilterResults': spamFilterResults.toJson(),
      'score': score,
    };
  }
}
