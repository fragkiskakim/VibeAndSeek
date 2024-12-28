import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:vibe_and_seek/firebase_options.dart';
import 'screens/start_screen.dart';
import 'screens/second_screen.dart';
import 'screens/login_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/myvibe1_screen.dart';
import 'screens/myvibe2_screen.dart';
import 'screens/homepage_screen.dart';
import 'screens/my_profile_screen.dart';
import 'screens/forum_screen.dart';
import 'screens/maps_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

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
        '/myvibe1': (context) => const MyVibe1Screen(), // Register MyVibe1Screen
        '/myvibe2': (context) => const MyVibe2Screen(), // Register MyVibe2Screen
        '/homepage': (context) => HomePageScreen(), // Register HomePageScreen
        '/profile': (context) => const MyProfileScreen(), // Register MyProfileScreen
        '/forum': (context) => ForumScreen(), //Register ForumScreen
        '/maps': (context) => const MapsScreen(), //Register MapsScreen
      },
    );
  }
}