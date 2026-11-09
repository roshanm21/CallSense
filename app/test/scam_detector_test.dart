import 'package:flutter_test/flutter_test.dart';
import 'package:callsense/models/scan_result.dart';
import 'package:callsense/services/scam_detector.dart';

void main() {
  const detector = ScamDetector();

  test('returns a low-risk result when no warning phrases are present', () {
    final result = detector.scan('The meeting is at 3 pm.');

    expect(result.verdict, Verdict.safe);
    expect(result.score, 0);
    expect(result.reasons, isEmpty);
  });

  test('recognizes warning phrases regardless of case and punctuation', () {
    final result = detector.scan('URGENT action required: share your PIN!');

    expect(result.verdict, Verdict.dangerous);
    expect(result.score, greaterThanOrEqualTo(60));
    expect(result.reasons, hasLength(2));
  });

  test('does not treat otp as a match inside another word', () {
    final result = detector.scan('Please adopt the new schedule.');

    expect(result.score, 0);
    expect(result.verdict, Verdict.safe);
  });

  test('caps combined warning points at 100', () {
    final result = detector.scan(
      'OTP. One-time password. Share your PIN. Account will be blocked. '
      'Urgent action required. Send money now.',
    );

    expect(result.score, 100);
    expect(result.verdict, Verdict.dangerous);
  });
}
