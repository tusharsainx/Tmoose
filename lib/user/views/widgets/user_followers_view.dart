import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tmoose/user/controllers/user_profile_controller.dart';

class UserFollowersView extends StatelessWidget {
  const UserFollowersView({super.key});

  @override
  Widget build(BuildContext context) {
    final UserProfileController controller = Get.find<UserProfileController>();
    return Container(
      height: 50,
      width: 170,
      alignment: Alignment.center,
      decoration: BoxDecoration(
          border: Border.all(width: 4, color: const Color(0xff1d1d1f)),
          borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.only(top: 10, bottom: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              width: 10,
            ),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: controller
                        .userFollowers(controller.userProfileModel?.followers),
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const TextSpan(
                    text: " followers",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
