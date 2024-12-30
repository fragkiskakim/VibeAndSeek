import 'package:flutter/material.dart';

class CustomCard extends StatelessWidget {
  final String title;
  final String? iconPath;
  final IconData? materialIcon;
  final Color? materialIconColor;
  final VoidCallback? onTap;

  const CustomCard({
    super.key,
    required this.title,
    this.iconPath, // Optional asset icon
    this.materialIcon, // Optional Material icon
    this.materialIconColor = const Color(0xFF003366), // Default color
    this.onTap,
  }) : assert(iconPath != null || materialIcon != null,
            "Either iconPath or materialIcon must be provided.");

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFF003366), width: 2),
        ),
        child: Row(
          children: [
            // Display either the asset icon or Material icon
            if (iconPath != null)
              Image.asset(iconPath!, width: 28, height: 28)
            else if (materialIcon != null)
              Icon(materialIcon, size: 28, color: materialIconColor),
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
      ),
    );
  }
}
