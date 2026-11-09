import 'package:flutter/widgets.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'app.dart';
import 'config/env.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Env.load();

  if (Env.isConfigured) {
    await Supabase.initialize(url: Env.supabaseUrl, anonKey: Env.supabaseAnonKey);
  }

  runApp(CallSenseApp(supabaseConfigured: Env.isConfigured));
}