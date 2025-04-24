import 'package:http/http.dart' as http;
import 'package:mailosaur/mailosaur.dart';

class Files {
  final http.BaseClient client;
  final String baseUrl;

  Files(this.client, this.baseUrl);

  Stream<List<int>> getAttachment(String id) async* {
    final url = Uri.parse('${baseUrl}api/files/attachments/$id');
    final response = await client.send(http.Request('GET', url));

    if (response.statusCode != 200) {
      throw MailosaurError(response.statusCode, 'Failed to download attachment');
    }

    yield* response.stream;
  }

  Stream<List<int>> getEmail(String id) async* {
    final url = Uri.parse('${baseUrl}api/files/email/$id');
    final response = await client.send(http.Request('GET', url));

    if (response.statusCode != 200) {
      throw MailosaurError(response.statusCode, 'Failed to download email');
    }

    yield* response.stream;
  }

  Stream<List<int>> getPreview(String id) async* {
    final url = Uri.parse('${baseUrl}api/files/previews/$id');
    final response = await client.send(http.Request('GET', url));

    if (response.statusCode != 200) {
      throw MailosaurError(response.statusCode, 'Failed to download preview');
    }

    yield* response.stream;
  }
}
