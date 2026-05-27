import 'package:http/http.dart' as http;
import 'operations/analysis.dart';
import 'operations/devices.dart';
import 'operations/files.dart';
import 'operations/messages.dart';
import 'operations/previews.dart';
import 'operations/servers.dart';
import 'operations/usage.dart';
import 'models/mailosaur_error.dart';
import 'dart:io';
import 'package:yaml/yaml.dart';

export 'models/index.dart';

/// The Mailosaur client — the main entry point to the Mailosaur API.
///
/// Construct an instance with your API key (or set the `MAILOSAUR_API_KEY`
/// environment variable), then use the operations namespaces ([messages],
/// [servers], [files], [devices], [analysis], [previews], [usage]) to automate
/// email and SMS testing.
class MailosaurClient {
  /// Operations for creating and managing your Mailosaur servers (virtual inboxes).
  final Servers servers;

  /// Operations for finding, retrieving, creating, and managing email and SMS messages.
  final Messages messages;

  /// Operations for analyzing email content and deliverability, including spam scoring.
  final Analysis analysis;

  /// Operations for downloading attachments, EML source, and email preview screenshots.
  final Files files;

  /// Operations for inspecting account usage limits and recent transactional usage.
  final Usage usage;

  /// Operations for managing virtual security devices and retrieving their one-time passwords.
  final Devices devices;

  /// Operations for discovering the email clients available for generating email previews.
  final Previews previews;

  /// Returns an instance of the Mailosaur client.
  ///
  /// The `apiKey` is optional and overrides the `MAILOSAUR_API_KEY` environment
  /// variable when provided. The `baseUrl` optionally overrides the base URL of
  /// the Mailosaur service.
  MailosaurClient({ String? apiKey, String? baseUrl })
      : servers = _createApi<Servers>(Servers.new, _resolveApiKey(apiKey), baseUrl),
        messages = _createApi<Messages>(Messages.new, _resolveApiKey(apiKey), baseUrl),
        analysis = _createApi<Analysis>(Analysis.new, _resolveApiKey(apiKey), baseUrl),
        files = _createApi<Files>(Files.new, _resolveApiKey(apiKey), baseUrl),
        usage = _createApi<Usage>(Usage.new, _resolveApiKey(apiKey), baseUrl),
        devices = _createApi<Devices>(Devices.new, _resolveApiKey(apiKey), baseUrl),
        previews = _createApi<Previews>(Previews.new, _resolveApiKey(apiKey), baseUrl);

  static String _resolveApiKey(String? apiKey) {
    final resolvedApiKey = apiKey ?? Platform.environment['MAILOSAUR_API_KEY'];
    if (resolvedApiKey == null || resolvedApiKey.isEmpty) {
      throw MailosaurError.withMessage(
        "'apiKey' must be set via the MAILOSAUR_API_KEY environment variable, or passed to the MailosaurClient constructor.",
        'missing_api_key',
      );
    }
    return resolvedApiKey;
  }

  static T _createApi<T>(T Function(HttpClient, String) constructor, String apiKey, String? baseUrl) {
    final client = HttpClient(apiKey);
    final resolvedBaseUrl = baseUrl ?? 'https://mailosaur.com/';
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
  late String userAgent;
  final http.Client _inner = http.Client();

  HttpClient(this.apiKey) {
    _initializeUserAgent();
  }

  void _initializeUserAgent() {
    final pubspec = loadYaml(File('pubspec.yaml').readAsStringSync());
    userAgent = 'mailosaur-dart/${pubspec['version'] ?? 'unknown'}';
  }

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    request.headers['Authorization'] = 'Bearer $apiKey';
    request.headers['Content-Type'] = 'application/json';
    request.headers['User-Agent'] = userAgent;
    return _inner.send(request);
  }
}
