import 'package:flutter/material.dart';
import '../screens/homepage_screen.dart';
import '../screens/my_profile_screen.dart';
import '../maps/main_map.dart';

class NavigationButtons extends StatelessWidget {
  const NavigationButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
            icon: Image.asset(
              'assets/images/forum_icon.png',
              height: 30,
              width: 30,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const MyProfileScreen()),
              );
            },
          ),
          IconButton(
            icon: Image.asset(
              'assets/images/home_icon.png',
              height: 24,
              width: 24,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HomePageScreen()),
              );
            },
          ),
          IconButton(
            icon: Image.asset(
              'assets/images/maps_icon.png',
              height: 30,
              width: 30,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const MapScreen()),
              );
            },
          ),
        ],
      ),
    );
  }
}
