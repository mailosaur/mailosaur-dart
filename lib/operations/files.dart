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

  Future<List<int>> getPreview(String id) async {
    final timeout = 120000; // 120 seconds
    var pollCount = 0;
    final stopwatch = Stopwatch()..start();

    while (true) {
      final url = Uri.parse('${baseUrl}api/files/screenshots/$id');
      final streamedResponse = await client.send(http.Request('GET', url));

      if (streamedResponse.statusCode == 200) {
        final response = await http.Response.fromStream(streamedResponse);
        return response.bodyBytes;
      }

      if (streamedResponse.statusCode != 202) {
        final response = await http.Response.fromStream(streamedResponse);
        throw MailosaurError(response);
      }

      // Get delay from headers
      final delayHeader = streamedResponse.headers['x-ms-delay'] ?? '1000';
      final delayPattern = delayHeader.split(',').map((s) => int.tryParse(s.trim()) ?? 1000).toList();
      
      final delay = pollCount >= delayPattern.length 
          ? delayPattern[delayPattern.length - 1] 
          : delayPattern[pollCount];

      pollCount++;

      // Stop if timeout will be exceeded
      if (stopwatch.elapsedMilliseconds + delay > timeout) {
        throw MailosaurError.withMessage(
          'An email preview was not generated in time. The email client may not be available, or the preview ID [$id] may be incorrect.',
          'preview_timeout'
        );
      }

      // Consume the stream to free resources
      await streamedResponse.stream.drain();
      
      await Future.delayed(Duration(milliseconds: delay));
    }
  }
}
