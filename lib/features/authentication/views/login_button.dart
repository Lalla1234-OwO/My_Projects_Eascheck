// features/authentication/views/login_button.dart

import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';

enum AuthProvider { google, facebook, line }

class LoginButton extends StatelessWidget {
  final AuthProvider provider;
  final void Function() onPressed;

  const LoginButton({
    super.key,
    required this.provider,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    switch (provider) {
      case AuthProvider.google:
        return SignInButton(
          Buttons.Google,
          text: 'Continue with Google',
          onPressed: onPressed,
        );
      case AuthProvider.facebook:
        return SignInButton(
          Buttons.Facebook,
          text: 'Continue with Facebook',
          onPressed: onPressed,
        );
      case AuthProvider.line:
        return SignInButtonBuilder(
          text: 'Continue with Line',
          icon: Icons.chat,
          onPressed: onPressed,
          backgroundColor: const Color(0xFF00C300),
          height: 50,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        );
    }
  }
}
