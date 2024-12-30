//import 'package:flutter/foundation.dart';
import '../widgets/header_1_line_descriptions.dart';
import '../widgets/bottom_nav_bar.dart';
import 'win1.dart';
import 'winnomorecoupons.dart';
import 'lose1.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../utils/global_state.dart';

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class Quiz1Screen extends StatefulWidget {
  final String? userId =
      GlobalState().currentUserId; // User ID from the Users collection

  Quiz1Screen({super.key});

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

  void handleMatch(String description, String godName) async {
    // Perform asynchronous work outside setState
    final correct = gods.firstWhere(
      (god) => god['name'] == godName && god['description'] == description,
      orElse: () => <String, String>{},
    );

    if (correct.isNotEmpty) {
      setState(() {
        gods.remove(correct);
        remainingDescriptions
            .removeWhere((desc) => desc['description'] == description);
      });
      if (GlobalState().soundAllowed) {
        final player = AudioPlayer();
        await player.setAsset('assets/sounds/correct.mp3');
        await player.play();
      }

      if (gods.isEmpty) {
        // Fetch a coupon from the database
        final couponSnapshot =
            await FirebaseFirestore.instance.collection('Coupons').get();

        // Fetch user coupons to filter out already used ones
        final userCouponsDoc = await FirebaseFirestore.instance
            .collection('User_Coupons')
            .doc(widget.userId)
            .get();

        // Get a list of coupon IDs the user already has
        final userCouponIds = userCouponsDoc.exists
            ? userCouponsDoc
                .data()!
                .values
                .map((coupon) => coupon['coupon_id'])
                .toSet()
            : <String>{};

        // Filter coupons that are not already used by the user
        final availableCoupons = couponSnapshot.docs.where((couponDoc) {
          return !userCouponIds.contains(couponDoc.id);
        }).toList();

        if (availableCoupons.isNotEmpty) {
          // Pick the first available coupon
          final selectedCoupon = availableCoupons.first;
          final couponData = selectedCoupon.data();

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => WinQuizScreen(
                screenName: 'GREEK GODS\' QUIZ',
                storeName: couponData['store_name'] ?? 'Unknown Store',
                code: couponData['code'] ?? 'NO-CODE',
                discountpercentage:
                    (couponData['discount_percentage'] ?? 10).toString(),
              ),
            ),
          );

          // Add the selected coupon to the user's document in User_Coupons collection
          await FirebaseFirestore.instance
              .collection('User_Coupons')
              .doc(widget.userId)
              .set({
            DateTime.now().millisecondsSinceEpoch.toString(): {
              'coupon_id': selectedCoupon.id,
            },
          }, SetOptions(merge: true));
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const WinNoMoreCoupons(
                screenName: 'GREEK GODS\' QUIZ',
              ),
            ),
          );
        }
      }
    } else {
      if (GlobalState().soundAllowed) {
        final player = AudioPlayer();
        await player.setAsset('assets/sounds/wrong.mp3');
        await player.play();
      }
      setState(() {
        lives -= 1;
      });

      if (lives == 0) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const LoseQuizScreen(
              screenName: 'GREEK GODS\' QUIZ',
              livesText: 'LOOKS LIKE YOU RAN OUT\nOF LIVES!',
            ),
          ),
        );
      }
    }
  }

  Widget _buildLivesDisplay() {
    return Row(
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
    );
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
                        return _buildGodWidget(gods[index]);
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
            _buildLivesDisplay(),
            const SizedBox(height: 8),
            // Navigation Buttons Section
            const NavigationButtons(),
          ],
        ),
      ),
    );
  }
}

Widget _buildGodWidget(Map<String, String> god) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 20.0),
    child: Draggable<Map<String, String>>(
      data: god,
      feedback: Material(
        color: Colors.transparent,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(god['image']!, height: 55, width: 55),
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
      childWhenDragging: const SizedBox(),
      child: Row(
        children: [
          Image.asset(god['image']!, height: 55, width: 55),
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
}
