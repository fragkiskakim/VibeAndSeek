import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'quiz1.dart';
import 'quiz2.dart';
import 'quiz3.dart';
import 'quiz4.dart';
import 'quiz5.dart';

import '../widgets/bottom_nav_bar.dart';
import '../widgets/header_1_line.dart';

import '../utils/global_state.dart';

class ChallengesAndGamesScreen extends StatefulWidget {
  final String? userId =
      GlobalState().currentUserId; // User ID from the Users collection

  ChallengesAndGamesScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ChallengesAndGamesScreenState createState() =>
      _ChallengesAndGamesScreenState();
}

class _ChallengesAndGamesScreenState extends State<ChallengesAndGamesScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Map<String, bool> temporaryCompletedStates = {}; // Temporary state changes
  List<Map<String, dynamic>> _displayedChallenges = []; // Challenges on screen
  bool _isLoading = true; // Tracks loading state

  @override
  void initState() {
    super.initState();
    _loadChallenges(); // Load initial challenges
  }

  // Fetch initial challenges
  Future<void> _loadChallenges() async {
    setState(() {
      _isLoading = true;
    });

    final challenges = await _getFilteredChallenges();
    setState(() {
      _displayedChallenges = challenges; // Set challenges to display
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2EBD9),
      body: SafeArea(
        child: Column(
          children: [
            const SimpleHeader(
              title: 'CHALLENGES & GAMES',
              underlineWidth: 250,
            ),
            const SizedBox(height: 2),
            _isLoading
                ? const Center(child: CircularProgressIndicator())
                : Expanded(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // Challenges Section Header
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

                            // Challenges List
                            _buildChallengesList(),

                            // Buttons Row (Save Changes and My Completed Challenges)
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    _saveChanges();
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(
                                        0xFFF2EBD9), // Button background color
                                    foregroundColor: Colors.white, // Text color
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          12), // Rounded corners
                                      side: const BorderSide(
                                        color:
                                            Color(0xFF003366), // Border color
                                        width: 2, // Border width
                                      ),
                                    ),
                                  ),
                                  child: const Text(
                                    'Save changes',
                                    style: TextStyle(
                                      fontFamily: 'Finlandica',
                                      color: Color(0xFF003366),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 8,
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    _navigateToCompletedChallenges();
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(
                                        0xFFF2EBD9), // Button background color
                                    foregroundColor: Colors.white, // Text color
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          12), // Rounded corners
                                      side: const BorderSide(
                                        color:
                                            Color(0xFF003366), // Border color
                                        width: 2, // Border width
                                      ),
                                    ),
                                  ),
                                  child: const Text(
                                    'Completed Challenges',
                                    style: TextStyle(
                                      fontFamily: 'Finlandica',
                                      color: Color(0xFF003366),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 32),

                            // Games Section Header
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

                            // Games Grid
                            _buildGamesGrid(),

                            const SizedBox(height: 32),

                            // Points Display
                            Center(
                              child: StreamBuilder<DocumentSnapshot>(
                                stream: FirebaseFirestore.instance
                                    .collection(
                                        'Users') // Adjust the collection name if needed
                                    .doc(widget
                                        .userId) // Fetch the document with the userId
                                    .snapshots(),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const CircularProgressIndicator(); // Show loading spinner
                                  }
                                  if (snapshot.hasError) {
                                    return const Text(
                                        'Error fetching points'); // Handle errors
                                  }
                                  if (!snapshot.hasData ||
                                      !snapshot.data!.exists) {
                                    return const Text(
                                        'User not found'); // Handle missing user data
                                  }

                                  final userData = snapshot.data!.data()
                                      as Map<String, dynamic>;
                                  final points = userData['points'] ??
                                      0; // Default to 0 if points are missing

                                  return Container(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 8, horizontal: 30),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFD88D7F),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      'YOUR POINTS: $points',
                                      style: const TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'CaesarDressing',
                                        color: Color(0xFF003366),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),

                            const SizedBox(height: 16),
                          ],
                        ),
                      ),
                    ),
                  ),
            const NavigationButtons(),
          ],
        ),
      ),
    );
  }

  // Builds the displayed challenges list
  Widget _buildChallengesList() {
    return Column(
      children: _displayedChallenges.map((challenge) {
        final description = challenge['description'] ?? 'No Description';
        final challengeId = challenge['id'];
        final isChecked =
            temporaryCompletedStates[challengeId] ?? false; // Temporary state

        return Row(
          children: [
            GestureDetector(
              onTap: () {
                setState(() {
                  // Toggle the temporary state locally
                  temporaryCompletedStates[challengeId] =
                      !(temporaryCompletedStates[challengeId] ?? false);
                });
              },
              child: Image.asset(
                isChecked
                    ? 'assets/challenges_icons/checked.png'
                    : 'assets/challenges_icons/unchecked.png',
                height: 24,
                width: 24,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                description,
                style: const TextStyle(
                  color: Color(0xFF003366),
                  fontSize: 18,
                  fontFamily: 'Finlandica',
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        );
      }).toList(),
    );
  }

  // Save changes to Firestore and load new challenges
  Future<void> _saveChanges() async {
    setState(() {
      _isLoading = true; // Show loading spinner
    });

    final batch = _firestore.batch();
    int totalPointsToAdd = 0;

    // Identify newly checked challenges
    final newCompletedChallenges = temporaryCompletedStates.entries
        .where((entry) => entry.value == true)
        .map((entry) => entry.key)
        .toList();

    // Fetch points for new challenges
    for (String challengeId in newCompletedChallenges) {
      final challengeDoc =
          await _firestore.collection('Challenges').doc(challengeId).get();
      if (challengeDoc.exists) {
        final challengeData = challengeDoc.data() as Map<String, dynamic>;
        final pointsGained = challengeData['points_gained'] ?? 0;
        totalPointsToAdd += totalPointsToAdd += (pointsGained as int);

        // Add challenge to User_challenges
        final docRef = _firestore.collection('User_challenges').doc();
        batch.set(docRef, {
          'user_id': widget.userId,
          'challenge_id': challengeId,
        });
      }
    }

    // Update user's points
    final userDocRef = _firestore.collection('Users').doc(widget.userId);
    final userDoc = await userDocRef.get();
    if (userDoc.exists) {
      final userData = userDoc.data() as Map<String, dynamic>;
      final currentPoints = userData['points'] ?? 0;
      batch.update(userDocRef, {'points': currentPoints + totalPointsToAdd});
    }

    // Commit the batch write
    await batch.commit();

    // Clear the temporary states
    temporaryCompletedStates.clear();

    // Load new challenges after saving
    await _loadChallenges();
  }

  // Fetch 5 random challenges not completed by the user
  Future<List<Map<String, dynamic>>> _getFilteredChallenges() async {
    final completedChallengesSnapshot = await _firestore
        .collection('User_challenges')
        .where('user_id', isEqualTo: widget.userId)
        .get();

    final completedChallengeIds =
        completedChallengesSnapshot.docs.map((doc) => doc['challenge_id']);

    final allChallengesSnapshot =
        await _firestore.collection('Challenges').get();

    final availableChallenges = allChallengesSnapshot.docs
        .where((doc) => !completedChallengeIds.contains(doc.id))
        .toList();

    // Shuffle and pick 5 random challenges
    availableChallenges.shuffle();
    final selectedChallenges = availableChallenges.take(5).toList();

    return selectedChallenges.map((doc) {
      final data = doc.data();
      return {
        'id': doc.id,
        ...data,
      };
    }).toList();
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
          Quiz1Screen(),
        ),
        _buildGameTile(
          'Famous Quotes Quiz',
          'assets/challenges_icons/famous_quotes_quiz.png',
          Quiz2Screen(),
        ),
        _buildGameTile(
          'Which Greek God Are You?',
          'assets/challenges_icons/which_greek_god.png',
          Quiz3Screen(),
        ),
        _buildGameTile(
          'Greek Cross-Word',
          'assets/challenges_icons/greek_crossword.png',
          Quiz4Screen(),
        ),
        _buildGameTile(
          'Memory Game',
          'assets/challenges_icons/memory_game.png',
          Quiz5Screen(),
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

  // Navigate to My Completed Challenges screen as a popup
  void _navigateToCompletedChallenges() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFFF2EBD9),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Completed challenges',
                style: TextStyle(
                  color: Color(0xFF003366),
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Finlandica',
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
              ),
            ],
          ),
          content: SizedBox(
            width: double.maxFinite,
            child:
                _buildCompletedChallengesList(), // Build the completed challenges list
          ),
        );
      },
    );
  }

  Widget _buildCompletedChallengesList() {
    return FutureBuilder<QuerySnapshot>(
      future: _firestore
          .collection('User_challenges')
          .where('user_id', isEqualTo: widget.userId)
          .get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(
            child: Text('No completed challenges found.'),
          );
        }

        final completedChallenges = snapshot.data!.docs;

        return ListView.builder(
          shrinkWrap: true,
          itemCount: completedChallenges.length,
          itemBuilder: (context, index) {
            final data =
                completedChallenges[index].data() as Map<String, dynamic>;
            final challengeId = data['challenge_id'];

            return FutureBuilder<DocumentSnapshot>(
              future:
                  _firestore.collection('Challenges').doc(challengeId).get(),
              builder: (context, challengeSnapshot) {
                if (challengeSnapshot.connectionState ==
                    ConnectionState.waiting) {
                  return const ListTile(
                    title: Text('Loading...'),
                  );
                }
                if (!challengeSnapshot.hasData ||
                    !challengeSnapshot.data!.exists) {
                  return const ListTile(
                    title: Text('Challenge not found'),
                  );
                }

                final challengeData =
                    challengeSnapshot.data!.data() as Map<String, dynamic>;
                final description =
                    challengeData['description'] ?? 'No Description';

                return ListTile(
                  title: Text(
                    description,
                    style: const TextStyle(
                      fontFamily: 'Finlandica',
                      fontSize: 18,
                      color: Color(0xFF003366),
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
