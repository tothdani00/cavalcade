import "package:cavalcade/core/common/sign_in_button.dart";
import "package:cavalcade/core/constants/constants.dart";
import "package:flutter/material.dart";


class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset(
          Constants.logoPath, 
          height: 60,
        ),
        actions: [
          TextButton(
            onPressed: () {}, 
            child: const Text('Kihagyás',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          )
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          const Text('Bejelentkezés', style: TextStyle(
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
        const SizedBox(height: 20),
        const SignInButton(),
      ],
      )
    );
  }
}