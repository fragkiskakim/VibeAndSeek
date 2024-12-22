import 'package:flutter/material.dart';
import 'quiz1.dart';
import 'quiz2.dart';
import 'quiz3.dart';
import 'quiz4.dart';
import 'quiz5.dart';
import '../widgets/bottom_nav_bar.dart';
import '../widgets/header_2_lines.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final FirebaseFirestore firestore = FirebaseFirestore.instance;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Initialize Firebase
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ChallengesAndGamesScreen(),
    );
  }
}

class ChallengesAndGamesScreen extends StatefulWidget {
  const ChallengesAndGamesScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ChallengesAndGamesScreenState createState() =>
      _ChallengesAndGamesScreenState();
}

class _ChallengesAndGamesScreenState extends State<ChallengesAndGamesScreen> {
  // Initial challenges data
  List<Map<String, dynamic>> challenges = [
    {'title': 'Eat a souvlaki', 'completed': false},
    {'title': 'Join a Greek Dance Circle', 'completed': false},
    {'title': 'Buy a Komboloi', 'completed': false},
    {'title': 'Taste a Glass of Ouzo', 'completed': false},
    {'title': 'Try Tyropita or Spanakopita', 'completed': false},
    {'title': 'Attend a Live Bouzouki Show', 'completed': false},
    {'title': 'Learn a Few Greek Words', 'completed': false},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2EBD9),
      body: SafeArea(
        child: Column(
          children: [
            Header_2_lines(
              onBackPressed: () {
                Navigator.pop(context);
              },
              firstLine: 'CHALLENGES AND',
              secondLine: 'GAMES',
              firstUnderlineWidth: 180,
              secondUnderlineWidth: 100,
            ),
            const SizedBox(height: 2),
            // Scrollable content
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding:
                      const EdgeInsets.all(16.0), // Add padding to the content
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Challenges Section
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/challenges_icons/challenges.png',
                            height: 55,
                            width: 55,
                          ),
                          const SizedBox(width: 2),
                          const Text(
                            'CHALLENGES',
                            style: TextStyle(
                              fontFamily: 'CaesarDressing',
                              color: Color(0xFF003366),
                              fontWeight: FontWeight.bold,
                              fontSize: 24,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      ..._buildChallengesList(),
                      const SizedBox(height: 32),
                      // Games Section
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/challenges_icons/games.png',
                            height: 55,
                            width: 55,
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            'GAMES',
                            style: TextStyle(
                              fontFamily: 'CaesarDressing',
                              color: Color(0xFF003366),
                              fontWeight: FontWeight.bold,
                              fontSize: 24,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      _buildGamesGrid(),
                      const SizedBox(height: 32),
                      // Points Display
                      Center(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 30),
                          decoration: BoxDecoration(
                            color: const Color(0xFFD88D7F),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text(
                            'YOUR POINTS: 5',
                            style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'CaesarDressing',
                              color: Color(0xFF003366),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            ),
            // Fixed Navigation Buttons Section
            const NavigationButtons(),
          ],
        ),
      ),
    );
  }

  // Builds the challenges list
  List<Widget> _buildChallengesList() {
    return challenges
        .map(
          (challenge) => Row(
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    challenge['completed'] = !challenge['completed'];
                  });
                },
                child: Image.asset(
                  challenge['completed']
                      ? 'assets/challenges_icons/checked.png'
                      : 'assets/challenges_icons/unchecked.png',
                  height: 24,
                  width: 24,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                challenge['title'],
                style: const TextStyle(
                  color: Color(0xFF003366),
                  fontSize: 18,
                  fontFamily: 'Finlandica',
                ),
              ),
            ],
          ),
        )
        .toList();
  }

  // Builds the games grid
  Widget _buildGamesGrid() {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 20,
      crossAxisSpacing: 20,
      children: [
        _buildGameTile(
          'Greek Gods\' Quiz',
          'assets/challenges_icons/greek_gods_quiz.png',
          const Quiz1Screen(),
        ),
        _buildGameTile(
          'Famous Quotes Quiz',
          'assets/challenges_icons/famous_quotes_quiz.png',
          const Quiz2Screen(),
        ),
        _buildGameTile(
          'Which Greek God Are You?',
          'assets/challenges_icons/which_greek_god.png',
          Quiz3Screen(),
        ),
        _buildGameTile(
          'Greek Cross-Word',
          'assets/challenges_icons/greek_crossword.png',
          const Quiz4Screen(),
        ),
        _buildGameTile(
          'Memory Game',
          'assets/challenges_icons/memory_game.png',
          const Quiz5Screen(),
        ),
      ],
    );
  }

  // Builds a single game tile
  Widget _buildGameTile(String title, String assetPath, Widget screen) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => screen),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF003366),
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.all(8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              assetPath,
              height: 60,
              width: 60,
            ),
            const SizedBox(width: 2),
            Expanded(
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Color(0xFFF2EBD9),
                  fontSize: 14,
                  fontFamily: 'Finlandica',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
