class Image {
  final String src;
  final String alt;

  const Image({
    this.src = '',
    this.alt = '',
  });

  factory Image.fromJson(Map<String, dynamic> json) {
    return Image(
      src: json['src'] ?? '',
      alt: json['alt'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'src': src,
      'alt': alt,
    };
  }
}
