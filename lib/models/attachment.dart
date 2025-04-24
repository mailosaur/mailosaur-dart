class Attachment {
  final String id;
  final String contentType;
  final String fileName;
  final String content;
  final String contentId;
  final int length;
  final String url;

  const Attachment({
    this.id = '',
    this.contentType = '',
    this.fileName = '',
    this.content = '',
    this.contentId = '',
    this.length = 0,
    this.url = '',
  });

  factory Attachment.fromJson(Map<String, dynamic> json) {
    return Attachment(
      id: json['id'] ?? '',
      contentType: json['contentType'] ?? '',
      fileName: json['fileName'] ?? '',
      content: json['content'] ?? '',
      contentId: json['contentId'] ?? '',
      length: json['length'] ?? 0,
      url: json['url'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'contentType': contentType,
      'fileName': fileName,
      'content': content,
      'contentId': contentId,
      'length': length,
      'url': url,
    };
  }
}
