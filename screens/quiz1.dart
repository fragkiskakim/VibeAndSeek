import 'package:flutter/material.dart';
import '../widgets/header_1_line_descriptions.dart';
import '../widgets/bottom_nav_bar.dart';
import 'win1.dart';
import 'lose1.dart';
//import '../themes/color_palette.dart';
//import '../themes/text_styles.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Quiz1Screen(),
    );
  }
}

class Quiz1Screen extends StatefulWidget {
  const Quiz1Screen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _Quiz1ScreenState createState() => _Quiz1ScreenState();
}

class _Quiz1ScreenState extends State<Quiz1Screen> {
  int lives = 3;

  List<Map<String, String>> gods = [
    {
      'name': 'Athena',
      'description': 'Goddess of wisdom, war strategy',
      'image': 'assets/challenges_icons/athena.png'
    },
    {
      'name': 'Zeus',
      'description': 'God of the sky, lightning, and thunder',
      'image': 'assets/challenges_icons/zeus.png'
    },
    {
      'name': 'Ares',
      'description': 'God of war',
      'image': 'assets/challenges_icons/ares.png'
    },
    {
      'name': 'Dionysus',
      'description': 'God of wine, pleasure, and festivity',
      'image': 'assets/challenges_icons/dionysus.png'
    },
  ];

  List<Map<String, String>> remainingDescriptions = [
    {'description': 'Goddess of wisdom, war strategy'},
    {'description': 'God of the sky, lightning, and thunder'},
    {'description': 'God of war'},
    {'description': 'God of wine, pleasure, and festivity'},
  ];

  void handleMatch(String description, String godName) {
    setState(() {
      final correct = gods.firstWhere(
        (god) => god['name'] == godName && god['description'] == description,
        orElse: () => <String, String>{},
      );

      if (correct.isNotEmpty) {
        gods.remove(correct);
        remainingDescriptions
            .removeWhere((desc) => desc['description'] == description);

        if (gods.isEmpty) {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => const WinQuizScreen(
                        screenName: 'GREEK GODS\' QUIZ',
                        storeName: 'GREEK SOUVENIR STORE',
                        code: 'VIBEANDSEEK8787',
                      )));
        }
      } else {
        lives -= 1;
        if (lives == 0) {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => const LoseQuizScreen(
                        screenName: 'GREEK GODS\' QUIZ',
                        livesText: 'LOOKS LIKE YOU RAN OUT\nOF LIVES!',
                      )));
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2EBD9),
      body: SafeArea(
        child: Column(
          children: [
            // Top Section
            const QuizSectionHeader(
              title: 'GREEK GODS\' QUIZ',
              underlineWidth: 200,
              description:
                  'Drag the name of the God towards the correct description:',
            ),
            // Middle Section (Drag-and-Drop)
            Expanded(
              child: Row(
                children: [
                  // Gods list (Draggable)
                  Expanded(
                    child: ListView.builder(
                      itemCount: gods.length,
                      itemBuilder: (context, index) {
                        final god = gods[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 20.0),
                          child: Draggable<Map<String, String>>(
                            data: god,
                            feedback: Material(
                              color: Colors
                                  .transparent, // Removes the white background
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Image.asset(god['image']!,
                                      height: 55, width: 55),
                                  const SizedBox(width: 8),
                                  Text(
                                    god['name']!,
                                    style: const TextStyle(
                                      fontFamily: 'Finlandica',
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF003366),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            childWhenDragging:
                                const SizedBox(), // Hide original when dragging
                            onDraggableCanceled: (velocity, offset) {
                              setState(
                                  () {}); // Force UI refresh when the drag is canceled
                            },
                            child: Row(
                              children: [
                                Image.asset(god['image']!,
                                    height: 55, width: 55),
                                const SizedBox(width: 8),
                                Text(
                                  god['name']!,
                                  style: const TextStyle(
                                    fontFamily: 'Finlandica',
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF003366),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  // Descriptions list (DragTarget) without box
                  Expanded(
                    child: ListView.builder(
                      itemCount: remainingDescriptions.length,
                      itemBuilder: (context, index) {
                        final description =
                            remainingDescriptions[index]['description'];
                        return Padding(
                          padding: const EdgeInsets.only(
                              bottom: 35.0), // Increased bottom padding
                          child: DragTarget<Map<String, String>>(
                            // ignore: deprecated_member_use
                            onAccept: (data) {
                              handleMatch(description!, data['name']!);
                            },
                            builder: (context, candidateData, rejectedData) {
                              return Text(
                                description!,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontFamily: 'Finlandica',
                                  color: Color(0xFF003366),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Lives Section
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Number of lives:',
                  style: TextStyle(
                    fontFamily: 'Finlandica',
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF003366),
                  ),
                ),
                ...List.generate(
                  lives,
                  (index) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: Image.asset(
                      'assets/challenges_icons/heart_lives.png',
                      height: 45,
                      width: 45,
                    ),
                  ),
                ),
              ],
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
