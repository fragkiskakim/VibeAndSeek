import 'package:flutter/material.dart';
import '../widgets/homepage_button.dart';
import '../widgets/bottom_nav_bar.dart';

class HomePageScreen extends StatefulWidget {
  const HomePageScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomePageScreenState createState() => _HomePageScreenState();
}

class _HomePageScreenState extends State<HomePageScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2EBD9),
      body: Column(
        children: [
          // Title section (fixed)
          Center(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: const Text(
                'VIBE AND SEEK\n ATHENS',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'CaesarDressing',
                  color: Color(0xFF003366), // Adjust color as needed
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          const SizedBox(height: 10),
          
          // Scrollable content
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    // Buttons for different sections using HomepageButton
                    HomepageButton(
                      assetPath: 'assets/images/profile_icon.png',
                      label: 'My Profile',
                      onTap: () {
                        Navigator.pushNamed(context, '/profile');
                      },
                    ),
                    const SizedBox(height: 20),
                    HomepageButton(
                      assetPath: 'assets/images/faces_icon.png',
                      label: "Today's Vibe",
                      onTap: () {
                        // TODO: Add navigation for "Today's Vibe" button
                      },
                    ),
                    const SizedBox(height: 20),
                    HomepageButton(
                      assetPath: 'assets/images/games_icon.png',
                      label: 'Challenges and \nGames',
                      onTap: () {
                        // TODO: Add navigation for "Challenges and Games" button
                      },
                    ),
                    const SizedBox(height: 40), // Space before icons row
                    // Flexible icons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Flexible(
                          child: _buildIcon('assets/images/human_1_icon.png', 140),
                        ),
                        const SizedBox(width: 20),
                        Flexible(
                          child: _buildIcon('assets/images/human_2_icon.png', 140),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          const NavigationButtons(),
        ],
      ),
    );
  }

  Widget _buildIcon(String assetPath, double size) {
    return GestureDetector(
      onTap: () {
        // TODO: Add navigation for this icon
      },
      child: Image.asset(
        assetPath,
        width: size,
        height: size,
      ),
    );
  }
}
