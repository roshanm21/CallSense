import '../models/scan_result.dart';
import '../rules/red_flags.dart';

class ScamDetector {
  const ScamDetector();

  ScanResult scan(String text) {
    final normalized =
        text.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]+'), ' ').trim();
    final matches = redFlags
        .where(
          (flag) => RegExp(
            '(^| )${RegExp.escape(flag.phrase)}( |\$)',
          ).hasMatch(normalized),
        )
        .toList(growable: false);
    final score = matches.fold<int>(
      0,
      (total, flag) => (total + flag.points).clamp(0, 100).toInt(),
    );

    final verdict = score >= 60
        ? Verdict.dangerous
        : score >= 25
            ? Verdict.suspicious
            : Verdict.safe;

    return ScanResult(
      text: text,
      score: score,
      verdict: verdict,
      reasons: matches.map((flag) => flag.explanation).toList(growable: false),
    );
  }
}
