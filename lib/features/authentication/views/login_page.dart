// lib/features/authentication/views/login_page.dart

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:eascheck/features/authentication/views/login_button.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  /// Sign in with Google using Supabase OAuth
  Future<void> _signInWithGoogle(BuildContext context) async {
    try {
      await Supabase.instance.client.auth.signInWithOAuth(
        OAuthProvider.google,
        redirectTo: 'io.supabase.eascheck://login-callback',
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Login with Google failed: $e')));
    }
  }

  /// Sign in with Facebook using Supabase OAuth
  Future<void> _signInWithFacebook(BuildContext context) async {
    try {
      await Supabase.instance.client.auth.signInWithOAuth(
        OAuthProvider.facebook,
        redirectTo: 'io.supabase.eascheck://login-callback',
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Login with Facebook failed: $e')));
    }
  }

  /// Placeholder for LINE Login (Supabase SDK ยังไม่รองรับ)
  Future<void> _signInWithLine(BuildContext context) async {
    // TODO: implement LINE OAuth flow yourself (e.g. via url_launcher)
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('LINE login not implemented yet')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background image
          Image.asset('assets/images/bg_food.jpg', fit: BoxFit.cover),
          // Dark overlay
          Container(color: Colors.black.withOpacity(0.6)),

          // Content
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(),

                // Logo
                Image.asset('assets/images/plant_logo.png', height: 80),
                const SizedBox(height: 12),

                // App title
                const Text(
                  'Eascheck',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const Spacer(),

                // OAuth Login Buttons
                LoginButton(
                  provider: AuthProvider.google,
                  onPressed: () => _signInWithGoogle(context),
                ),
                const SizedBox(height: 12),
                LoginButton(
                  provider: AuthProvider.facebook,
                  onPressed: () => _signInWithFacebook(context),
                ),
                const SizedBox(height: 12),
                LoginButton(
                  provider: AuthProvider.line,
                  onPressed: () => _signInWithLine(context),
                ),

                const SizedBox(height: 16),

                // Footer links
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text(
                      'Privacy policy',
                      style: TextStyle(color: Colors.grey),
                    ),
                    Text(
                      'Terms of service',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
