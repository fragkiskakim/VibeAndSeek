import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart';
import 'screens/start_screen.dart';
import 'screens/second_screen.dart';
import 'screens/login_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/myvibe1_screen.dart';
import 'screens/myvibe2_screen.dart';
import 'screens/homepage_screen.dart';
import 'screens/my_profile_screen.dart';
import 'screens/forum_screen.dart';
import 'screens/main_map.dart';
import 'screens/todaysvibe.dart';
import 'screens/challengesandgames.dart';
import 'screens/wishlist_screen.dart';
import 'screens/visited_page.dart';
import 'screens/coupons_screen.dart';

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
      title: 'Vibe and Seek Athens',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/', // Start from StartScreen
      routes: {
        '/': (context) => const StartScreen(), // Register StartScreen
        '/second': (context) => const SecondScreen(), // Register SecondScreen
        '/login': (context) => const LoginScreen(), // Register LoginScreen
        '/signup': (context) => const SignupScreen(), // Register SignupScreen
        '/myvibe1': (context) =>
            const MyVibe1Screen(), // Register MyVibe1Screen
        '/myvibe2': (context) =>
            const MyVibe2Screen(), // Register MyVibe2Screen
        '/homepage': (context) =>
            const HomePageScreen(), // Register HomePageScreen
        '/profile': (context) =>
            const MyProfileScreen(), // Register MyProfileScreen
        '/forum': (context) => const ForumScreen(), //Register ForumScreen
        '/maps': (context) => const MapScreen(), //Register MapsScreen
        '/todaysvibe': (context) => TodaysVibe(), //Register MapsScreen
        '/challengesandgames': (context) =>
            ChallengesAndGamesScreen(), //Register MapsScreen
        '/wishlist': (context) => WishlistScreen(),
        '/visited': (context) => VisitedLocationsScreen(),
        '/coupons': (context) => CouponsScreen(),
      },
    );
  }
}
