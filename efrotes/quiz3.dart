import 'package:flutter/material.dart';
import '../widgets/bottom_nav_bar.dart';
import '../widgets/header_2_lines.dart';
import 'quiz3_result.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Quiz3Screen(),
    );
  }
}

class Quiz3Screen extends StatelessWidget {
  final Map<String, int> godPoints = {
    'Athena': 0,
    'Aphrodite': 0,
    'Zeus': 0,
    'Poseidon': 0,
  };

  Quiz3Screen({super.key});

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
            const SizedBox(height: 16),

            // Middle Section (Questions)
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    children: [
                      _buildQuestion(
                        context: context,
                        question: 'How do you approach challenges?',
                        imagePath:
                            'assets/challenges_icons/challenges_icon.png',
                        options: [
                          'Strategize and think it through carefully',
                          'Take charge and lead others to a solution',
                          'Try to keep the peace and avoid conflict',
                          'Dive in and handle it with force if needed',
                        ],
                        points: ['Athena', 'Zeus', 'Aphrodite', 'Poseidon'],
                      ),
                      const SizedBox(height: 32),
                      _buildQuestion(
                        context: context,
                        question: 'What’s most important to you?',
                        imagePath: 'assets/challenges_icons/important_icon.png',
                        options: [
                          'Knowledge and wisdom',
                          'Love and harmony',
                          'Power and respect',
                          'Strength and resilience',
                        ],
                        points: ['Athena', 'Aphrodite', 'Zeus', 'Poseidon'],
                      ),
                      const SizedBox(height: 32),
                      _buildQuestion(
                        context: context,
                        question: 'How do you spend your free time?',
                        imagePath: 'assets/challenges_icons/free_time_icon.png',
                        options: [
                          'Solving puzzles or reading',
                          'Spending time with loved ones',
                          'Leading a team or adventure',
                          'Swimming or exploring nature',
                        ],
                        points: ['Athena', 'Aphrodite', 'Zeus', 'Poseidon'],
                      ),
                      const SizedBox(height: 32),
                      _buildQuestion(
                        context: context,
                        question: 'Which of these traits describes you best?',
                        imagePath: 'assets/challenges_icons/traits_icon.png',
                        options: [
                          'Confident and commanding',
                          'Compassionate and empathetic',
                          'Intelligent and strategic',
                          'Determined and powerful',
                        ],
                        points: ['Zeus', 'Aphrodite', 'Athena', 'Poseidon'],
                      ),
                      const SizedBox(height: 32),
                      _buildQuestion(
                        context: context,
                        question: 'What\'s your idea of a perfect day?',
                        imagePath: 'assets/challenges_icons/day_icon.png',
                        options: [
                          'Taking the lead in an important decision',
                          'Adventure in nature or by the sea',
                          'Learning something new, solving a puzzle',
                          'Spending time with loved ones',
                        ],
                        points: ['Zeus', 'Poseidon', 'Athena', 'Aphrodite'],
                      ),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
            ),

            // Results Section
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Swipe left to see the results',
                    style: TextStyle(
                      fontFamily: 'Finlandica',
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: Color(0xFF003366),
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          const Color(0xFFD88D7F), // Pink button color
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          bottomLeft: Radius.circular(10),
                        ),
                      ),
                    ),
                    onPressed: () {
                      // Find the god with the highest points
                      String resultGod = godPoints.entries
                          .reduce((a, b) => a.value > b.value ? a : b)
                          .key;

                      // Navigate to the result screen
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            if (resultGod == 'Athena') {
                              return const Quiz3ResultScreen(
                                godName: 'Athena',
                                godDescription:
                                    'You’re Athena, godess of wisdom and war strategy! You value intellect and fairness, and people come to you for advice.',
                                godImagePath:
                                    'assets/challenges_icons/athena_icon.png',
                              );
                            } else if (resultGod == 'Aphrodite') {
                              return const Quiz3ResultScreen(
                                godName: 'Aphrodite',
                                godDescription:
                                    'You’re Aphrodite, godess of love and beaauty! You are compassionate, charismatic, and value harmony in all things.',
                                godImagePath:
                                    'assets/challenges_icons/aphrodite_icon.png',
                              );
                            } else if (resultGod == 'Zeus') {
                              return const Quiz3ResultScreen(
                                godName: 'Zeus',
                                godDescription:
                                    'You’re Zeus, god of the sky and thunder! You are a natural leader, decisive and powerful.',
                                godImagePath:
                                    'assets/challenges_icons/zeus_icon.png',
                              );
                            } else {
                              return const Quiz3ResultScreen(
                                godName: 'Poseidon',
                                godDescription:
                                    'You’re Poseidon, god of the sea! Strong-willed, adventurous, and resilient, '
                                    'you have a powerful presence and a deep connection to nature.',
                                godImagePath:
                                    'assets/challenges_icons/poseidon_icon.png',
                              );
                            }
                          },
                        ),
                      );
                    },
                    child: const Text(
                      'Results',
                      style: TextStyle(
                        fontFamily: 'Finlandica',
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF003366),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Navigation Buttons Section
            const NavigationButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildQuestion({
    required BuildContext context,
    required String question,
    required List<String> options,
    required String imagePath,
    required List<String> points,
  }) {
    int selectedIndex = -1;

    return StatefulBuilder(
      builder: (context, setState) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Question Header
            Row(
              children: [
                Image.asset(
                  imagePath,
                  height: 24,
                  width: 24,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    question,
                    style: const TextStyle(
                      fontSize: 18,
                      fontFamily: 'Finlandica',
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF003366),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Options
            Column(
              children: options.asMap().entries.map(
                (entry) {
                  int index = entry.key;
                  String option = entry.value;

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              if (selectedIndex == index) {
                                // Unselect the current option
                                selectedIndex = -1;
                                godPoints[points[index]] =
                                    (godPoints[points[index]] ?? 0) - 1;
                              } else {
                                // Select a new option
                                if (selectedIndex != -1) {
                                  // Reduce points for previously selected option
                                  godPoints[points[selectedIndex]] =
                                      (godPoints[points[selectedIndex]] ?? 0) -
                                          1;
                                }
                                selectedIndex = index;
                                godPoints[points[index]] =
                                    (godPoints[points[index]] ?? 0) + 1;
                              }
                            });
                          },
                          child: Image.asset(
                            selectedIndex == index
                                ? 'assets/challenges_icons/checked.png'
                                : 'assets/challenges_icons/unchecked.png',
                            height: 24,
                            width: 24,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            option,
                            style: const TextStyle(
                              fontSize: 14,
                              fontFamily: 'Finlandica',
                              color: Color(0xFF003366),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ).toList(),
            ),
          ],
        );
      },
    );
  }
}
