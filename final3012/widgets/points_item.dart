import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PointsItem extends StatelessWidget {
  final String userId;
  final String iconpath; // Use an IconData instead of an iconPath

  const PointsItem({
    super.key,
    required this.userId,
    required this.iconpath,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('Users') // Replace with your collection name
          .doc(userId) // Fetch the user's document based on userId
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator(); // Show a loading spinner
        }
        if (snapshot.hasError) {
          return const Text('Error fetching points'); // Handle errors
        }
        if (!snapshot.hasData || !snapshot.data!.exists) {
          return const Text('User not found'); // Handle missing user data
        }

        // Get points from Firestore
        final userData = snapshot.data!.data() as Map<String, dynamic>;
        final points =
            userData['points'] ?? 0; // Default to 0 if points are null

        return Container(
          margin: const EdgeInsets.symmetric(vertical: 8),
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFF003366), width: 2),
          ),
          child: Row(
            children: [
              Image.asset(
                iconpath,
                width: 30,
              ),
              const SizedBox(width: 16),
              Text(
                'POINTS: $points', // Dynamically display the user's points
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
      },
    );
  }
}
