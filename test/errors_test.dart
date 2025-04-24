import 'package:test/test.dart';
import 'package:mailosaur/mailosaur.dart';

void main() {
  group('Errors Tests', () {
    test('Unauthorized', () {}, skip: true);
    test('Not Found', () {}, skip: true);
    test('Bad Request', () {
      try {
        throw MailosaurError(400, 'Bad Request', 'Invalid input');
      } catch (e) {
        expect(e, isA<MailosaurError>());
        final error = e as MailosaurError;
        expect(error.statusCode, equals(400));
        expect(error.message, equals('Bad Request'));
        expect(error.details, equals('Invalid input'));
      }
    });
  });
}
