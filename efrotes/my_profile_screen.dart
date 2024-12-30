import 'package:flutter/material.dart';
import '../widgets/my_icon_profile.dart';
import '../widgets/my_profile_button.dart';
import '../widgets/toggle_item.dart';
import '../widgets/points_item.dart';
import '../widgets/bottom_nav_bar_efro.dart';

class MyProfileScreen extends StatefulWidget {
  const MyProfileScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MyProfileScreenState createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<MyProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2EBD9),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 35),
            const MyIconProfile(
              titlePart1: 'MY',
              titlePart2: 'PROFILE',
              iconPath: 'assets/images/my_profile_icon.png',
              underlinePath: 'assets/images/underline.png',
              underlineWidth: 180,
            ),
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  const SizedBox(height: 10),
                  CustomCard(
                    title: 'MY VIBE',
                    iconPath: 'assets/images/smile_icon.png',
                    onTap: () {
                      Navigator.pushNamed(context, '/myvibe2');
                    },
                  ),
                  CustomCard(
                    title: 'VISITED',
                    iconPath: 'assets/images/location_icon.png',
                    onTap: () {
                      Navigator.pushNamed(context, '/visited');
                    },
                  ),
                  CustomCard(
                    title: 'WISHLIST',
                    iconPath: 'assets/images/heart_icon.png',
                    onTap: () {
                      Navigator.pushNamed(context, '/wishlist');
                    },
                  ),
                  CustomCard(
                    title: 'MY COUPONS',
                    iconPath: 'assets/images/tickets_icon.png',
                    onTap: () {
                      Navigator.pushNamed(context, '/coupons');
                    },
                  ),
                  const CustomCard(
                    title: 'NOTIFICATIONS',
                    iconPath: 'assets/images/bell_icon.png',
                  ),
                  const ToggleItem(title: 'SOUND'),
                  const PointsItem(
                    title: 'POINTS: 120',
                    iconPath: 'assets/images/trophy_icon.png',
                  ),
                  // Added LOG OUT card
                  CustomCard(
                    title: 'LOG OUT',
                    iconPath:
                        'assets/images/logout_icon.png', // Add a suitable logout icon
                    onTap: () {
                      // Perform logout action
                      _logout(context);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const NavigationButtons(),
    );
  }

  // Logout function
  void _logout(BuildContext context) {
    // Clear user session or data if necessary
    // For now, simply navigate to the login screen
    Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
  }
}
