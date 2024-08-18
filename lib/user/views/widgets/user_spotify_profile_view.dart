import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:tmoose/helpers/assets_helper.dart';
import 'package:tmoose/user/controllers/user_profile_controller.dart';
import 'package:url_launcher/url_launcher.dart';

class UserSpotifyProfileView extends StatelessWidget {
  const UserSpotifyProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final UserProfileController controller = Get.find<UserProfileController>();
    return GestureDetector(
      onTap: () async {
        await launchUrl(
            Uri.parse(controller.userProfileModel?.userSpotifyProfile ?? ""));
      },
      child: Container(
        height: 50,
        width: 170,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: const Color(0xff1d1d1f),
            borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.only(top: 10, bottom: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: SvgPicture.asset(
                  AssetsHelper.spotifyLogoGreen,
                  height: 30,
                  width: 30,
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              const Text(
                "Spotify",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 10),
              const Icon(
                FontAwesomeIcons.arrowUpRightFromSquare,
                color: Color(0xff87CEEB),
                size: 18,
              )
            ],
          ),
        ),
      ),
    );
  }
}
