import 'package:flutter/material.dart';
import 'homepage_screen.dart';

class MyVibe1Screen extends StatefulWidget {
  const MyVibe1Screen({Key? key}) : super(key: key);

  @override
  _MyVibe1ScreenState createState() => _MyVibe1ScreenState();
}

class _MyVibe1ScreenState extends State<MyVibe1Screen> {
  final List<bool> isSelected = List.generate(12, (_) => false); // Initial state

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:const Color(0xFFF2EBD9), // Background color
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 40),
            const Text(
              'MY VIBE',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                fontFamily: 'CaesarDressing',
                color: Color(0xFF003366),
              ),
            ),
            const SizedBox(height: 1),
            // Add the underline image below the title
            Image.asset(
              'assets/images/underline.png',
              width: 130, // Adjust the width as needed
              height: 20,  // Adjust the height as needed
            ),
            const SizedBox(height: 20),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 3,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemCount: 12,
                itemBuilder: (context, index) {
                  final vibes = [
                    'Architectural admirer',
                    'Café & Cheers',
                    'Nature lover',
                    'Adventure chaser',
                    'Foodie',
                    'Alternative spots seeker',
                    'Art aficionado',
                    'History buff',
                    'Night life seeker',
                    'Local explorer',
                    'Zen seeker',
                    'Whatever (surprise me!)',
                  ];
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        isSelected[index] = !isSelected[index];
                      });
                    },
                    child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: isSelected[index] ? const Color(0xFFD19348) : const Color(0xFF003366),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        vibes[index],
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                },
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFD88D7F),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HomePageScreen()),
                );
              },
              child: const Text(
                'CONTINUE',
                style: TextStyle(
                  fontFamily: 'CaesarDressing',
                  color: Color(0xFF003366),
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
