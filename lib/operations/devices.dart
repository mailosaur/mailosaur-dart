import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mailosaur/mailosaur.dart';

/// Operations for managing virtual security devices and retrieving their
/// current one-time passwords (OTPs), used to automate testing of app-based
/// multi-factor authentication.
///
/// Accessed via `client.devices`.
class Devices {
  final http.BaseClient client;
  final String baseUrl;

  Devices(this.client, this.baseUrl);

  /// Returns a list of your virtual security devices.
  ///
  /// Returns a [Future] resolving to a [DeviceListResult] containing your devices.
  Future<DeviceListResult> list() async {
    final url = Uri.parse('${baseUrl}api/devices');
    final response = await client.get(url);

    if (response.statusCode != 200) {
      throw MailosaurError(response);
    }

    return DeviceListResult.fromJson(jsonDecode(response.body));
  }

  /// Creates a new virtual security device, using the options given in
  /// `deviceCreateOptions`.
  ///
  /// Returns a [Future] resolving to the newly-created [Device].
  Future<Device> create(DeviceCreateOptions deviceCreateOptions) async {
    final url = Uri.parse('${baseUrl}api/devices');
    final response = await client.post(url, body: jsonEncode(deviceCreateOptions.toJson()));

    if (response.statusCode != 200) {
      throw MailosaurError(response);
    }

    return Device.fromJson(jsonDecode(response.body));
  }

  /// Retrieves the current one-time password for a saved device, or for a
  /// given base32-encoded shared secret.
  ///
  /// The `query` is either the unique identifier of the device, or a
  /// base32-encoded shared secret.
  ///
  /// Returns a [Future] resolving to an [OtpResult] containing the current
  /// one-time password.
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
      throw MailosaurError(response);
    }

    return OtpResult.fromJson(jsonDecode(response.body));
  }

  /// Permanently deletes the virtual security device identified by `id`.
  ///
  /// This operation cannot be undone. Returns a [Future] that completes once
  /// the device has been deleted.
  Future<void> delete(String id) async {
    final url = Uri.parse('${baseUrl}api/devices/$id');
    final response = await client.delete(url);

    if (response.statusCode != 204) {
      throw MailosaurError(response);
    }
  }
}
