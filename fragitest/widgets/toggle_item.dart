import 'package:flutter/material.dart';

class ToggleItem extends StatefulWidget {
  final String title;

  const ToggleItem({super.key, required this.title});

  @override
  State<ToggleItem> createState() => _ToggleItemState();
}

class _ToggleItemState extends State<ToggleItem> {
  bool _isToggled = true; // Default ON

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
              value: _isToggled,
              onChanged: (value) {
                setState(() {
                  _isToggled = value; // Update toggle state
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
