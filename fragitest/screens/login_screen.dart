import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../widgets/pink_button.dart';
import '../utils/global_state.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _obscurePassword = true;
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _errorMessage = '';

  Future<void> _login() async {
    String username = _usernameController.text.trim(); // Trim spaces
    String password = _passwordController.text.trim(); // Trim spaces

    if (username.isEmpty || password.isEmpty) {
      setState(() {
        _errorMessage = 'Please enter both username and password.';
      });
      return;
    }

    try {
      // Query Firestore for the username
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('Users') // Matches the Firestore collection name
          .where('username', isEqualTo: username) // Query for the username
          .get();

      if (querySnapshot.docs.isEmpty) {
        setState(() {
          _errorMessage = 'Username not found.';
        });
        return;
      }

      String storedPassword =
          querySnapshot.docs[0]['password']; // Get password from Firestore

      if (password == storedPassword) {
        // Store the user's ID globally
        GlobalState().currentUserId = querySnapshot.docs[0].id;

        if (kDebugMode) {
          print('Logged in user ID: ${GlobalState().currentUserId}');
        }

        // Navigate to the next screen
        // ignore: use_build_context_synchronously
        Navigator.pushReplacementNamed(context, '/homepage');
      } else {
        setState(() {
          _errorMessage = 'Incorrect password.';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'An error occurred: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2EBD9), // Beige background
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const SizedBox(height: 50), // Space at the top
                const Center(
                  child: Text(
                    'VIBE AND SEEK\nATHENS',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 50,
                      fontFamily: 'CaesarDressing',
                      color: Color(0xFF003366),
                    ),
                  ),
                ),
                const SizedBox(height: 20), // Space below the title
                const Center(
                  child: Text(
                    'Experience Athens your way.\nFind the vibe that expresses you!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                      fontFamily: 'Finlandica',
                      color: Color(0xFF003366),
                    ),
                  ),
                ),
                const SizedBox(height: 40), // Space below the subtitle
                const Text(
                  'Username',
                  style: TextStyle(
                    fontSize: 18,
                    fontFamily: 'Finlandica',
                    color: Color(0xFF003366),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _usernameController,
                  style: const TextStyle(color: Color(0xFF003366)),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor:
                        const Color(0xFFD19348), // Orange input background
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Password',
                  style: TextStyle(
                    fontSize: 18,
                    fontFamily: 'Finlandica',
                    color: Color(0xFF003366),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  style: const TextStyle(color: Color(0xFF003366)),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: const Color(0xFFD19348),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide.none,
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: const Color(0xFF003366),
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 30),

                // Error message display
                if (_errorMessage.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 5, bottom: 20),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(
                          'assets/images/error.png',
                          width: 24,
                          height: 24,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            _errorMessage,
                            style: const TextStyle(
                              color: Color(0xFFB85C5C),
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                Center(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/signup');
                    },
                    child: RichText(
                      text: const TextSpan(
                        text: "Don't have an account? ",
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'Finlandica',
                          color: Color(0xFF003366),
                        ),
                        children: [
                          TextSpan(
                            text: 'SIGN UP',
                            style: TextStyle(
                              color: Color(0xFFD88D7F),
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 50), // Added space before the button

                // Log In Button
                Align(
                  alignment: Alignment.bottomRight,
                  child: PinkButton(
                    buttonText: 'Log In',
                    onPressed: _login, // Call the login function
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
