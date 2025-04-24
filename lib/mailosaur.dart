import 'package:http/http.dart' as http;
import 'operations/analysis.dart';
import 'operations/devices.dart';
import 'operations/files.dart';
import 'operations/messages.dart';
import 'operations/previews.dart';
import 'operations/servers.dart';
import 'operations/usage.dart';

export 'models/index.dart';

class MailosaurClient {
  final Servers servers;
  final Messages messages;
  final Analysis analysis;
  final Files files;
  final Usage usage;
  final Devices devices;
  final Previews previews;
  // TODO from .models.mailosaur_exception import MailosaurException

  MailosaurClient(String apiKey, String? baseUrl)
      : servers = _createApi<Servers>(Servers.new, apiKey, baseUrl),
        messages = _createApi<Messages>(Messages.new, apiKey, baseUrl),
        analysis = _createApi<Analysis>(Analysis.new, apiKey, baseUrl),
        files = _createApi<Files>(Files.new, apiKey, baseUrl),
        usage = _createApi<Usage>(Usage.new, apiKey, baseUrl),
        devices = _createApi<Devices>(Devices.new, apiKey, baseUrl),
        previews = _createApi<Previews>(Previews.new, apiKey, baseUrl);

  static T _createApi<T>(T Function(HttpClient, String) constructor, String apiKey, String? baseUrl) {
    final client = HttpClient(apiKey);
    final resolvedBaseUrl = baseUrl ?? 'https://mailosaur.com';
    return constructor(client, resolvedBaseUrl);
  }

  void handleHttpError(http.Response response) {
    String message;
    switch (response.statusCode) {
      case 400:
        message = 'Request had one or more invalid parameters.';
        break;
      case 401:
        message = 'Authentication failed, check your API key.';
        break;
      case 403:
        message = 'Insufficient permission to perform that task.';
        break;
      case 404:
        message = 'Not found, check input parameters.';
        break;
      default:
        message = 'An API error occurred, see httpResponse for further information.';
    }
    throw Exception(message);
  }
}

class HttpClient extends http.BaseClient {
  final String apiKey;
  final http.Client _inner = http.Client();

  HttpClient(this.apiKey);

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    request.headers['Authorization'] = 'Bearer $apiKey';
    request.headers['Content-Type'] = 'application/json';
    request.headers['User-Agent'] = 'mailosaur-dart/1.0.0';
    return _inner.send(request);
  }
}
