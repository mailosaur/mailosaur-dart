import 'dart:io';
import 'package:test/test.dart';
import 'package:mailosaur/mailosaur.dart';

void main() {
  group('Servers Tests', () {
    late MailosaurClient client;

    setUpAll(() {
      final apiKey = Platform.environment['MAILOSAUR_API_KEY'];
      final baseUrl = Platform.environment['MAILOSAUR_BASE_URL'];

      if (apiKey == null || apiKey.isEmpty) {
        throw Exception("Missing necessary environment variables - refer to README.md");
      }

      client = MailosaurClient(apiKey, baseUrl);
    });

    test('List servers', () async {
      final result = await client.servers.list();
      expect(result.items.length, greaterThan(0));
    });

    test('Get server not found', () async {
      expect(() async => await client.servers.get('efe907e9-74ed-4113-a3e0-a3d41d914765'), throwsException);
    });

    test('CRUD operations', () async {
      final serverName = 'My test';

      // Create a new server
      final createOptions = ServerCreateOptions(name: serverName);
      final createdServer = await client.servers.create(createOptions);
      expect(createdServer.name, equals(serverName));

      // Retrieve the server
      final retrievedServer = await client.servers.get(createdServer.id!);
      expect(retrievedServer.name, createdServer.name);

      // Update the server
      final updatedServer = await client.servers.update(retrievedServer.id!, {'name': '$serverName updated with ellipsis … and emoji 👨🏿‍🚒'});
      expect(updatedServer['name'], equals('$serverName updated with ellipsis … and emoji 👨🏿‍🚒'));

      // Delete the server
      await client.servers.delete(retrievedServer.id!);

      // Attempting to delete again should fail
      expect(() async => await client.servers.delete(retrievedServer.id!), throwsException);
    });

    test('Failed create', () async {
      expect(
        () async => await client.servers.create(ServerCreateOptions()),
        throwsA(predicate((e) => e is Exception && e.toString().contains('Servers need a name'))),
      );
    });
  });
}
