import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../widgets/pink_button.dart';
import '../utils/global_state.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _retypePasswordController =
      TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  String _errorMessage = '';
  bool _obscurePassword = true; // Password visibility toggle
  bool _obscureRetypePassword = true; // Retype password visibility toggle

  Future<void> _signup() async {
    String username = _usernameController.text.trim();
    String password = _passwordController.text.trim();
    String retypePassword = _retypePasswordController.text.trim();
    String email = _emailController.text.trim();

    if (username.isEmpty ||
        password.isEmpty ||
        retypePassword.isEmpty ||
        email.isEmpty) {
      setState(() {
        _errorMessage = 'Please fill all fields.';
      });
      return;
    }

    if (password != retypePassword) {
      setState(() {
        _errorMessage = 'Passwords do not match.';
      });
      return;
    }

    try {
      // Check if the username already exists
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('Users')
          .where('username', isEqualTo: username)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        setState(() {
          _errorMessage = 'Username already exists.';
        });
        return;
      }

      // Create a new user document in Firestore
      DocumentReference userRef =
          await FirebaseFirestore.instance.collection('Users').add({
        'username': username,
        'password': password, // Consider hashing the password for security
        'email': email,
        'points': 0, // Initialize points to 0
      });

      // Store the new user's ID in GlobalState
      GlobalState().currentUserId = userRef.id;

      if (kDebugMode) {
        print('Signed up user ID: ${GlobalState().currentUserId}');
      }

      // Navigate to the next screen
      // ignore: use_build_context_synchronously
      Navigator.pushReplacementNamed(context, '/myvibe1');
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
                const SizedBox(height: 30),
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
                const SizedBox(height: 20),
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
                const SizedBox(height: 40),

                // Username Field
                const Text(
                  'Enter a Username:',
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
                    fillColor: const Color(0xFFD19348),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Password Field
                const Text(
                  'Enter a Password:',
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
                const SizedBox(height: 20),

                // Retype Password Field
                const Text(
                  'Retype your Password:',
                  style: TextStyle(
                    fontSize: 18,
                    fontFamily: 'Finlandica',
                    color: Color(0xFF003366),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _retypePasswordController,
                  obscureText: _obscureRetypePassword,
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
                        _obscureRetypePassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: const Color(0xFF003366),
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureRetypePassword = !_obscureRetypePassword;
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Email Field
                const Text(
                  'Enter your email:',
                  style: TextStyle(
                    fontSize: 18,
                    fontFamily: 'Finlandica',
                    color: Color(0xFF003366),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _emailController,
                  style: const TextStyle(color: Color(0xFF003366)),
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: const Color(0xFFD19348),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 50),

                // Error Message Display
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

                // Sign Up Button
                Center(
                  child: PinkButton(
                    buttonText: 'Sign Up',
                    onPressed: _signup,
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
