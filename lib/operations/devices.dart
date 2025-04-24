import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mailosaur/mailosaur.dart';

class Devices {
  final http.BaseClient client;
  final String baseUrl;

  Devices(this.client, this.baseUrl);

  Future<DeviceListResult> list() async {
    final url = Uri.parse('${baseUrl}api/devices');
    final response = await client.get(url);

    if (response.statusCode != 200) {
      throw MailosaurError(response.statusCode, 'Failed to list devices', response.body);
    }

    return DeviceListResult.fromJson(jsonDecode(response.body));
  }

  Future<Device> create(DeviceCreateOptions deviceCreateOptions) async {
    final url = Uri.parse('${baseUrl}api/devices');
    final response = await client.post(url, body: jsonEncode(deviceCreateOptions.toJson()));

    if (response.statusCode != 200) {
      throw MailosaurError(response.statusCode, 'Failed to create device', response.body);
    }

    return Device.fromJson(jsonDecode(response.body));
  }

  Future<OtpResult> otp(String query) async {
    Uri url;
    if (query.contains('-')) {
      url = Uri.parse('${baseUrl}api/devices/$query/otp');
    } else {
      url = Uri.parse('${baseUrl}api/devices/otp');
    }

    final response = query.contains('-')
        ? await client.get(url)
        : await client.post(url, body: jsonEncode({'sharedSecret': query}));

    if (response.statusCode != 200) {
      throw MailosaurError(response.statusCode, 'Failed to retrieve OTP', response.body);
    }

    return OtpResult.fromJson(jsonDecode(response.body));
  }

  Future<void> delete(String id) async {
    final url = Uri.parse('${baseUrl}api/devices/$id');
    final response = await client.delete(url);

    if (response.statusCode != 204) {
      throw MailosaurError(response.statusCode, 'Failed to delete device', response.body);
    }
  }
}
