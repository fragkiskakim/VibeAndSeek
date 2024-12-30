import 'package:flutter/material.dart';

// Define a custom button widget
class HomepageButton extends StatelessWidget {
  final String assetPath;
  final String label;
  final VoidCallback onTap;

  const HomepageButton({
    super.key,
    required this.assetPath,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10), // Vertical space between buttons
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16), // Make button taller
      decoration: BoxDecoration(
        color: const Color(0xFF003366),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: InkWell(
        onTap: onTap,
        child: Row(
          mainAxisSize: MainAxisSize.max, // Ensure button stretches across the available width
          mainAxisAlignment: MainAxisAlignment.center, // Center content horizontally
          children: [
            Image.asset(
              assetPath,
              width: 40, // Icon size
              height: 40,
            ),
            const SizedBox(width: 4), // Small space between icon and text
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  color: Color(0xFFD88D7F),
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
