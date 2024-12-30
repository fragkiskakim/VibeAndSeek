import 'package:flutter/material.dart';

/*use example
  YOU MUST IMPORT 
  import '../widgets/header_1_line_descriptions.dart';

  const QuizSectionHeader(
    title: 'GREEK GODS\' QUIZ',
    underlineWidth: 200,
    description:
      'Drag the name of the God towards the correct description:',
  ),

*/

class QuizSectionHeader extends StatelessWidget {
  final String title;
  final double underlineWidth;
  final String description;

  const QuizSectionHeader({
    super.key,
    required this.title,
    required this.underlineWidth,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: Image.asset(
                  'assets/images/back.png',
                  height: 30,
                  width: 30,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 25,
                  fontFamily: 'CaesarDressing',
                  color: Color(0xFF003366),
                ),
              ),
              const SizedBox(width: 50),
            ],
          ),
          const SizedBox(height: 0),
          Image.asset(
            'assets/challenges_icons/Underline.png',
            width: underlineWidth,
            fit: BoxFit.contain,
          ),
          const SizedBox(height: 16),
          Text(
            description,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 18,
              fontFamily: 'Finlandica',
              color: Color(0xFF003366),
            ),
          ),
        ],
      ),
    );
  }
}
