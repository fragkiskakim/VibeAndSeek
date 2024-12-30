import 'package:flutter/material.dart';

class MapsScreen extends StatelessWidget {
  const MapsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Maps Screen'),
      ),
      body: const Center(
        child: Text('Welcome to the Maps Screen!'),
      ),
    );
  }
}