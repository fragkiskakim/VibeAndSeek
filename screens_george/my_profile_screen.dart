import 'package:flutter/material.dart';

class MyProfileScreen extends StatefulWidget {
  const MyProfileScreen({Key? key}) : super(key: key);

  @override
  _MyProfileScreenState createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<MyProfileScreen> {
  int _currentIndex = 1; // Set "Home" as the default tab

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2EBD9),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Custom "MY PROFILE" title with underline
            const SizedBox(height: 40),
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'MY',
                  style: TextStyle(
                    fontSize: 45,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'CaesarDressing',
                    color: Color(0xFF003366),
                  ),
                ),
                SizedBox(
                    width: 5), // Adjust spacing between text and icon
                Image(
                  image: AssetImage('assets/images/my_profile_icon.png'),
                  width: 45, // Adjust icon size
                  height: 45,
                  fit: BoxFit.contain,
                ),
                SizedBox(
                    width: 5), // Adjust spacing between icon and text
                Text(
                  'PROFILE',
                  style: TextStyle(
                    fontSize: 45,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'CaesarDressing',
                    color: Color(0xFF003366),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 1),
            Image.asset(
              'assets/images/underline.png',
              width: 300, // Adjust the width as needed
              height: 20, // Adjust the height as needed
            ),
            const SizedBox(height: 20), // Spacing after the title

            // Profile content
            Expanded(
              child: ListView(
                children: [
                  const SizedBox(height: 10),
                  _buildMenuItem('MY VIBE', 'assets/images/smile_icon.png'),
                  _buildMenuItem('VISITED', 'assets/images/location_icon.png'),
                  _buildMenuItem('WISHLIST', 'assets/images/heart_icon.png'),
                  _buildMenuItem('MY COUPONS', 'assets/images/tickets_icon.png'),
                  _buildMenuItem('NOTIFICATIONS', 'assets/images/bell_icon.png'),
                  _buildToggleItem('SOUND'),
                  _buildPointsItem('POINTS: 5', 'assets/images/trophy_icon.png'),
                ],
              ),
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
          // TODO: Add navigation logic
        },
        backgroundColor: const Color(0xFFF2EBD9),
        elevation: 5,
      ),
    );
  }

  Widget _buildMenuItem(String title, String iconPath) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF003366), width: 2),
      ),
      child: Row(
        children: [
          Image.asset(iconPath, width: 28, height: 28),
          const SizedBox(width: 16),
          Text(
            title,
            style: const TextStyle(
              fontFamily: "CaesarDressing",
              color: Color(0xFF003366),
              fontWeight: FontWeight.bold,
              fontSize: 25,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToggleItem(String title) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF003366), width: 2),
      ),
      child: Row(
        children: [
          Transform.scale(
            scale: 0.7, // Make the Switch smaller
            child: Switch(
              value: true, // Default ON
              onChanged: (value) {
                setState(() {
                  // Handle toggle logic
                });
              },
              activeColor: const Color(0xFF003366),
            ),
          ),
          const SizedBox(width: 10),
          Text(
            title,
            style: const TextStyle(
              fontFamily: "CaesarDressing",
              color: Color(0xFF003366),
              fontWeight: FontWeight.bold,
              fontSize: 25,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPointsItem(String title, String iconPath) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF003366), width: 2),
      ),
      child: Row(
        children: [
          Image.asset(iconPath, width: 28, height: 28),
          const SizedBox(width: 16),
          Text(
            title,
            style: const TextStyle(
              fontFamily: "CaesarDressing",
              color: Color(0xFF003366),
              fontWeight: FontWeight.bold,
              fontSize: 25,
            ),
          ),
        ],
      ),
    );
  }
}
