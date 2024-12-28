import 'package:flutter/material.dart';

/*use example
  YOU MUST IMPORT 
  import '../widgets/header_1_line.dart';

  SimpleHeader(
    title: 'EXAMPLE HEADER',
    underlineWidth: 150,
  ),

*/

class SimpleHeader extends StatelessWidget {
  final String title;
  final double underlineWidth;

  const SimpleHeader({
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
            'assets/images/underline.png',
            width: underlineWidth,
            fit: BoxFit.contain,
          ),
        ],
      ),
    );
  }
}
