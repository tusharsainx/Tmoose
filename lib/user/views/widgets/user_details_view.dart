// ignore_for_file: unused_element

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tmoose/helpers/shimmer_widgets.dart';
import 'package:tmoose/helpers/status.dart';
import 'package:tmoose/user/controllers/user_profile_controller.dart';
import 'package:tmoose/user/helper/something_went_wrong.dart';
import 'package:tmoose/user/views/widgets/user_followers_view.dart';
import 'package:tmoose/user/views/widgets/user_spotify_profile_view.dart';

class UserDetailsView extends GetView<UserProfileController> {
  const UserDetailsView({super.key});
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      switch (controller.userProfileModel.value.apiStatus) {
        case ApiStatus.loading:
          return const _Loading();
        case ApiStatus.success:
          return const _Loaded();
        case ApiStatus.error:
          return SomethingWentWrong(
            height: 100,
            width: 100,
            onTap: () {
              controller.fetchUserProfile();
            },
          );
        case ApiStatus.none:
          return const SizedBox();
      }
    });
  }
}

class _Loading extends StatelessWidget {
  const _Loading({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBoxShimmer(width: 200, height: 20),
                SizedBox(height: 10),
                SizedBoxShimmer(width: 200, height: 15),
              ],
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
              ),
              child: const SizedBoxShimmer(
                width: 120,
                height: 120,
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBoxShimmer(
              height: 50,
              width: 170,
            ),
            SizedBoxShimmer(
              height: 50,
              width: 170,
            ),
          ],
        ),
      ],
    );
  }
}

class _Loaded extends StatelessWidget {
  const _Loaded({super.key});

  @override
  Widget build(BuildContext context) {
    final UserProfileController controller = Get.find<UserProfileController>();

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  (controller.userProfileModel.value.data?.name ?? "")
                      .toUpperCase(),
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
                imageUrl: controller.userProfileModel.value.data?.image ?? "",
                imageBuilder: (context, imageProvider) {
                  return Container(
                    height: 120,
                    width: 120,
                    decoration: BoxDecoration(
                      border:
                          Border.all(color: const Color(0xff87CEEB), width: 2),
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
        ),
        const SizedBox(height: 20),
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            UserFollowersView(),
            UserSpotifyProfileView(),
          ],
        ),
      ],
    );
  }
}
