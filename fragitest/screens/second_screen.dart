import 'package:flutter/material.dart';

class SecondScreen extends StatelessWidget {
  const SecondScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2EBD9), // Custom beige color
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween, // This will push content to the top and bottom
        children: <Widget>[
          // Centered text: "VIBE AND SEEK"
          const SizedBox(height: 50), // Increased space between top and "Vibe and Seek"
          const Center(
            child: Text(
              'VIBE AND SEEK\nATHENS',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 50,
                fontFamily: 'CaesarDressing',
                color: Color(0xFF003366), // Text color for the main title
              ),
            ),
          ),
          const SizedBox(height: 20), // Reduced space between title and new text
          const Center(
            child: Text(
              'Experience the Athens that suits you\nFind the vibe that expresses you!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 22, // Adjust the size as needed
                fontFamily: 'Finlandica',
                color: Color(0xFF003366), // Updated text color
              ),
            ),
          ),
          const Spacer(), // This creates space between the text and the button

          // Centered "Get Started" button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50), // Horizontal padding for the button
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/login');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFD88D7F), // Button background color
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20), // Rounded corners
                ),
                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30), // Vertical and horizontal padding
              ),
              child: const Text(
                'GET STARTED',
                style: TextStyle(
                  fontSize: 22,
                  fontFamily: 'CaesarDressing',
                  color: Color(0xFF003366), // Button text color
                ),
              ),
            ),
          ),
          const SizedBox(height: 20), // Small space below the button to keep it from sticking to the edge
        ],
      ),
    );
  }
}
