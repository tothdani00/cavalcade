import "package:cavalcade/core/common/loader.dart";
import "package:cavalcade/core/common/sign_in_button.dart";
import "package:cavalcade/core/constants/constants.dart";
import "package:cavalcade/features/auth/controller/auth_controller.dart";
import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";

class Login extends ConsumerWidget {
  const Login({super.key});

 @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(authControllerProvider);
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Image.asset(
              Constants.logoPath, 
              height: 50,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {}, 
            child: const Text(
              'Kihagyás',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          )
        ],
      ),
      body: isLoading 
      ? const Loader() 
      : Center(
        child: Column(
          children: [
            const SizedBox(height: 20),
            const Text(
              'Bejelentkezés', 
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset(
                Constants.loginbackgroundPath, 
                height: 200,
              ),
            ),
            const SizedBox(height: 30),
            const SignInButton(),
          ],
        ),
      ),
    );
  }
}