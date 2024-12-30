import 'package:flutter/material.dart';
import '../utils/global_state.dart'; // Update with the actual path of your GlobalState class

class ToggleItem extends StatefulWidget {
  final String title;

  const ToggleItem({super.key, required this.title});

  @override
  State<ToggleItem> createState() => _ToggleItemState();
}

class _ToggleItemState extends State<ToggleItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF003366), width: 2),
      ),
      child: Row(
        children: [
          Transform.scale(
            scale: 0.7, // Make the Switch smaller
            child: Switch(
              value: GlobalState().soundAllowed, // Bind to the global state
              onChanged: (value) {
                setState(() {
                  GlobalState().soundAllowed = value; // Update the global state
                });
              },
              activeColor: const Color(0xFF003366),
            ),
          ),
          const SizedBox(width: 10),
          Text(
            widget.title,
            style: const TextStyle(
              fontFamily: "CaesarDressing",
              color: Color(0xFF003366),
              fontWeight: FontWeight.bold,
              fontSize: 25,
            ),
          ),
        ],
      ),
    );
  }
}
