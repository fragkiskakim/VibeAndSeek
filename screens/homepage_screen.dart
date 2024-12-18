import 'package:flutter/material.dart';

class HomePageScreen extends StatefulWidget {
  @override
  _HomePageScreenState createState() => _HomePageScreenState();
}

class _HomePageScreenState extends State<HomePageScreen> {
  int _currentIndex = 0; // Track the selected bottom navigation index

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2EBD9),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // Title section
            Center(
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: const Text(
                  'VIBE AND SEEK\n ATHENS',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'CaesarDressing',
                    color: Color(0xFF003366) // Adjust color as needed
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            const SizedBox(height: 50), // Space after title
            // Buttons for different sections
            _buildIconButton('assets/images/profile_icon.png', 'My Profile', () {
              Navigator.pushNamed(context, '/profile');
            }),
            const SizedBox(height: 20),
            _buildIconButton('assets/images/faces_icon.png', "Today's Vibe", () {
              // TODO: Add navigation for "Today's Vibe" button
            }),
            const SizedBox(height: 20),
            _buildIconButton('assets/images/games_icon.png', 'Challenges and \nGames', () {
              // TODO: Add navigation for "Challenges and Games" button
            }),
            const SizedBox(height: 40), // Space before icons row
            // Flexible icons
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  child: _buildIcon('assets/images/human_1_icon.png', 140),
                ),
                const SizedBox(width: 20),
                Flexible(
                  child: _buildIcon('assets/images/human_2_icon.png', 140),
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: const Color(0xFF003366),
        unselectedItemColor: const Color(0xFF003366),
        items: const [
          BottomNavigationBarItem(
            icon: ImageIcon(
              AssetImage('assets/images/forum_icon.png'),
              size: 30,
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(
              AssetImage('assets/images/home_icon.png'),
              size: 27,
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(
              AssetImage('assets/images/maps_icon.png'),
              size: 35,
            ),
            label: '',
          ),
        ],
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
          // TODO: Add navigation for bottom navigation items
        },
        backgroundColor: const Color(0xFFF2EBD9), // Background color of the bottom nav
        elevation: 5, // Elevation for a more distinct separation
      ),
    );
  }
}

Widget _buildIconButton(String assetPath, String label, VoidCallback onTap) {
  return Container(
    margin: const EdgeInsets.symmetric(vertical: 10), // Vertical space between buttons
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16), // Make button taller
    decoration: BoxDecoration(
      color: const Color(0xFF003366),
      borderRadius: BorderRadius.circular(12),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          blurRadius: 8,
          offset: const Offset(0, 4),
        ),
      ],
    ),
    child: InkWell(
      onTap: onTap,
      child: Row(
        mainAxisSize: MainAxisSize.max, // Ensure button stretches across the available width
        mainAxisAlignment: MainAxisAlignment.center, // Center content horizontally
        children: [
          Image.asset(
            assetPath,
            width: 40, // Icon size
            height: 40,
          ),
          const SizedBox(width: 4), // Small space between icon and text
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                color: Color(0xFFD88D7F),
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    ),
  );
}



Widget _buildIcon(String assetPath, double size) {
  return GestureDetector(
    onTap: () {
      // TODO: Add navigation for this icon
    },
    child: Image.asset(
      assetPath,
      width: size,
      height: size,
    ),
  );
}

