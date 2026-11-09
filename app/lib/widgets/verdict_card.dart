import 'package:flutter/material.dart';

import '../models/scan_result.dart';

class VerdictCard extends StatelessWidget {
  const VerdictCard({super.key, required this.result});

  final ScanResult result;

  @override
  Widget build(BuildContext context) {
    final (color, icon) = switch (result.verdict) {
      Verdict.safe => (Colors.green.shade800, Icons.verified_user_outlined),
      Verdict.suspicious => (Colors.orange.shade900, Icons.warning_amber_rounded),
      Verdict.dangerous => (Colors.red.shade800, Icons.gpp_bad_outlined),
    };

    return Card(
      color: color.withValues(alpha: 0.08),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    result.title,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: color,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(result.guidance),
                  const SizedBox(height: 10),
                  Text('Risk indicator: ${result.score}/100'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
