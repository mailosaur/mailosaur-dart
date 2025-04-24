import 'dart:io';
import 'package:test/test.dart';
import 'package:mailosaur/mailosaur.dart';

void main() {
  group('Devices Tests', () {
    late MailosaurClient client;

    setUpAll(() {
      final apiKey = Platform.environment['MAILOSAUR_API_KEY'];
      final baseUrl = Platform.environment['MAILOSAUR_BASE_URL'];

      if (apiKey == null || apiKey.isEmpty) {
        throw Exception("Missing necessary environment variables - refer to README.md");
      }

      client = MailosaurClient(apiKey, baseUrl);
    });

    test('CRUD operations', () async {
      final deviceName = 'My test';
      final sharedSecret = 'ONSWG4TFOQYTEMY=';

      // Create a new device
      final createOptions = DeviceCreateOptions(name: deviceName, sharedSecret: sharedSecret);
      final createdDevice = await client.devices.create(createOptions);
      expect(createdDevice.id, isNotNull);
      expect(createdDevice.name, equals(deviceName));

      // Retrieve an OTP via device ID
      final otpResult = await client.devices.otp(createdDevice.id);
      expect(otpResult.code.length, equals(6));

      // Verify the device exists in the list
      final before = (await client.devices.list()).items;
      expect(before.any((x) => x.id == createdDevice.id), isTrue);

      // Delete the device
      await client.devices.delete(createdDevice.id);

      // Verify the device no longer exists in the list
      final after = (await client.devices.list()).items;
      expect(after.any((x) => x.id == createdDevice.id), isFalse);
    });

    test('OTP via shared secret', () async {
      final sharedSecret = 'ONSWG4TFOQYTEMY=';

      final otpResult = await client.devices.otp(sharedSecret);
      expect(otpResult.code.length, equals(6));
    });
  });
}
