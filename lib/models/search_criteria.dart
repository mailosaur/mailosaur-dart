class SearchCriteria {
  String? sentFrom;
  String? sentTo;
  String? subject;
  String? body;
  String? match;

  SearchCriteria({
    this.sentFrom,
    this.sentTo,
    this.subject,
    this.body,
    this.match = 'ALL',
  });

  factory SearchCriteria.fromJson(Map<String, dynamic> json) {
    return SearchCriteria(
      sentFrom: json['sentFrom'],
      sentTo: json['sentTo'],
      subject: json['subject'],
      body: json['body'],
      match: json['match'] ?? 'ALL',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'sentFrom': sentFrom,
      'sentTo': sentTo,
      'subject': subject,
      'body': body,
      'match': match,
    };
  }
}
