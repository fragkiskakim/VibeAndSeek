import 'package:flutter/material.dart';

class PinkButton extends StatelessWidget {
  final String buttonText;
  final VoidCallback onPressed;

  const PinkButton({super.key, 
    required this.buttonText,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFD88D7F),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
      ),
      child: Text(
        buttonText,
        style: const TextStyle(
          fontSize: 22,
          fontFamily: 'CaesarDressing',
          color: Color(0xFF003366),
        ),
      ),
    );
  }
}
