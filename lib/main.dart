import 'package:flutter/material.dart';
//import 'package:firebase_core/firebase_core.dart'; // Import this for Firebase initialization
import 'start_screen.dart';
import 'second_screen.dart';
import 'login_screen.dart';
import 'signup_screen.dart';
import 'myvibe1_screen.dart';

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
      },
    );
  }
}
