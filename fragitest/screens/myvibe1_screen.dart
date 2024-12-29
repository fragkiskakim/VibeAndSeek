import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../widgets/pink_button.dart';
import '../widgets/header_1_line_no_back.dart';
import '../utils/global_state.dart';

class MyVibe1Screen extends StatefulWidget {
  const MyVibe1Screen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MyVibe1ScreenState createState() => _MyVibe1ScreenState();
}

class _MyVibe1ScreenState extends State<MyVibe1Screen> {
  final List<bool> isSelected = List.generate(12, (_) => false);
  String _message = ''; // Message to display (error)
  bool _isError = false; // Tracks if the message is an error

  Future<void> _savePreferences() async {
    final List<String> selectedPreferences = [];
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

    for (int i = 0; i < isSelected.length; i++) {
      if (isSelected[i]) {
        selectedPreferences.add(vibes[i]);
      }
    }

    if (selectedPreferences.isEmpty) {
      setState(() {
        _isError = true;
        _message = 'Please select at least one preference.';
      });
      return;
    }

    try {
      final userId = GlobalState().currentUserId;

      if (userId == null) {
        setState(() {
          _isError = true;
          _message = 'Error: User ID is null.';
        });
        return;
      }

      await FirebaseFirestore.instance.collection('User_Preferences').add({
        'user_id': userId,
        'preferences': selectedPreferences,
      });

      setState(() {
        _isError = false;
        _message = ''; // Clear the message on success
      });
      // ignore: use_build_context_synchronously
      Navigator.pushReplacementNamed(context, '/homepage');
    } catch (e) {
      setState(() {
        _isError = true;
        _message = 'An error occurred while saving preferences.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2EBD9),
      body: SafeArea(
        child: Column(
          children: [
            const Header1LineNoBack(
              title: 'MY VIBE',
              underlineWidth: 180,
            ),
            const SizedBox(height: 10),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
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
                                color: isSelected[index]
                                    ? const Color(0xFFD19348)
                                    : const Color(0xFF003366),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                vibes[index],
                                style: const TextStyle(
                                  color: Color(0xFFF2EBD9),
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Error/Success Message Display
                    if (_message.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              _isError
                                  ? Icons.error_outline
                                  : Icons.check_circle_outline,
                              color: _isError
                                  ? const Color(0xFFB85C5C)
                                  : const Color(0xFF2B9A50),
                              size: 24,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                _message,
                                style: TextStyle(
                                  color: _isError
                                      ? const Color(0xFFB85C5C)
                                      : const Color(0xFF2B9A50),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                    const SizedBox(height: 20),

                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20.0),
                      child: Center(
                        child: PinkButton(
                          buttonText: 'CONTINUE',
                          onPressed: _savePreferences,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
