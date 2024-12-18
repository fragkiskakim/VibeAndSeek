import 'package:flutter/material.dart';
import 'second_screen.dart';

class StartScreen extends StatefulWidget {
  const StartScreen({super.key});

  @override
  _StartScreenState createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  @override
  void initState() {
    super.initState();
    // Navigate to the next screen after a delay
    Future.delayed(Duration(milliseconds: 800), () {
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => const SecondScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(0.0, 1.0); // Animation starting point (from the bottom)
            const end = Offset.zero; // Animation ending point (center)
            const curve = Curves.bounceOut; // Bouncy curve

            var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
            var offsetAnimation = animation.drive(tween);

            return SlideTransition(position: offsetAnimation, child: child);
          },
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFF003366), // Background color to match your design
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget> [
            //Main Vibe And Seek text
            Text(
              'VIBE AND SEEK\nATHENS',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 50, // Adjust size as needed
                color: Color(0xFFF2EBD9), // Text color
                fontWeight: FontWeight.bold,
                fontFamily: 'CaesarDressing', // Use the custom font
              ),
            ),
            SizedBox(height: 20), //Space between
            Text(
              'Experience the Athens that suits you\nFind the vibe that expresses you!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 22, // Adjust the size as needed
                color: Color(0xFFF2EBD9), // Text color
                fontFamily: 'Finlandica', // Use the custom font
              ),
            ),
          ]
        )
      ),
    );
  }
}
