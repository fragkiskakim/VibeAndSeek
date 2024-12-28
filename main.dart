import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'maps/main_map.dart';
import 'users_pages/visited_page.dart';

import 'users_pages/wishlist_screen.dart';
import 'users_pages/coupons_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Athens Attractions',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        scaffoldBackgroundColor: const Color(0xFFFAF7F2),
        fontFamily: 'Finlandica',
      ),
      home: const MainNavigator(),
    );
  }
}

class MainNavigator extends StatefulWidget {
  const MainNavigator({super.key});

  @override
  State<MainNavigator> createState() => _MainNavigatorState();
}

class _MainNavigatorState extends State<MainNavigator> {
  int _currentIndex = 0;
  final String userId = 'user3'; // Replace with actual user ID management

  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      const MapScreen(),
      VisitedLocationsScreen(userId: userId),
      WishlistScreen(userId: userId),
      CouponsScreen(userId: userId),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.transparent,
          elevation: 0,
          selectedItemColor: const Color(0xFF003366),
          unselectedItemColor: Colors.grey,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.map),
              label: 'Map',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.place),
              label: 'Visited',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite_border),
              label: 'Wishlist',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.local_offer),
              label: 'Coupons',
            ),
          ],
        ),
      ),
      // Add a FloatingActionButton for quick access to coupons
      floatingActionButton: _currentIndex == 0
          ? FloatingActionButton(
              onPressed: () {
                setState(() {
                  _currentIndex = 3; // Updated index for coupons tab
                });
              },
              backgroundColor: const Color(0xFF003366),
              child: const Icon(Icons.local_offer),
            )
          : null,
    );
  }
}
