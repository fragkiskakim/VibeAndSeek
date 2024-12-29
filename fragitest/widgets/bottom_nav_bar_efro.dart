import 'package:flutter/material.dart';

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
              Navigator.pushNamed(context, '/forum');
            },
          ),
          IconButton(
            icon: Image.asset(
              'assets/images/home_icon.png',
              height: 24,
              width: 24,
            ),
            onPressed: () {
              Navigator.pushNamed(context, '/homepage');
            },
          ),
          IconButton(
            icon: Image.asset(
              'assets/images/maps_icon.png',
              height: 30,
              width: 30,
            ),
            onPressed: () {
              Navigator.pushNamed(context, '/maps');
            },
          ),
        ],
      ),
    );
  }
}
