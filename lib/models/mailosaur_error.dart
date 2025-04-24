class MailosaurError implements Exception {
  final int statusCode;
  final String message;
  final String? details;

  MailosaurError(this.statusCode, this.message, [this.details]);

  @override
  String toString() {
    return 'MailosaurError: $message (Status code: $statusCode)${details != null ? '\nDetails: $details' : ''}';
  }
}
