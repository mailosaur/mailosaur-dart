import 'device.dart';

class DeviceListResult {
  List<Device> items;

  DeviceListResult({
    this.items = const [],
  });

  factory DeviceListResult.fromJson(Map<String, dynamic> json) {
    return DeviceListResult(
      items: json['items'] != null
          ? List<Device>.from(json['items'].map((item) => Device.fromJson(item)))
          : const [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'items': items.map((item) => item.toJson()).toList(),
    };
  }
}
