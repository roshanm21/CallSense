import 'package:flutter/material.dart';

import '../models/scan_result.dart';
import '../widgets/reason_tile.dart';
import '../widgets/verdict_card.dart';

class ResultScreen extends StatelessWidget {
  const ResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final result = ModalRoute.of(context)?.settings.arguments;
    if (result is! ScanResult) {
      return Scaffold(
        appBar: AppBar(title: const Text('Scan result')),
        body: const Center(child: Text('No scan result was provided.')),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Scan result')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          VerdictCard(result: result),
          const SizedBox(height: 16),
          Text('Why this result?', style: Theme.of(context).textTheme.titleLarge),
          if (result.reasons.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Text('No phrases from the current warning list were found.'),
            )
          else
            ...result.reasons.map((reason) => ReasonTile(reason: reason)),
          const Divider(height: 32),
          Text('Message checked', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          SelectableText(result.text),
          const SizedBox(height: 16),
          const Text(
            'Automated checks can miss scams and can flag legitimate messages. '
            'Verify requests independently before taking action.',
          ),
        ],
      ),
    );
  }
}
