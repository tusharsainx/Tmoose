import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tmoose/helpers/colors.dart';

class GenericInfo extends StatelessWidget {
  const GenericInfo({
    super.key,
    required this.height,
    required this.width,
    required this.onTap,
    required this.text,
  });
  final double width;
  final double height;
  final VoidCallback onTap;
  final String text;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTap();
      },
      child: Container(
        alignment: Alignment.center,
        height: height,
        width: width,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              text,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
            const SizedBox(
              width: 5,
            ),
            const Icon(
              FontAwesomeIcons.rotateRight,
              size: 16,
              color: kAppHeroColor,
            )
          ],
        ),
      ),
    );
  }
}
