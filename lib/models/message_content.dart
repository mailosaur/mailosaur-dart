import 'code.dart';
import 'image.dart';
import 'link.dart';

class MessageContent {
  final List<Link> links;
  final List<Code> codes;
  final List<Image> images;
  final String body;

  const MessageContent({
    this.links = const [],
    this.codes = const [],
    this.images = const [],
    this.body = '',
  });

  factory MessageContent.fromJson(Map<String, dynamic> json) {
    return MessageContent(
      links: json['links'] != null
          ? List<Link>.from(json['links'].map((item) => Link.fromJson(item)))
          : const [],
      codes: json['codes'] != null
          ? List<Code>.from(json['codes'].map((item) => Code.fromJson(item)))
          : const [],
      images: json['images'] != null
          ? List<Image>.from(json['images'].map((item) => Image.fromJson(item)))
          : const [],
      body: json['body'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'links': links.map((item) => item.toJson()).toList(),
      'codes': codes.map((item) => item.toJson()).toList(),
      'images': images.map((item) => item.toJson()).toList(),
      'body': body,
    };
  }
}
