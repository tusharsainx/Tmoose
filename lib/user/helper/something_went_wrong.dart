import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tmoose/helpers/colors.dart';

class SomethingWentWrong extends StatelessWidget {
  const SomethingWentWrong({
    super.key,
    required this.height,
    required this.width,
    required this.onTap,
  });
  final double width;
  final double height;
  final VoidCallback onTap;

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
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Something went wrong",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              width: 5,
            ),
            Icon(
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
