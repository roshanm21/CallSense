import 'package:flutter/material.dart';

class PrivacyScreen extends StatelessWidget {
  const PrivacyScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Privacy')),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: const [
            Text(
              'Your privacy matters',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 12),
            Text(
              'Message scans run on this device. CallSense does not record '
              'calls or upload pasted messages. When you choose company '
              'verification, the company name is sent to the configured '
              'verification service. Family alerts are stored in the '
              'configured Supabase project and visible to linked family '
              'accounts.',
            ),
            SizedBox(height: 12),
            Text(
              'Avoid sharing passwords, PINs, one-time codes, or private '
              'financial information in a family alert. Review your project '
              'privacy policy and data-retention settings before release.',
            ),
          ],
        ),
      );
}
