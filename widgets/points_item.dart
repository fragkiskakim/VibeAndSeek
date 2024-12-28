import 'package:flutter/material.dart';

class PointsItem extends StatelessWidget {
  final String title;
  final String iconPath;

  const PointsItem({super.key, required this.title, required this.iconPath});

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
          Image.asset(iconPath, width: 28, height: 28),
          const SizedBox(width: 16),
          Text(
            title,
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
