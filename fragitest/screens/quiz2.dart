import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../widgets/header_1_line_descriptions.dart';
import '../widgets/bottom_nav_bar.dart';
import 'win1.dart';
import 'winnomorecoupons.dart';
import 'lose1.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../utils/global_state.dart';

class Quiz2Screen extends StatefulWidget {
  final String? userId = GlobalState().currentUserId;
  Quiz2Screen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _Quiz2ScreenState createState() => _Quiz2ScreenState();
}

class _Quiz2ScreenState extends State<Quiz2Screen> {
  int lives = 3;

// List of philosophers and their quotes
  List<Map<String, String>> philosophers = [
    {
      'name': 'Socrates',
      'quote': 'The unexamined life is not worth living.',
    },
    {
      'name': '  Plato   ',
      'quote': 'Do not spoil what you have by desiring what you have not.',
    },
    {
      'name': 'Epicurus',
      'quote': 'The only thing I know is that I know nothing.',
    },
    {
      'name': 'Aristotle',
      'quote': 'Happiness is the highest good.',
    },
  ];

  List<Map<String, String>> remainingQuotes = [
    {'quote': 'The unexamined life is not worth living.'},
    {'quote': 'Do not spoil what you have by desiring what you have not.'},
    {'quote': 'The only thing I know is that I know nothing.'},
    {'quote': 'Happiness is the highest good.'},
  ];

  void handleMatch(String quote, String philosopherName) {
    setState(() {
      final correct = philosophers.firstWhere(
        (philosopher) =>
            philosopher['name'] == philosopherName &&
            philosopher['quote'] == quote,
        orElse: () => <String, String>{},
      );

      if (correct.isNotEmpty) {
        philosophers.remove(correct);
        remainingQuotes.removeWhere((desc) => desc['quote'] == quote);

        if (philosophers.isEmpty) {
          // Fetch a coupon from the database
          FirebaseFirestore.instance
              .collection('Coupons')
              .get()
              .then((QuerySnapshot couponSnapshot) async {
            // Fetch user coupons to filter out already used ones
            final userCouponsDoc = await FirebaseFirestore.instance
                .collection('User_Coupons')
                .doc(widget.userId) // Get the user's document
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
              final couponData = selectedCoupon.data() as Map<String, dynamic>;

              // Navigate to the next screen with the selected coupon
              Navigator.pushReplacement(
                // ignore: use_build_context_synchronously
                context,
                MaterialPageRoute(
                  builder: (context) => WinQuizScreen(
                    screenName: 'FAMOUS QUOTES QUIZ',
                    storeName: couponData['store_name'] ?? 'Unknown Store',
                    code: couponData['code'] ?? 'NO-CODE',
                    discountpercentage:
                        (couponData['discount_percentage'] ?? 10).toString(),
                  ),
                ),
              );

              // Add the selected coupon to the user's document in User_Coupons collection
              FirebaseFirestore.instance
                  .collection('User_Coupons')
                  .doc(widget.userId)
                  .set(
                      {
                    DateTime.now().millisecondsSinceEpoch.toString(): {
                      'coupon_id': selectedCoupon.id,
                    },
                  },
                      SetOptions(
                          merge:
                              true)) // Merge to avoid overwriting existing coupons
                  .then((_) {
                if (kDebugMode) {
                  print("Coupon added successfully.");
                }
              }).catchError((error) {
                if (kDebugMode) {
                  print("Failed to add coupon: $error");
                }
              });
            } else {
              // No available coupons
              Navigator.pushReplacement(
                // ignore: use_build_context_synchronously
                context,
                MaterialPageRoute(
                  builder: (context) => const WinNoMoreCoupons(
                    screenName: 'FAMOUS QUOTES QUIZ',
                  ),
                ),
              );
            }
          });
        }
      } else {
        lives -= 1;
        if (lives == 0) {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => const LoseQuizScreen(
                        screenName: 'FAMOUS QUOTES QUIZ',
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
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                children: [
                  QuizSectionHeader(
                    title: 'FAMOUS QUOTES QUIZ',
                    underlineWidth: 220,
                    description:
                        'Drag the name of the Greek philosopher towards the correct quote:',
                  ),
                ],
              ),
            ),
            // Middle Section (Drag-and-Drop)
            Expanded(
              child: Row(
                children: [
                  // Philosophers list (Draggable)
                  Expanded(
                    child: ListView.builder(
                      itemCount: philosophers.length,
                      itemBuilder: (context, index) {
                        final philosopher = philosophers[index];
                        return Padding(
                          padding: const EdgeInsets.only(
                              left: 16.0,
                              bottom: 45.0), // Add left padding here
                          child: Align(
                            alignment: Alignment
                                .centerLeft, // Keeps the boxes aligned left
                            child: Draggable<Map<String, String>>(
                              data: philosopher,
                              feedback: Material(
                                color: Colors.transparent,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 8, horizontal: 16),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: const Color(0xFF003366),
                                        width: 2),
                                    borderRadius: BorderRadius.circular(8),
                                    color: const Color(0xFFF2EBD9),
                                  ),
                                  child: Text(
                                    philosopher['name']!,
                                    style: const TextStyle(
                                      fontFamily: 'Finlandica',
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF003366),
                                    ),
                                  ),
                                ),
                              ),
                              childWhenDragging:
                                  const SizedBox(), // Hide original when dragging
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 16),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: const Color(0xFF003366), width: 2),
                                  borderRadius: BorderRadius.circular(8),
                                  color: const Color(0xFFF2EBD9),
                                ),
                                child: Text(
                                  philosopher['name']!,
                                  style: const TextStyle(
                                    fontFamily: 'Finlandica',
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF003366),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  // Descriptions list (DragTarget) without box
                  Expanded(
                    child: ListView.builder(
                      itemCount: remainingQuotes.length,
                      itemBuilder: (context, index) {
                        final quote = remainingQuotes[index]['quote'];
                        return Padding(
                          padding: const EdgeInsets.only(
                              bottom: 35.0), // Increased bottom padding
                          child: DragTarget<Map<String, String>>(
                            // ignore: deprecated_member_use
                            onAccept: (data) {
                              handleMatch(quote!, data['name']!);
                            },
                            builder: (context, candidateData, rejectedData) {
                              return Text(
                                '"$quote"', // Add quotation marks around the quote
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontFamily: 'Finlandica',
                                  fontStyle:
                                      FontStyle.italic, // Make the text italic
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
