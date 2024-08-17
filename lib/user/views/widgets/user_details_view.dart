import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tmoose/helpers/shimmer_widgets.dart';
import 'package:tmoose/user/controllers/user_profile_controller.dart';

class UserDetailsView extends StatelessWidget {
  const UserDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    final UserProfileController controller = Get.find<UserProfileController>();

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              (controller.userProfileModel?.name ?? "").toUpperCase(),
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: Get.width * 0.4,
              child: RichText(
                text: const TextSpan(
                  children: [
                    TextSpan(
                        text: "Hey there, I am vibing with ",
                        style: TextStyle(
                          color: Colors.grey,
                        )),
                    TextSpan(
                      text: "Moodify",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: Color(0xff87CEEB),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
        SizedBox(
          height: 120,
          child: CachedNetworkImage(
            imageUrl: controller.userProfileModel?.image ?? "",
            imageBuilder: (context, imageProvider) {
              return Container(
                height: 120,
                width: 120,
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xff87CEEB), width: 2),
                  borderRadius: BorderRadius.circular(100),
                  image: DecorationImage(
                    image: imageProvider,
                    fit: BoxFit.cover,
                  ),
                ),
              );
            },
            errorWidget: (context, url, error) {
              return const SizedBoxShimmer(
                height: 120,
                width: 120,
              );
            },
          ),
        ),
      ],
    );
  }
}
