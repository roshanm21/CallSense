import 'package:flutter/material.dart';

import '../services/family_service.dart';

class FamilyScreen extends StatefulWidget {
  const FamilyScreen({super.key});

  @override
  State<FamilyScreen> createState() => _FamilyScreenState();
}

class _FamilyScreenState extends State<FamilyScreen> {
  final _codeController = TextEditingController();
  late final _service = FamilyService();
  String? _createdCode;
  String? _message;
  bool _busy = false;

  Future<void> _run(Future<void> Function() action, String success) async {
    setState(() {
      _busy = true;
      _message = null;
    });
    try {
      await action();
      if (mounted) setState(() => _message = success);
    } catch (error) {
      if (mounted) setState(() => _message = error.toString());
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _createCode() async {
    setState(() {
      _busy = true;
      _message = null;
      _createdCode = null;
    });
    try {
      final code = await _service.createLinkCode();
      if (mounted) setState(() => _createdCode = code);
    } catch (error) {
      if (mounted) setState(() => _message = error.toString());
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Family safety')),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const Text(
              'Create a one-time code to share with your guardian, or enter '
              'their code to link accounts. Codes expire after 30 minutes.',
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: _busy ? null : _createCode,
              icon: const Icon(Icons.add_link),
              label: const Text('Create a link code'),
            ),
            if (_createdCode != null) ...[
              const SizedBox(height: 12),
              SelectableText(
                'Share this code privately: $_createdCode',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ],
            const Divider(height: 32),
            TextField(
              controller: _codeController,
              textCapitalization: TextCapitalization.characters,
              decoration: const InputDecoration(labelText: 'Family link code'),
            ),
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: _busy
                  ? null
                  : () => _run(
                        () => _service.joinWithCode(_codeController.text),
                        'Family account linked.',
                      ),
              child: const Text('Link with code'),
            ),
            if (_message != null) ...[
              const SizedBox(height: 12),
              SelectableText(_message!),
            ],
            const SizedBox(height: 16),
            const Text(
              'Family linking requires Supabase anonymous sign-in to be enabled '
              'for this project. Only share a code with someone you trust.',
            ),
          ],
        ),
      );
}
