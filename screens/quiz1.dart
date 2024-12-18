import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Quiz1Screen(),
    );
  }
}

class Quiz1Screen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: const Color(0xFFF2EBD9),
        elevation: 0,
        title: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'GREEK GODS\' QUIZ',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 30,
                fontFamily: 'CaesarDressing',
                color: Color(0xFF003366), // Title color
              ),
            ),
            const SizedBox(height: 4),
            Image.asset(
              'assets/challenges_icons/Underline.png', // Custom underline
              width: 230,
              fit: BoxFit.contain,
            ),
          ],
        ),
        leading: IconButton(
          icon: Image.asset(
            'assets/images/back.png', // Back icon asset
            height: 30,
            width: 30,
          ),
          onPressed: () {
            Navigator.pop(context); // Navigate back
          },
        ),
      ),
      backgroundColor: const Color(0xFFF2EBD9),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Center(
              child: Text(
                'Drag the name of the God towards the correct description:',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontFamily: 'Finlandica',
                  color: Color(0xFF003366),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: ListView(
                children: [
                  _buildQuizRow(
                    name: 'Athena',
                    imagePath: 'assets/challenges_icons/athena.png',
                    description: 'Goddess of wisdom, war strategy',
                  ),
                  const SizedBox(height: 16),
                  _buildQuizRow(
                    name: 'Zeus',
                    imagePath: 'assets/challenges_icons/zeus.png',
                    description: 'God of the sky, lightning, and thunder',
                  ),
                  const SizedBox(height: 16),
                  _buildQuizRow(
                    name: 'Ares',
                    imagePath: 'assets/challenges_icons/ares.png',
                    description: 'God of war',
                  ),
                  const SizedBox(height: 16),
                  _buildQuizRow(
                    name: 'Dionysus',
                    imagePath: 'assets/challenges_icons/dionysus.png',
                    description: 'God of wine, pleasure, and festivity',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Number of Lives Section
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Number of lives:',
                  style: TextStyle(
                    fontFamily: 'Finlandica',
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF003366),
                  ),
                ),
                Row(
                  children: [
                    Stack(
                      alignment:
                          Alignment.center, // Centers the text inside the heart
                      children: [
                        // Heart Icon
                        Image.asset(
                          'assets/challenges_icons/heart_lives.png', // Back icon asset
                          height: 45,
                          width: 45,
                        ),
                        // Number inside the heart
                        const Text(
                          '3',
                          style: TextStyle(
                            fontFamily: 'CaesarDressing',
                            fontSize:
                                25, // Adjust font size to fit inside the heart
                            color: Color(
                                0xFF003366), // White color to contrast with the red heart
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/images/forum_icon.png',
              height: 30,
              width: 30,
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/images/home_icon.png',
              height: 24,
              width: 24,
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/images/maps_icon.png',
              height: 30,
              width: 30,
            ),
            label: '',
          ),
        ],
        backgroundColor: const Color(0xFFF2EBD9),
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }

  // Builds a single quiz row
  Widget _buildQuizRow({
    required String name,
    required String imagePath,
    required String description,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // God Image
        Image.asset(
          imagePath,
          height: 55,
          width: 55,
        ),
        const SizedBox(width: 1),
        // God Name
        Text(
          name,
          style: const TextStyle(
            fontFamily: 'Finlandica',
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF003366),
          ),
        ),
        const Spacer(),
        // Description
        SizedBox(
          width: 180, // Set the desired standard width
          child: Text(
            description,
            style: const TextStyle(
              fontFamily: 'Finlandica',
              fontSize: 16,
              color: Color(0xFF003366),
            ),
            textAlign: TextAlign.right, // Align text to the right
          ),
        ),
      ],
    );
  }
}
