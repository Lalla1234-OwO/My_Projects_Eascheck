// lib/main.dart

import 'dart:async'; // ← เพิ่มตัวนี้
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:eascheck/features/authentication/views/login_page.dart';
import 'package:eascheck/features/onboarding/views/onboarding_page.dart';
import 'package:eascheck/features/survey/views/health_survey_page.dart';

// ← navigatorKey เดียวกันเลย
final navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');

  final supaUrl = dotenv.env['SUPABASE_URL'];
  final supaAnonKey = dotenv.env['SUPABASE_ANON_KEY'];
  if (supaUrl == null || supaAnonKey == null) {
    throw Exception('Missing SUPABASE_URL or SUPABASE_ANON_KEY in .env');
  }

  await Supabase.initialize(
    url: supaUrl,
    anonKey: supaAnonKey,
    authOptions: const FlutterAuthClientOptions(
      authFlowType: AuthFlowType.pkce,
    ),
  );

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final StreamSubscription<AuthState> _authSub; // ← ใช้ AuthState
  @override
  void initState() {
    super.initState();
    _authSub = Supabase.instance.client.auth.onAuthStateChange.listen((state) {
      if (state.event == AuthChangeEvent.signedIn) {
        navigatorKey.currentState?.pushReplacementNamed('/onboarding');
      } else if (state.event == AuthChangeEvent.signedOut) {
        navigatorKey.currentState?.pushReplacementNamed('/');
      }
    });
  }

  @override
  void dispose() {
    _authSub.cancel(); // ← ยกเลิก subscription แค่นี้พอ
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Eascheck',
      navigatorKey: navigatorKey,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      initialRoute: '/',
      routes: {
        '/': (_) => const LoginPage(),
        '/onboarding': (_) => const OnboardingPage(),
        '/survey': (_) => const HealthSurveyPage(),
      },
    );
  }
}
