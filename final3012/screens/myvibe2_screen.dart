import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../utils/global_state.dart';
import '../widgets/pink_button.dart';
import '../widgets/header_1_line.dart';

class MyVibe2Screen extends StatefulWidget {
  const MyVibe2Screen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MyVibe2ScreenState createState() => _MyVibe2ScreenState();
}

class _MyVibe2ScreenState extends State<MyVibe2Screen> {
  final List<bool> isSelected = List.generate(12, (_) => false);
  final List<String> vibes = [
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
  String _message = ''; // Message to display (error/success)
  bool _isError = false; // Tracks if the message is an error

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    try {
      final userId = GlobalState().currentUserId;

      if (userId == null) {
        setState(() {
          _isError = true;
          _message = 'User ID is null.';
        });
        return;
      }

      final querySnapshot = await FirebaseFirestore.instance
          .collection('User_Preferences')
          .where('user_id', isEqualTo: userId)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final preferences =
            querySnapshot.docs[0]['preferences'] as List<dynamic>;

        setState(() {
          for (int i = 0; i < vibes.length; i++) {
            if (preferences.contains(vibes[i])) {
              isSelected[i] = true;
            }
          }
        });
      }
    } catch (e) {
      setState(() {
        _isError = true;
        _message = 'Error loading preferences: $e';
      });
    }
  }

  Future<void> _updatePreferences() async {
    final List<String> selectedPreferences = [];

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
          _message = 'User ID is null.';
        });
        return;
      }

      // Delete the old preferences for the user
      final querySnapshot = await FirebaseFirestore.instance
          .collection('User_Preferences')
          .where('user_id', isEqualTo: userId)
          .get();

      for (var doc in querySnapshot.docs) {
        await FirebaseFirestore.instance
            .collection('User_Preferences')
            .doc(doc.id)
            .delete();
      }

      // Add the new preferences
      await FirebaseFirestore.instance.collection('User_Preferences').add({
        'user_id': userId,
        'preferences': selectedPreferences,
      });

      setState(() {
        _isError = false;
        _message = 'Preferences updated successfully.';
      });
    } catch (e) {
      setState(() {
        _isError = true;
        _message = 'An error occurred while updating preferences: $e';
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
            const SimpleHeader(
              title: 'MY VIBE',
              underlineWidth: 180,
            ),
            const SizedBox(height: 35),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(5.0),
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
                        itemCount: vibes.length,
                        itemBuilder: (context, index) {
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
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          );
                        },
                      ),
                    ),

                    // Add spacing between the GridView and the message
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

                    // Add spacing between the message and the button
                    const SizedBox(height: 100),

                    Center(
                      child: PinkButton(
                        buttonText: 'SAVE CHANGES',
                        onPressed: _updatePreferences,
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
