enum Verdict { safe, suspicious, dangerous }

class ScanResult {
  const ScanResult({
    required this.text,
    required this.score,
    required this.verdict,
    required this.reasons,
  });

  final String text;
  final int score;
  final Verdict verdict;
  final List<String> reasons;

  String get title => switch (verdict) {
        Verdict.safe => 'No obvious red flags',
        Verdict.suspicious => 'Be careful',
        Verdict.dangerous => 'High-risk message',
      };

  String get guidance => switch (verdict) {
        Verdict.safe =>
          'This scan did not find common scam phrases. It cannot prove a message is genuine.',
        Verdict.suspicious =>
          'Pause and verify the sender using a contact method you already trust.',
        Verdict.dangerous =>
          'Do not share a password, PIN, or one-time code, and do not send money.',
      };
}
