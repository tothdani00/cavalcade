import "package:cavalcade/core/constants/constants.dart";
import "package:cavalcade/theme/pallete.dart";
import "package:flutter/material.dart";


class SignInButton extends StatelessWidget {
  const SignInButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: ElevatedButton.icon(
        onPressed: () {},
        icon: Image.asset(
          Constants.googlePath, 
          width: 35,
        ),
        label: const Text('Google-al való bejelentkezés', 
        style: TextStyle(fontSize: 15),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Pallete.greyColor,
          minimumSize: const Size(10, 50),
        ),
      ),
    );
  }
}