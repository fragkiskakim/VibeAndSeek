import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../widgets/bottom_nav_bar.dart';
import '../widgets/header_1_line.dart';
import 'test.dart';
import '../utils/global_state.dart';

const String _apiKey = "AIzaSyDuGXbPpQ9fqKEpzN5vOK_zmA7g-83jZPY";

class TodaysVibe extends StatefulWidget {
  final String? userId = GlobalState().currentUserId;

  TodaysVibe({super.key});

  @override
  State<TodaysVibe> createState() => _TodaysVibeState();
}

class _TodaysVibeState extends State<TodaysVibe> {
  List<Map<String, dynamic>> wishlistSuggestions = [];
  List<Map<String, dynamic>> personalizedSuggestions = [];
  List<String> selectedWishlistLocations = [];
  List<String> selectedPersonalizedLocations = [];

  @override
  void initState() {
    super.initState();
    _loadWishlistSuggestions();
    _loadPersonalizedSuggestions();
  }

  Future<void> _loadWishlistSuggestions() async {
    try {
      // Fetch the specific user's wishlist document
      final wishlistDoc = await FirebaseFirestore.instance
          .collection('User_Wishlist')
          .doc(widget.userId)
          .get();

      // Ensure the document exists and has data
      if (!wishlistDoc.exists || wishlistDoc.data() == null) return;

      // Extract all location IDs from the document
      final wishlistData = wishlistDoc.data()!;
      final locationIds = wishlistData.values
          .where((value) => value is Map && value.containsKey('location_id'))
          .map((value) => value['location_id'].toString())
          .toList();

      // Fetch location details for all IDs in parallel
      final wishlistPlaces =
          await Future.wait(locationIds.map((locationId) async {
        final locationSnapshot = await FirebaseFirestore.instance
            .collection('Locations')
            .doc(locationId)
            .get();

        if (locationSnapshot.exists) {
          return {
            'title': locationSnapshot['name'],
            'isChecked': false,
            'id': locationId,
          };
        }
        return null;
      }));

      // Filter out null results and shuffle the suggestions
      final validPlaces =
          wishlistPlaces.where((place) => place != null).toList();
      validPlaces.shuffle();

      // Update state with the top 5 suggestions
      setState(() {
        wishlistSuggestions =
            validPlaces.take(5).toList().cast<Map<String, dynamic>>();
      });
    } catch (e) {
      if (kDebugMode) {
        print('Error loading wishlist suggestions: $e');
      }
    }
  }

  Future<void> _loadPersonalizedSuggestions() async {
    try {
      final userPreferencesSnapshot = await FirebaseFirestore.instance
          .collection('User_Preferences')
          .where('user_id', isEqualTo: widget.userId)
          .get();

      if (userPreferencesSnapshot.docs.isNotEmpty) {
        final userPreferences = List<String>.from(
            userPreferencesSnapshot.docs.first['preferences']);

        final locationsSnapshot = await FirebaseFirestore.instance
            .collection('Locations')
            .where('preferences', arrayContainsAny: userPreferences)
            .get();

        final personalizedPlaces = locationsSnapshot.docs.map((doc) {
          return {
            'title': doc['name'],
            'isChecked': false,
            'id': doc.id,
          };
        }).toList();

        personalizedPlaces.shuffle();

        setState(() {
          personalizedSuggestions = personalizedPlaces.take(5).toList();
        });
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error loading personalized suggestions: $e');
      }
    }
  }

  Future<void> _showChatGPTPopup() async {
    final List<String> selectedLocations = [
      ...selectedWishlistLocations,
      ...selectedPersonalizedLocations,
    ];
    final defaultPrompt = selectedLocations.isEmpty
        ? "Tell me the best ways to visit all of these places today."
        : "Tell me the best ways to visit these places today: ${selectedLocations.join(', ')}";

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: SizedBox(
            width:
                MediaQuery.of(context).size.width * 0.95, // 95% of screen width
            height: MediaQuery.of(context).size.height *
                0.95, // 80% of screen height
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Color(0xFFF2EBD9),
                borderRadius: BorderRadius.all(Radius.circular(16)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.max, // Occupy maximum height
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'ChatGPT:',
                        style: TextStyle(
                          fontFamily: 'Finlandica',
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF003366),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        color: const Color(0xFF003366),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // ChatWidget with default prompt
                  Expanded(
                    child: ChatWidget(
                      apiKey: _apiKey, // Use your API key variable
                      initialPrompt: defaultPrompt,
                    ),
                  ),
                ],
              ),
            ),
          ),
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
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Top Section
            const SimpleHeader(title: 'TODAY\'S VIBE', underlineWidth: 180),

            const SizedBox(height: 16),

            // Suggestions Section
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Flexible(
                          child: Text(
                            'Select which Personalized or Wishlist suggestions you want to include in your schedule today! \nAsk ChatGPT about the best way to visit them!',
                            style: TextStyle(
                              fontFamily: 'Finlandica',
                              fontSize: 16,
                              color: Color(0xFF003366),
                            ),
                            textAlign:
                                TextAlign.center, // Optional: Centers the text
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    // Suggestions from Wishlist
                    Row(
                      children: [
                        Image.asset(
                          'assets/challenges_icons/wishlist_suggestions.png', // Ensure this path is correct
                          height: 24, // Adjust height as needed
                          width: 24, // Adjust width as needed
                        ),
                        const SizedBox(
                          width: 8, // Add spacing between the icon and the text
                        ),
                        const Text(
                          'Suggestions from your Wishlist',
                          style: TextStyle(
                            fontFamily: 'Finlandica',
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF003366),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),
                    ...wishlistSuggestions.map((item) => _buildSuggestionItem(
                            item['title'], item['isChecked'], () {
                          setState(() {
                            item['isChecked'] = !item['isChecked'];
                            if (item['isChecked']) {
                              selectedWishlistLocations.add(item['title']);
                            } else {
                              selectedWishlistLocations.remove(item['title']);
                            }
                          });
                        })),
                    const SizedBox(height: 16),

                    // Personalized Suggestions
                    Row(
                      children: [
                        Image.asset(
                          'assets/challenges_icons/personalized_suggestions.png', // Ensure this path is correct
                          height: 24, // Adjust height as needed
                          width: 24, // Adjust width as needed
                        ),
                        const SizedBox(
                          width: 8, // Add spacing between the icon and the text
                        ),
                        const Text(
                          'Personalized Suggestions',
                          style: TextStyle(
                            fontFamily: 'Finlandica',
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF003366),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),
                    ...personalizedSuggestions.map((item) =>
                        _buildSuggestionItem(item['title'], item['isChecked'],
                            () {
                          setState(() {
                            item['isChecked'] = !item['isChecked'];
                            if (item['isChecked']) {
                              selectedPersonalizedLocations.add(item['title']);
                            } else {
                              selectedPersonalizedLocations
                                  .remove(item['title']);
                            }
                          });
                        })),
                  ],
                ),
              ),
            ),

            // "Ask ChatGPT" Button
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: GestureDetector(
                onTap: _showChatGPTPopup,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 32),
                  decoration: BoxDecoration(
                    color: const Color(0xFF003366),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    'Ask ChatGPT',
                    style: TextStyle(
                      fontFamily: 'Finlandica',
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),

            // Navigation Buttons Section
            const NavigationButtons(),
          ],
        ),
      ),
    );
  }

  // Widget to build individual suggestion items
  Widget _buildSuggestionItem(
      String title, bool isChecked, VoidCallback onTap) {
    return Column(
      children: [
        const SizedBox(height: 3),
        Row(
          children: [
            GestureDetector(
              onTap: onTap, // Trigger the onTap function to toggle the checkbox
              child: Image.asset(
                isChecked
                    ? 'assets/challenges_icons/checked.png'
                    : 'assets/challenges_icons/unchecked.png',
                height: 24, // Adjust the height as needed
                width: 24, // Adjust the width as needed
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontFamily: 'Finlandica',
                  fontSize: 16,
                  color: Color(0xFF003366),
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        )
      ],
    );
  }
}
