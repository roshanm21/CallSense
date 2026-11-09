import 'package:flutter/material.dart';

import '../models/company_check.dart';
import '../services/company_service.dart';

class QuestionsScreen extends StatefulWidget {
  const QuestionsScreen({super.key});

  @override
  State<QuestionsScreen> createState() => _QuestionsScreenState();
}

class _QuestionsScreenState extends State<QuestionsScreen> {
  final _companyController = TextEditingController();
  late final _service = CompanyService();
  CompanyCheck? _result;
  String? _error;
  bool _loading = false;

  Future<void> _verify() async {
    setState(() {
      _loading = true;
      _error = null;
      _result = null;
    });
    try {
      final result = await _service.verify(_companyController.text);
      if (mounted) setState(() => _result = result);
    } catch (error) {
      if (mounted) setState(() => _error = error.toString());
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  void dispose() {
    _companyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Verify a company')),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text(
              'Verify independently',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            const Text(
              'Search public sources for a company name. Search results are '
              'informational and do not confirm who contacted you.',
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _companyController,
              textInputAction: TextInputAction.search,
              onSubmitted: (_) => _verify(),
              decoration: const InputDecoration(labelText: 'Company name'),
            ),
            const SizedBox(height: 12),
            FilledButton(
              onPressed: _loading ? null : _verify,
              child: Text(_loading ? 'Checking…' : 'Search public sources'),
            ),
            if (_error != null) ...[
              const SizedBox(height: 12),
              Text(_error!, style: TextStyle(color: Theme.of(context).colorScheme.error)),
            ],
            if (_result case final result?) ...[
              const SizedBox(height: 20),
              Text(result.companyName, style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 8),
              Text(result.summary),
              if (result.domain != null) ...[
                const SizedBox(height: 8),
                Text('Domain found: ${result.domain}'),
              ],
              if (result.domainAgeYears != null)
                Text('Approximate domain age: ${result.domainAgeYears} years'),
              const SizedBox(height: 12),
              Text('Sources', style: Theme.of(context).textTheme.titleMedium),
              ...result.sources.map(
                (source) => SelectableText(source),
              ),
            ],
          ],
        ),
      );
}
