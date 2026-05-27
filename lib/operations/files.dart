import 'package:http/http.dart' as http;
import 'package:mailosaur/mailosaur.dart';

/// Operations for downloading the raw content associated with a message — file
/// attachments, the full EML source of an email, and rendered email previews.
///
/// Accessed via `client.files`.
class Files {
  final http.BaseClient client;
  final String baseUrl;

  Files(this.client, this.baseUrl);

  /// Downloads the single attachment identified by `id`.
  ///
  /// Returns a [Stream] emitting the attachment's binary content.
  Stream<List<int>> getAttachment(String id) async* {
    final url = Uri.parse('${baseUrl}api/files/attachments/$id');
    final streamedResponse = await client.send(http.Request('GET', url));

    if (streamedResponse.statusCode != 200) {
      final response = await http.Response.fromStream(streamedResponse);
      throw MailosaurError(response);
    }

    yield* streamedResponse.stream;
  }

  /// Downloads an EML file representing the email identified by `id`.
  ///
  /// Returns a [Stream] emitting the raw EML content of the email.
  Stream<List<int>> getEmail(String id) async* {
    final url = Uri.parse('${baseUrl}api/files/email/$id');
    final streamedResponse = await client.send(http.Request('GET', url));

    if (streamedResponse.statusCode != 200) {
      final response = await http.Response.fromStream(streamedResponse);
      throw MailosaurError(response);
    }

    yield* streamedResponse.stream;
  }

  /// Downloads a screenshot of your email rendered in a real email client.
  ///
  /// Simply supply the unique identifier of the required preview in `id`.
  ///
  /// Returns a [Future] resolving to the bytes of the preview screenshot image.
  ///
  /// Throws a [MailosaurError] with error type `preview_timeout` if the preview
  /// is not generated within the time limit.
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
