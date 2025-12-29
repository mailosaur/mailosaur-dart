import 'package:http/http.dart' as http;

class MailosaurError implements Exception {
  final http.Response? response;
  final String message;
  final String? errorType;

  MailosaurError(http.Response this.response)
      : message = _generateMessage(response),
        errorType = null;

  MailosaurError.withMessage(this.message, this.errorType)
      : response = null;

  static String _generateMessage(http.Response response) {
    switch (response.statusCode) {
      case 400:
        return "Request had one or more invalid parameters.";
      case 401:
        return "Authentication failed, check your API key.";
      case 403:
        return "Insufficient permission to perform that task.";
      case 404:
        return "Not found, check input parameters.";
      case 410:
        return "Permanently expired or deleted.";
      default:
        return "An API error occurred, see response body for further information.";
    }
  }

  @override
  String toString() {
    if (response != null) {
      return 'MailosaurError: $message (Status code: ${response!.statusCode})\n ${response!.body}';
    } else {
      return 'MailosaurError: $message';
    }
  }
}
