import 'package:flutter/material.dart';
//import 'package:firebase_core/firebase_core.dart'; // Import this for Firebase initialization
import 'screens/start_screen.dart';
import 'screens/second_screen.dart';
import 'screens/login_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/myvibe1_screen.dart';
import 'screens/homepage_screen.dart';
import 'screens/my_profile_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensure Flutter is initialized
  //await Firebase.initializeApp(); // Initialize Firebase

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

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
        '/myvibe': (context) => const MyVibe1Screen(), // Register MyVibeScreen
        '/homepage': (context) => HomePageScreen(), //Register HomePageScreen
        '/profile': (context) => const MyProfileScreen(), // Register MyProfileScreen
      },
    );
  }
}
