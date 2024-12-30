import 'package:flutter/material.dart';

class MyIconProfile extends StatelessWidget {
  final String titlePart1; // First part of the title (e.g., "MY")
  final String titlePart2; // Second part of the title (e.g., "PROFILE")
  final String iconPath; // Path to the icon asset
  final String underlinePath; // Path to the underline asset
  final double underlineWidth;

  const MyIconProfile({
    super.key,
    required this.titlePart1,
    required this.titlePart2,
    required this.iconPath,
    required this.underlinePath,
    required this.underlineWidth,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Back Button with minimal padding
        Align(
          alignment: Alignment.topLeft,
          child: IconButton(
            padding: EdgeInsets.zero, // Remove padding
            icon: Image.asset(
              'assets/images/back.png',
              height: 30,
              width: 30,
            ),
            onPressed: () {
              Navigator.pop(context); // Navigates back when pressed
            },
          ),
        ),

        // Title Row
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              titlePart1,
              style: const TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                fontFamily: 'CaesarDressing',
                color: Color(0xFF003366),
              ),
            ),
            const SizedBox(width: 5), // Minimal spacing between text and icon
            Image.asset(
              iconPath,
              width: 30,
              height: 30,
              fit: BoxFit.contain,
            ),
            const SizedBox(width: 5), // Minimal spacing between icon and text
            Text(
              titlePart2,
              style: const TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                fontFamily: 'CaesarDressing',
                color: Color(0xFF003366),
              ),
            ),
          ],
        ),

        // Underline with reduced space above
        const SizedBox(height: 2), // Reduced spacing
        Image.asset(
          underlinePath,
          width: underlineWidth,
          fit: BoxFit.contain,
        ),
      ],
    );
  }
}
