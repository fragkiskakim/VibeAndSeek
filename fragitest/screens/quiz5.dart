import 'package:flutter/material.dart';
import 'dart:async';
import '../widgets/bottom_nav_bar.dart';
import '../widgets/header_1_line_descriptions.dart';
import 'lose1.dart';
import 'win1.dart';
import 'winnomorecoupons.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../utils/global_state.dart';

class Quiz5Screen extends StatefulWidget {
  final String? userId = GlobalState().currentUserId;
  Quiz5Screen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _Quiz5ScreenState createState() => _Quiz5ScreenState();
}

class _Quiz5ScreenState extends State<Quiz5Screen> {
  final List<String> memoryIcons = [
    'assets/challenges_icons/owl.png',
    'assets/challenges_icons/goddess.png',
    'assets/challenges_icons/parthenon.png',
    'assets/challenges_icons/triaina.png',
    'assets/challenges_icons/colona.png',
    'assets/challenges_icons/spartan.png',
    'assets/challenges_icons/lightning.png',
    'assets/challenges_icons/minoan.png',
    'assets/challenges_icons/owl.png',
    'assets/challenges_icons/goddess.png',
    'assets/challenges_icons/parthenon.png',
    'assets/challenges_icons/triaina.png',
    'assets/challenges_icons/colona.png',
    'assets/challenges_icons/spartan.png',
    'assets/challenges_icons/lightning.png',
    'assets/challenges_icons/minoan.png',
  ];

  List<bool> revealedTiles = [];
  List<bool> matchedTiles = [];
  List<int> selectedTiles = [];
  int timer = 60; // Start time
  Timer? gameTimer;

  @override
  void initState() {
    super.initState();
    memoryIcons.shuffle(); // Shuffle icons for randomness
    revealedTiles = List<bool>.filled(memoryIcons.length, false);
    matchedTiles = List<bool>.filled(memoryIcons.length, false);
    startTimer();
  }

  void startTimer() {
    gameTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (this.timer > 0) {
        setState(() {
          this.timer--;
        });
      } else {
        gameTimer?.cancel();
        navigateToLoseScreen();
      }
    });
  }

  void handleTileTap(int index) {
    if (revealedTiles[index] ||
        matchedTiles[index] ||
        selectedTiles.length == 2) return;

    setState(() {
      revealedTiles[index] = true;
      selectedTiles.add(index);
    });

    if (selectedTiles.length == 2) {
      final firstIndex = selectedTiles[0];
      final secondIndex = selectedTiles[1];

      if (memoryIcons[firstIndex] == memoryIcons[secondIndex]) {
        // Tiles match
        setState(() {
          matchedTiles[firstIndex] = true;
          matchedTiles[secondIndex] = true;
          selectedTiles.clear();
        });

        if (matchedTiles.every((isMatched) => isMatched)) {
          gameTimer?.cancel();
          navigateToWinScreen();
        }
      } else {
        // Tiles don't match
        Future.delayed(const Duration(seconds: 1), () {
          setState(() {
            revealedTiles[firstIndex] = false;
            revealedTiles[secondIndex] = false;
            selectedTiles.clear();
          });
        });
      }
    }
  }

  void navigateToWinScreen() {
    // Fetch a coupon from the database
    FirebaseFirestore.instance
        .collection('Coupons')
        .get()
        .then((QuerySnapshot couponSnapshot) async {
      // Fetch user coupons to filter out already used ones
      final userCouponsSnapshot = await FirebaseFirestore.instance
          .collection('User_Coupons')
          .where('user_id', isEqualTo: widget.userId)
          .get();

      // Get a list of coupon IDs the user already has
      final userCouponIds =
          userCouponsSnapshot.docs.map((doc) => doc['coupon_id']).toSet();

      // Filter coupons that are not already used by the user
      final availableCoupons = couponSnapshot.docs.where((couponDoc) {
        return !userCouponIds.contains(couponDoc.id);
      }).toList();

      if (availableCoupons.isNotEmpty) {
        // Pick the first available coupon
        final selectedCoupon = availableCoupons.first;
        final couponData = selectedCoupon.data() as Map<String, dynamic>;

        // Navigate to the next screen with the selected coupon
        Navigator.pushReplacement(
          // ignore: use_build_context_synchronously
          context,
          MaterialPageRoute(
            builder: (context) => WinQuizScreen(
              screenName: 'MEMORY GAME',
              storeName: couponData['store_name'] ?? 'Unknown Store',
              code: couponData['code'] ?? 'NO-CODE',
            ),
          ),
        );

        // Optionally, add this coupon to User_Coupons collection
        FirebaseFirestore.instance.collection('User_Coupons').add({
          'user_id': widget.userId,
          'coupon_id': selectedCoupon.id,
        });
      } else {
        // No available coupons
        Navigator.pushReplacement(
          // ignore: use_build_context_synchronously
          context,
          MaterialPageRoute(
            builder: (context) => const WinNoMoreCoupons(
              screenName: 'MEMORY GAME',
            ),
          ),
        );
      }
    });
  }

  void navigateToLoseScreen() {
    Navigator.of(context).push(
      MaterialPageRoute(
          builder: (context) => const LoseQuizScreen(
                screenName: 'MEMORY GAME',
                livesText: 'LOOKS LIKE YOU RAN OUT\nOF TIME!',
              )),
    );
  }

  @override
  void dispose() {
    gameTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2EBD9),
      body: SafeArea(
        child: Column(
          children: [
            // Header Section (fixed)
            const QuizSectionHeader(
              title: 'MEMORY GAME',
              underlineWidth: 200,
              description:
                  'Tap the tiles to find the pairs before the time runs out:',
            ),
            const SizedBox(height: 16),

            // Scrollable Section (game grid + timer)
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    children: [
                      // Memory Game Grid - 4x4 tiles
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4, // 4 columns for a 4x4 grid
                          crossAxisSpacing: 10, // Horizontal spacing
                          mainAxisSpacing: 10, // Vertical spacing
                          childAspectRatio: 1, // Square tiles
                        ),
                        itemCount: memoryIcons.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () => handleTileTap(index),
                            child: MemoryGameTile(
                              iconPath: memoryIcons[index],
                              isRevealed:
                                  revealedTiles[index] || matchedTiles[index],
                            ),
                          );
                        },
                      ),
                      const SizedBox(
                          height: 30), // Space between grid and timer

                      // Timer Box
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 12),
                        decoration: BoxDecoration(
                          color:
                              const Color(0xFFD88D7F), // Timer background color
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(
                              'TIMER:',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'CaesarDressing',
                                color: Color(0xFF003366),
                              ),
                            ),
                            const SizedBox(width: 12),
                            CircleAvatar(
                              radius: 18,
                              backgroundColor: const Color(0xFFF2EBD9),
                              child: Text(
                                '$timer"',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF003366),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Navigation Buttons (fixed)
            const SizedBox(height: 8),
            const NavigationButtons(),
          ],
        ),
      ),
    );
  }
}

// Memory Game Tile Widget
class MemoryGameTile extends StatelessWidget {
  final String iconPath;
  final bool isRevealed;

  const MemoryGameTile({
    super.key,
    required this.iconPath,
    required this.isRevealed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isRevealed ? const Color(0xFF003366) : const Color(0xFF003366),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFF003366), width: 4),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 4,
          ),
        ],
      ),
      child: isRevealed
          ? Center(
              child: Image.asset(
                iconPath,
                width: 40,
                height: 40,
                fit: BoxFit.contain,
              ),
            )
          : null,
    );
  }
}
