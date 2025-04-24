import 'server.dart';

class ServerListResult {
  List<Server> items;

  ServerListResult({
    required this.items,
  });

  factory ServerListResult.fromJson(Map<String, dynamic> json) {
    return ServerListResult(
      items: List<Server>.from(
        json['items']?.map((item) => Server.fromJson(item)) ?? [],
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'items': items.map((item) => item.toJson()).toList(),
    };
  }
}
