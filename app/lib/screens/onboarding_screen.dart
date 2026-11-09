import 'package:flutter/material.dart';

import 'home_screen.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key, required this.supabaseConfigured});

  final bool supabaseConfigured;

  @override
  Widget build(BuildContext context) => Scaffold(
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 480),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.shield_outlined, size: 76),
                    const SizedBox(height: 20),
                    Text(
                      'Stay one step ahead',
                      style: Theme.of(context).textTheme.headlineMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'CallSense checks message text for common scam warning '
                      'signs and helps you verify a company. It is a guide, '
                      'not a guarantee that a message or caller is genuine.',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 28),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: () => Navigator.of(context).pushReplacement(
                          MaterialPageRoute<void>(
                            builder: (_) => HomeScreen(
                              supabaseConfigured: supabaseConfigured,
                            ),
                          ),
                        ),
                        child: const Text('Get started'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
}
