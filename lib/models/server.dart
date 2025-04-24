class Server {
  final String id;
  final String name;
  final int messages;

  const Server({
    this.id = '',
    this.name = '',
    this.messages = 0,
  });

  factory Server.fromJson(Map<String, dynamic> json) {
    return Server(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      messages: json['messages'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'messages': messages,
    };
  }
}
