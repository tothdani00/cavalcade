import 'package:cavalcade/features/auth/screens/login.dart';
import 'package:cavalcade/theme/pallete.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Cavalcade',
      theme: Pallete.lightModeAppTheme,
      home: const Login(),
    );
  }
}
