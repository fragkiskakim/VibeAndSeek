import 'package:flutter/material.dart';
import '../widgets/bottom_nav_bar.dart';
import '../widgets/header_1_line_descriptions.dart';
import 'win1.dart';
import 'winnomorecoupons.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../utils/global_state.dart';

class Quiz4Screen extends StatefulWidget {
  final String? userId = GlobalState().currentUserId;
  Quiz4Screen({super.key});

  @override
  State<Quiz4Screen> createState() => _Quiz4ScreenState();
}

class _Quiz4ScreenState extends State<Quiz4Screen> {
  // Crossword grid with some letters initially revealed, and null for hidden cells
  final List<List<String?>> crosswordGrid = [
    [null, null, null, null, null, null, null, null, null, null, null],
    ['O', null, null, null, 'E', null, null, null, null, null, null],
    [null, null, null, null, null, null, null, null, null, null, null],
    [null, null, 'S', null, 'A', null, null, 'A', null, null, null],
    [null, null, null, null, null, null, null, null, null, null, null],
    [null, null, null, null, null, null, null, null, null, null, null],
    [null, null, null, null, null, null, null, null, null, null, null],
    [null, null, 'A', null, null, null, null, null, null, null, null],
    [null, null, null, null, null, null, null, null, null, null, null],
    [null, null, null, null, null, null, null, null, null, null, null],
    [null, null, null, null, null, null, null, null, null, null, null],
  ];

  // Metadata grid that determines cell colors before completion
  final List<List<bool>> highlightedGrid = [
    [true, false, false, false, true, true, true, true, true, true, false],
    [true, true, true, true, true, false, false, false, false, false, false],
    [true, false, false, false, true, false, false, false, false, false, false],
    [true, false, true, true, true, true, true, true, false, false, false],
    [true, false, true, false, false, false, false, true, false, false, false],
    [false, false, true, false, false, false, false, true, false, false, false],
    [
      false,
      false,
      true,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false
    ],
    [false, false, true, true, true, true, true, true, true, true, true],
    [
      false,
      false,
      true,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false
    ],
    [
      false,
      false,
      true,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false
    ],
    [
      false,
      false,
      true,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false
    ],
  ];

  // Words metadata
  final List<Map<String, dynamic>> words = [
    {
      'direction': 'across',
      'row': 0,
      'colStart': 4,
      'length': 6,
      'answer': 'HELLAS',
    },
    {
      'direction': 'across',
      'row': 1,
      'colStart': 0,
      'length': 5,
      'answer': 'OLIVE'
    },
    {
      'direction': 'down',
      'col': 2,
      'rowStart': 3,
      'length': 8,
      'answer': 'SOCRATES'
    },
    {
      'direction': 'down',
      'col': 0,
      'rowStart': 0,
      'length': 5,
      'answer': 'HOMER'
    },
    {
      'direction': 'down',
      'col': 4,
      'rowStart': 0,
      'length': 4,
      'answer': 'HERA'
    },
    {
      'direction': 'down',
      'col': 7,
      'rowStart': 3,
      'length': 3,
      'answer': 'ART'
    },
    {
      'direction': 'across',
      'row': 3,
      'colStart': 2,
      'length': 6,
      'answer': 'SPARTA'
    },
    {
      'direction': 'across',
      'row': 7,
      'colStart': 2,
      'length': 9,
      'answer': 'ACROPOLIS'
    },
  ];
  // Track completed words
  final List<bool> wordCompletionStatus = [];

// Initialize completion status for all words in initState
  @override
  void initState() {
    super.initState();
    wordCompletionStatus.addAll(List<bool>.filled(words.length, false));
  }

  // Reveal word when it is correctly guessed
  void revealWord(Map<String, dynamic> word) {
    int wordIndex = words.indexOf(word);

    // Check if the word is already completed
    if (wordIndex != -1 && wordCompletionStatus[wordIndex]) {
      return; // If already completed, do nothing
    }
    setState(() {
      if (word['direction'] == 'across') {
        int row = word['row'];
        for (int i = 0; i < word['length']; i++) {
          crosswordGrid[row][word['colStart'] + i] = word['answer'][i];
        }
      } else if (word['direction'] == 'down') {
        int col = word['col'];
        for (int i = 0; i < word['length']; i++) {
          crosswordGrid[word['rowStart'] + i][col] = word['answer'][i];
        }
      }
      // Mark word as completed
      if (wordIndex != -1) {
        wordCompletionStatus[wordIndex] = true;
      }

      // Check if all words are completed
      if (wordCompletionStatus.every((status) => status)) {
        navigateToWinScreen();
      }
    });
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
              screenName: 'GREEK CROSSWORD',
              storeName: couponData['store_name'] ?? 'Unknown Store',
              code: couponData['code'] ?? 'NO-CODE',
              discountpercentage: couponData['discount_percentage'] ?? '10',
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
              screenName: 'GREEK CROSSWORD',
            ),
          ),
        );
      }
    });
  }

  // Prompt user to complete a word
  void showWordInputDialog(BuildContext context, Map<String, dynamic> word) {
    String userInput = '';
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor:
              const Color(0xFFF2EBD9), // Set the background color of the box
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0), // Rounded corners
            side: const BorderSide(
              color: Color(0xFF003366), // Border color
              width: 2.0,
            ),
          ),
          title: const Text(
            'Enter your word',
            style: TextStyle(
              fontFamily: 'Finlandica',
              fontSize: 20,
              color: Color(0xFF003366), // Title color
            ),
          ),
          content: TextField(
            onChanged: (value) {
              userInput = value.toUpperCase();
            },
            style: const TextStyle(
              fontFamily: 'Finlandica',
              color: Color(0xFF003366), // Input text color
            ),
            decoration: const InputDecoration(
              hintText: 'Type your word here...',
              hintStyle: TextStyle(
                fontFamily: 'Finlandica',
                color: Color(0xFF7A7A7A), // Hint text color
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                if (userInput == word['answer']) {
                  revealWord(word);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Correct!',
                        style: TextStyle(
                          fontFamily: 'Finlandica',
                          color: Colors.white, // SnackBar text color
                        ),
                      ),
                      backgroundColor:
                          Color(0xFF28A745), // SnackBar background color
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Try Again!',
                        style: TextStyle(
                          fontFamily: 'Finlandica',
                          color: Colors.white, // SnackBar text color
                        ),
                      ),
                      backgroundColor:
                          Color(0xFFD88D7F), // SnackBar background color
                    ),
                  );
                }
              },
              style: TextButton.styleFrom(
                backgroundColor:
                    const Color(0xFF003366), // Submit button background color
                foregroundColor:
                    const Color(0xFFF2EBD9), // Submit button text color
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              child: const Text(
                'Submit',
                style: TextStyle(
                  fontFamily: 'Finlandica',
                  fontSize: 16,
                ),
              ),
            ),
          ],
        );
      },
    );
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
              title: 'GREEK CROSSWORD',
              underlineWidth: 200,
              description: 'Complete the crossword about Greek culture:',
            ),
            const SizedBox(height: 16),

            // Scrollable Section (crossword + descriptions)
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0), // Add horizontal padding
                      child: CrosswordGrid(
                        crosswordGrid: crosswordGrid,
                        highlightedGrid: highlightedGrid,
                        words: words,
                        onWordTap: showWordInputDialog,
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Descriptions
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Down Clues
                          Text(
                            'Down',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'CaesarDressing',
                              color: Color(0xFF003366),
                            ),
                          ),
                          SizedBox(height: 12),
                          Text(
                            '1. Author of the Iliad and Odyssey.',
                            style: TextStyle(
                              fontSize: 16,
                              fontFamily: 'Finlandica',
                              color: Color(0xFF003366),
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            '2. Famous philosopher known for his method of questioning.',
                            style: TextStyle(
                              fontSize: 16,
                              fontFamily: 'Finlandica',
                              color: Color(0xFF003366),
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            '3. Goddess and wife of Zeus.',
                            style: TextStyle(
                              fontSize: 16,
                              fontFamily: 'Finlandica',
                              color: Color(0xFF003366),
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            '4. Highly valued in Greek culture, from pottery to sculpture.',
                            style: TextStyle(
                              fontSize: 16,
                              fontFamily: 'Finlandica',
                              color: Color(0xFF003366),
                            ),
                          ),
                          SizedBox(height: 24),

                          // Across Clues
                          Text(
                            'Across',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'CaesarDressing',
                              color: Color(0xFF003366),
                            ),
                          ),
                          SizedBox(height: 12),
                          Text(
                            '1. The Greek word for Greece.',
                            style: TextStyle(
                              fontSize: 16,
                              fontFamily: 'Finlandica',
                              color: Color(0xFF003366),
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            '2. Symbol of peace and prosperity.',
                            style: TextStyle(
                              fontSize: 16,
                              fontFamily: 'Finlandica',
                              color: Color(0xFF003366),
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            '3. Greek city-state known for its warriors.',
                            style: TextStyle(
                              fontSize: 16,
                              fontFamily: 'Finlandica',
                              color: Color(0xFF003366),
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            '4. Ancient citadel of Athens, home to the Parthenon.',
                            style: TextStyle(
                              fontSize: 16,
                              fontFamily: 'Finlandica',
                              color: Color(0xFF003366),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
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

class CrosswordGrid extends StatelessWidget {
  final List<List<String?>> crosswordGrid;
  final List<List<bool>> highlightedGrid;
  final List<Map<String, dynamic>> words;
  final Function(BuildContext, Map<String, dynamic>) onWordTap;

  const CrosswordGrid({
    super.key,
    required this.crosswordGrid,
    required this.highlightedGrid,
    required this.words,
    required this.onWordTap,
  });

  @override
  Widget build(BuildContext context) {
    double cellSize = MediaQuery.of(context).size.width / 12;

    return GridView.builder(
      shrinkWrap: true, // Allow GridView to size itself dynamically
      physics:
          const NeverScrollableScrollPhysics(), // Disable internal scrolling
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 11, // 11 columns
        crossAxisSpacing: 2,
        mainAxisSpacing: 2,
        childAspectRatio: 1, // Ensure square cells
      ),
      itemCount: 11 * 11, // 11 x 11 grid
      itemBuilder: (context, index) {
        int row = index ~/ 11;
        int col = index % 11;
        String? cellValue = crosswordGrid[row][col];
        bool isHighlighted = highlightedGrid[row][col];

        return GestureDetector(
          onTap: () {
            for (var word in words) {
              if (word['direction'] == 'across' &&
                  word['row'] == row &&
                  word['colStart'] <= col &&
                  col < word['colStart'] + word['length']) {
                onWordTap(context, word);
                break;
              } else if (word['direction'] == 'down' &&
                  word['col'] == col &&
                  word['rowStart'] <= row &&
                  row < word['rowStart'] + word['length']) {
                onWordTap(context, word);
                break;
              }
            }
          },
          child: SizedBox(
            width: cellSize,
            height: cellSize,
            child: CrosswordCell(
              value: cellValue,
              isEditable: cellValue == null,
              isHighlighted: isHighlighted,
            ),
          ),
        );
      },
    );
  }
}

class CrosswordCell extends StatelessWidget {
  final String? value;
  final bool isEditable;
  final bool isHighlighted;

  const CrosswordCell({
    super.key,
    required this.value,
    required this.isEditable,
    required this.isHighlighted,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: value != null
            ? const Color(0xFFD88D7F)
            : isHighlighted
                ? const Color(0xFFD88D7F) // Highlight color
                : const Color(0xFFF2EBD9),
        border: Border.all(
          color:
              isHighlighted ? const Color(0xFF003366) : const Color(0xFFF2EBD9),
          width: 1.5,
        ),
      ),
      alignment: Alignment.center,
      child: Text(
        value ?? '',
        style: TextStyle(
          fontFamily: 'CaesarDressing',
          fontSize: 18,
          color: isEditable ? Colors.grey : const Color(0xFF003366),
        ),
      ),
    );
  }
}
