import 'package:flutter/material.dart';

class chatBubble extends StatelessWidget {
  final String message;
  const chatBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: const Color.fromARGB(255, 34, 69, 97),
      ),
      child: Text(
        message,
        style: TextStyle(fontSize: 15, color: Colors.white),
      ),
    );
  }
}