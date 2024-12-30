import 'package:flutter/material.dart';
import '../widgets/header_1_line.dart';
import '../widgets/bottom_nav_bar.dart';

class WinQuizScreen extends StatelessWidget {
  final String screenName; // Name of the screen
  final String storeName; // Store Name
  final String code; // Discount Code
  final String discountpercentage; //Discount percentage

  const WinQuizScreen({
    super.key,
    required this.screenName,
    required this.storeName,
    required this.code,
    required this.discountpercentage,
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
                              'CONGRATULATIONS!\nYOU HAVE A $discountpercentage% DISCOUNT\nAT $storeName\nWITH THE CODE\n"$code"',
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
