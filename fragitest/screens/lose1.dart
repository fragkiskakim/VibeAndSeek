import 'package:flutter/material.dart';
import '../widgets/header_1_line.dart';
import '../widgets/bottom_nav_bar.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoseQuizScreen(
        screenName: 'GREEK GODS\' QUIZ',
        livesText: 'LOOKS LIKE YOU RAN OUT\nOF LIVES!',
      ),
    );
  }
}

class LoseQuizScreen extends StatelessWidget {
  final String screenName; // Name of the screen
  final String livesText; // Text to display for lives

  const LoseQuizScreen({
    super.key,
    required this.screenName,
    required this.livesText,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2EBD9),
      body: SafeArea(
        child: Column(
          children: [
            // Top Section
            SimpleHeader(
              title: screenName, // Use the passed screen name
              underlineWidth: 200,
            ),
            // Center the Expanded section vertically
            Expanded(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // "Oops" Message
                      Text(
                        'OOPS...\n$livesText\nBETTER LUCK NEXT TIME!',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 22,
                          fontFamily: 'CaesarDressing',
                          color: Color(0xFF003366),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 32),
                      // Image of the temple
                      Image.asset(
                        'assets/challenges_icons/temple.png', // Replace with the correct temple image asset
                        height: 150, // Adjust as needed
                        fit: BoxFit.contain,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            // Navigation Buttons Section
            const NavigationButtons(),
          ],
        ),
      ),
    );
  }
}
