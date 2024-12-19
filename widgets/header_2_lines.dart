import 'package:flutter/material.dart';

/*use example
  YOU MUST IMPORT 
  import '../widgets/header_2_lines.dart';

  Header_2_lines(
    onBackPressed: () {
      Navigator.pop(context);
    },
    firstLine: 'WHICH GREEK GOD',
    secondLine: 'ARE YOU?',
    firstUnderlineWidth: 200,
    secondUnderlineWidth: 120,
  ),

*/

// ignore: camel_case_types
class Header_2_lines extends StatelessWidget {
  final VoidCallback onBackPressed;
  final String firstLine;
  final String secondLine;
  final double firstUnderlineWidth;
  final double secondUnderlineWidth;

  const Header_2_lines({
    super.key,
    required this.onBackPressed,
    required this.firstLine,
    required this.secondLine,
    required this.firstUnderlineWidth,
    required this.secondUnderlineWidth,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          // Row for Back Button and Title with Underlines
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Back Button
              IconButton(
                icon: Image.asset(
                  'assets/images/back.png',
                  height: 30,
                  width: 30,
                ),
                onPressed: onBackPressed,
              ),
              Expanded(
                child: Stack(
                  alignment: Alignment.centerLeft,
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          firstLine,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 25,
                            fontFamily: 'CaesarDressing',
                            color: Color(0xFF003366),
                          ),
                        ),
                        const SizedBox(height: 1),
                        Image.asset(
                          'assets/images/Underline.png',
                          width: firstUnderlineWidth,
                          fit: BoxFit.contain,
                        ),
                        Text(
                          secondLine,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 25,
                            fontFamily: 'CaesarDressing',
                            color: Color(0xFF003366),
                          ),
                        ),
                        const SizedBox(height: 1),
                        Image.asset(
                          'assets/images/Underline.png',
                          width: secondUnderlineWidth,
                          fit: BoxFit.contain,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
