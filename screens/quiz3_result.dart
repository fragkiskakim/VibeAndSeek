import 'package:flutter/material.dart';
import '../widgets/bottom_nav_bar.dart';
import '../widgets/header_2_lines.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Quiz3ResultScreen(
        godName: 'Poseidon',
        godDescription:
            'You’re Poseidon, god of the sea! Strong-willed, adventurous, and resilient, '
            'you have a powerful presence and a deep connection to nature.',
        godImagePath: 'assets/challenges_icons/poseidon_icon.png',
      ),
    );
  }
}

class Quiz3ResultScreen extends StatelessWidget {
  final String godName;
  final String godDescription;
  final String godImagePath;

  const Quiz3ResultScreen({
    super.key,
    required this.godName,
    required this.godDescription,
    required this.godImagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2EBD9),
      body: SafeArea(
        child: Column(
          children: [
            // Top Section
            Header_2_lines(
              onBackPressed: () {
                Navigator.pop(context);
              },
              firstLine: 'WHICH GREEK GOD',
              secondLine: 'ARE YOU?',
              firstUnderlineWidth: 200,
              secondUnderlineWidth: 120,
            ),

            const SizedBox(height: 8),

            // Result Section
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'You are',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                            fontFamily: 'Finlandica',
                            color: Color(0xFF003366),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${godName.toUpperCase()}!',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 28,
                            fontFamily: 'CaesarDressing',
                            color: Color(0xFFD88D7F),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      godDescription,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 18,
                        fontFamily: 'Finlandica',
                        color: Color(0xFF003366),
                      ),
                    ),
                    const SizedBox(height: 32),
                    Image.asset(
                      godImagePath,
                      height: 150,
                      width: 150,
                      fit: BoxFit.contain,
                    ),
                  ],
                ),
              ),
            ),

            // Navigation Buttons Section
            const NavigationButtons(),
          ],
        ),
      ),
    );
  }
}
