import 'package:cavalcade/theme/pallete.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class LoginRegiButton extends StatelessWidget {
  final void Function()? onTap;
  final String text;
  const LoginRegiButton ({super.key, required this.onTap, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: Pallete.greyColor,
            borderRadius: BorderRadius.circular(9),
          ),
          child: Center(
            child: Text(
              text,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ),
      ),
    );
  }
}