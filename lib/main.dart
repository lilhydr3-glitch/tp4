import 'dart:developer' as developer;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'queue_provider.dart';
import 'screens/waiting_room_screen.dart';
import 'theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  const supabaseUrl = String.fromEnvironment(
    'SUPABASE_URL',
    defaultValue: 'https://fosgclukncaiwerxkgmp.supabase.co',
  );
  const supabaseAnonKey = String.fromEnvironment('SUPABASE_ANON_KEY');

  if (supabaseAnonKey.isEmpty) {
    throw StateError(
      'SUPABASE_ANON_KEY is missing. Run Flutter with '
      '--dart-define-from-file=supabase-config.json containing the project '
      'publishable (or legacy anon) key.',
    );
  }

  await Supabase.initialize(
    url: supabaseUrl,
    // ignore: deprecated_member_use
    anonKey: supabaseAnonKey,
  );

  final currentSession = Supabase.instance.client.auth.currentSession;
  if (currentSession == null) {
    try {
      await Supabase.instance.client.auth.signInAnonymously();
      developer.log('Signed in anonymously to Supabase', name: 'Auth');
    } catch (e, stackTrace) {
      developer.log(
        'Anonymous sign-in skipped or failed: $e',
        name: 'Auth',
        error: e,
        stackTrace: stackTrace,
      );
    }
  }

  runApp(
    ChangeNotifierProvider<QueueProvider>(
      create: (_) => QueueProvider(),
      child: const WaitingRoomApp(),
    ),
  );
}

class WaitingRoomApp extends StatelessWidget {
  const WaitingRoomApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Waiting Room',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      home: const WaitingRoomScreen(),
    );
  }
}
