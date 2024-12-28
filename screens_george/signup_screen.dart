import 'package:flutter/material.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  bool _obscurePassword = true; // To toggle password visibility

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2EBD9), // Custom beige color
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: 50), // Space at the top
            // Main title
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
            // Subtitle
            const Center(
              child: Text(
                'Experience the Athens that suits you\nFind the vibe that expresses you!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22,
                  fontFamily: 'Finlandica',
                  color: Color(0xFF003366),
                ),
              ),
            ),
            const SizedBox(height: 50), // Space below the subtitle
            // Username field
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
              style: const TextStyle(
                color: Color(0xFF003366), // Blue text color
              ),
              decoration: InputDecoration(
                filled: true,
                fillColor: const Color(0xFFD19348), // Orange background
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20), // Rounded corners
                  borderSide: BorderSide.none, // Remove border outline
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Email field
            const Text(
              'Email',
              style: TextStyle(
                fontSize: 18,
                fontFamily: 'Finlandica',
                color: Color(0xFF003366),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              style: const TextStyle(
                color: Color(0xFF003366), // Blue text color
              ),
              decoration: InputDecoration(
                filled: true,
                fillColor: const Color(0xFFD19348), // Orange background
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20), // Rounded corners
                  borderSide: BorderSide.none, // Remove border outline
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Password field
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
              obscureText: _obscurePassword,
              style: const TextStyle(
                color: Color(0xFF003366), // Blue text color
              ),
              decoration: InputDecoration(
                filled: true,
                fillColor: const Color(0xFFD19348), // Orange background
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20), // Rounded corners
                  borderSide: BorderSide.none, // Remove border outline
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurePassword ? Icons.visibility_off : Icons.visibility,
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
            // Retype password field
            const Text(
              'Retype Password',
              style: TextStyle(
                fontSize: 18,
                fontFamily: 'Finlandica',
                color: Color(0xFF003366),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              obscureText: _obscurePassword,
              style: const TextStyle(
                color: Color(0xFF003366), // Blue text color
              ),
              decoration: InputDecoration(
                filled: true,
                fillColor: const Color(0xFFD19348), // Orange background
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20), // Rounded corners
                  borderSide: BorderSide.none, // Remove border outline
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurePassword ? Icons.visibility_off : Icons.visibility,
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
            const SizedBox(height: 30), // Space before the Sign-Up button
            // Sign-Up button
            Align(
              alignment: Alignment.bottomRight,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/myvibe');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFD88D7F), // Button background color
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20), // Rounded corners
                  ),
                ),
                child: const Text(
                  'Sign Up',
                  style: TextStyle(
                    fontSize: 22,
                    fontFamily: 'CaesarDressing',
                    color: Color(0xFF003366), // Button text color
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20), // Space below the button
          ],
        ),
      ),
    );
  }
}
