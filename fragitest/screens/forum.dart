import 'package:flutter/material.dart';

class ForumScreen extends StatelessWidget {
  const ForumScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Forum Screen'),
      ),
      body: const Center(
        child: Text('Welcome to the Forum!'),
      ),
    );
  }
}
