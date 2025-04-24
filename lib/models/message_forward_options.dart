class MessageForwardOptions {
  final String to;
  final String cc;
  final String text;
  final String html;

  const MessageForwardOptions({
    this.to = '',
    this.cc = '',
    this.text = '',
    this.html = '',
  });

  factory MessageForwardOptions.fromJson(Map<String, dynamic> json) {
    return MessageForwardOptions(
      to: json['to'] ?? '',
      cc: json['cc'] ?? '',
      text: json['text'] ?? '',
      html: json['html'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'to': to,
      'cc': cc,
      'text': text,
      'html': html,
    };
  }
}
