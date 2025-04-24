class Link {
  final String href;
  final String text;

  const Link({
    this.href = '',
    this.text = '',
  });

  factory Link.fromJson(Map<String, dynamic> json) {
    return Link(
      href: json['href'] ?? '',
      text: json['text'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'href': href,
      'text': text,
    };
  }
}
