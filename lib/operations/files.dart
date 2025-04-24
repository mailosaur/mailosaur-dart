import 'package:http/http.dart' as http;
import 'package:mailosaur/mailosaur.dart';

class Files {
  final http.BaseClient client;
  final String baseUrl;

  Files(this.client, this.baseUrl);

  Stream<List<int>> getAttachment(String id) async* {
    final url = Uri.parse('${baseUrl}api/files/attachments/$id');
    final streamedResponse = await client.send(http.Request('GET', url));

    if (streamedResponse.statusCode != 200) {
      final response = await http.Response.fromStream(streamedResponse);
      throw MailosaurError(response);
    }

    yield* streamedResponse.stream;
  }

  Stream<List<int>> getEmail(String id) async* {
    final url = Uri.parse('${baseUrl}api/files/email/$id');
    final streamedResponse = await client.send(http.Request('GET', url));

    if (streamedResponse.statusCode != 200) {
      final response = await http.Response.fromStream(streamedResponse);
      throw MailosaurError(response);
    }

    yield* streamedResponse.stream;
  }

  Stream<List<int>> getPreview(String id) async* {
    final url = Uri.parse('${baseUrl}api/files/previews/$id');
    final streamedResponse = await client.send(http.Request('GET', url));

    if (streamedResponse.statusCode != 200) {
      final response = await http.Response.fromStream(streamedResponse);
      throw MailosaurError(response);
    }

    yield* streamedResponse.stream;
  }
}
