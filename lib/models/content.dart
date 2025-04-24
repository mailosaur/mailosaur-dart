class Content {
  final bool embed;
  final bool iframe;
  final bool object;
  final bool script;
  final bool shortUrls;
  final int textSize;
  final int totalSize;
  final bool missingAlt;
  final bool missingListUnsubscribe;

  const Content({
    this.embed = false,
    this.iframe = false,
    this.object = false,
    this.script = false,
    this.shortUrls = false,
    this.textSize = 0,
    this.totalSize = 0,
    this.missingAlt = false,
    this.missingListUnsubscribe = false,
  });

  factory Content.fromJson(Map<String, dynamic> json) {
    return Content(
      embed: json['embed'] ?? false,
      iframe: json['iframe'] ?? false,
      object: json['object'] ?? false,
      script: json['script'] ?? false,
      shortUrls: json['shortUrls'] ?? false,
      textSize: json['textSize'] ?? 0,
      totalSize: json['totalSize'] ?? 0,
      missingAlt: json['missingAlt'] ?? false,
      missingListUnsubscribe: json['missingListUnsubscribe'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'embed': embed,
      'iframe': iframe,
      'object': object,
      'script': script,
      'shortUrls': shortUrls,
      'textSize': textSize,
      'totalSize': totalSize,
      'missingAlt': missingAlt,
      'missingListUnsubscribe': missingListUnsubscribe,
    };
  }
}
