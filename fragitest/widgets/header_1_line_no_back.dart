import 'package:flutter/material.dart';

/*use example
  YOU MUST IMPORT 
  import '../widgets/header_1_line_no_back.dart';

  Header1LineNoBack(
    title: 'EXAMPLE HEADER',
    underlineWidth: 150,
  ),
*/

class Header1LineNoBack extends StatelessWidget {
  final String title;
  final double underlineWidth;

  const Header1LineNoBack({
    super.key,
    required this.title,
    required this.underlineWidth,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          // Row with only the title centered
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 25,
                  fontFamily: 'CaesarDressing',
                  color: Color(0xFF003366),
                  height: 1.0,
                ),
              ),
            ],
          ),
          const SizedBox(height: 0),
          // Underline image
          Image.asset(
            'assets/images/underline.png',
            width: underlineWidth,
            fit: BoxFit.contain,
          ),
        ],
      ),
    );
  }
}
