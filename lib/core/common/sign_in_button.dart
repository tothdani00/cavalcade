import "package:cavalcade/core/constants/constants.dart";
import "package:cavalcade/features/auth/controller/auth_controller.dart";
import "package:cavalcade/theme/pallete.dart";
import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";


class SignInButton extends ConsumerWidget {
  final bool isFromLogin;
  const SignInButton({super.key, this.isFromLogin = true});


  void signInWithGoogle(BuildContext context, WidgetRef ref) {
    ref.read(authControllerProvider.notifier).signInWithGoogle(context, isFromLogin);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: ElevatedButton.icon(
        onPressed: () => signInWithGoogle(context, ref),
        icon: Image.asset(
          Constants.googlePath, 
          width: 35,
        ),
        label: const Text('Bejelentkezés Google fiókkal', 
        style: TextStyle(fontSize: 15, color: Colors.white),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Pallete.greyColor,
          minimumSize: const Size(10, 50),
        ),
      ),
    );
  }
}