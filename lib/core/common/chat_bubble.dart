import 'package:flutter/material.dart';

class chatBubble extends StatelessWidget {
  final String message;
  const chatBubble({super.key, required this.message});

  @override
Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.8), // Korlátozza a szélességet a képernyő 80%-ára
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: const Color.fromARGB(255, 34, 69, 97),
      ),
      child: Text(
        message,
        style: const TextStyle(fontSize: 15, color: Colors.white),
        softWrap: true, // Engedélyezi a sortörést
      ),
    );
  }
}