import 'package:flutter/material.dart';
import 'package:vibe_and_seek/widgets/header_1_line.dart';
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
      home: WinQuizScreen(
        screenName: 'GREEK GODS\' QUIZ',
        storeName: 'GREEK SOUVENIR STORE',
        code: 'VIBEANDSEEK8787',
      ),
    );
  }
}

class WinQuizScreen extends StatelessWidget {
  final String screenName; // Name of the screen
  final String storeName; // Store Name
  final String code; // Discount Code

  const WinQuizScreen({
    super.key,
    required this.screenName,
    required this.storeName,
    required this.code,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2EBD9),
      body: SafeArea(
        child: Column(
          children: [
            // Header Section
            SimpleHeader(
              title: screenName,
              underlineWidth: 200,
            ),
            Expanded(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Discount Message with Background
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          // Icon as the background
                          Image.asset(
                            'assets/challenges_icons/papyros.png', // Replace with your actual asset path
                            height: 300,
                            width: 300,
                            fit: BoxFit.contain,
                          ),
                          // Text on top of the icon
                          Center(
                            child: Text(
                              'CONGRATULATIONS!\nYOU HAVE A 10% DISCOUNT\nAT $storeName\nWITH THE CODE\n"$code"',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 22,
                                fontFamily: 'CaesarDressing',
                                color: Color(0xFFF2EBD9),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),
                      // Winner Image
                      Image.asset(
                        'assets/challenges_icons/winner.png', // Replace with the correct asset path
                        height: 150,
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
