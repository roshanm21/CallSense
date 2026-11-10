import 'package:flutter/material.dart';

import 'screens/alerts_screen.dart';
import 'screens/family_screen.dart';
import 'screens/onboarding_screen.dart';
import 'screens/privacy_screen.dart';
import 'screens/questions_screen.dart';
import 'screens/result_screen.dart';

class CallSenseApp extends StatelessWidget {
  const CallSenseApp({super.key, required this.supabaseConfigured});

  final bool supabaseConfigured;

  @override
  Widget build(BuildContext context) {
    const seedColor = Color(0xFF176B58);

    return MaterialApp(
      title: 'CallSense',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: seedColor,
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: const Color(0xFFF6F8F7),
        useMaterial3: true,
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(),
          alignLabelWithHint: true,
        ),
      ),
      home: OnboardingScreen(supabaseConfigured: supabaseConfigured),
      routes: {
        '/result': (_) => const ResultScreen(),
        '/questions': (_) => const QuestionsScreen(),
        '/family': (_) => const FamilyScreen(),
        '/alerts': (_) => const AlertsScreen(),
        '/privacy': (_) => const PrivacyScreen(),
      },
    );
  }
}
