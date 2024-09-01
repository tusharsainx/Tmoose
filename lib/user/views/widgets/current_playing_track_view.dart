import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tmoose/helpers/shimmer_widgets.dart';
import 'package:tmoose/helpers/status.dart';
import 'package:tmoose/routes/app_routes.dart';
import 'package:tmoose/tracks/models/track_model.dart';
import 'package:tmoose/user/controllers/user_profile_controller.dart';
import 'package:tmoose/user/helper/something_went_wrong.dart';

class CurrentPlayingTrackView extends GetView<UserProfileController> {
  const CurrentPlayingTrackView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text(
          "Currently playing",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        Obx(
          () {
            switch (controller.currentPlayingTrackModel.value.apiStatus) {
              case ApiStatus.loading:
                return const _Loading();
              case ApiStatus.success:
                return const _Loaded();
              case ApiStatus.error:
                return GenericInfo(
                  text: "Something went wrong",
                  height: 50,
                  width: double.infinity,
                  onTap: controller.fetchCurrentlyPlayingTrack,
                );
              case ApiStatus.none:
                return const SizedBox();
            }
          },
        ),
      ],
    );
  }
}

class _Loading extends StatelessWidget {
  const _Loading();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(height: 10),
        Row(
          children: [
            SizedBoxShimmer(
              height: 50,
              width: 50,
            ),
            SizedBox(width: 10),
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBoxShimmer(width: 200, height: 16),
                SizedBoxShimmer(width: 200, height: 16),
              ],
            )
          ],
        ),
      ],
    );
  }
}

class _Loaded extends StatelessWidget {
  const _Loaded();

  @override
  Widget build(BuildContext context) {
    final UserProfileController controller = Get.find<UserProfileController>();
    if (controller.currentPlayingTrackModel.value.data?.backgroundImage !=
        null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 10),
          GestureDetector(
            onTap: () {
              Get.toNamed(AppRoutes.track,
                  arguments: (controller.currentPlayingTrackModel.value.data ??
                      CurrentPlayingTrackModel()));
            },
            child: Row(
              children: [
                SizedBox(
                  height: 50,
                  child: CachedNetworkImage(
                    imageUrl: controller.currentPlayingTrackModel.value.data
                            ?.backgroundImage ??
                        "",
                    imageBuilder: (context, imageProvider) {
                      return Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: imageProvider,
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      controller
                              .currentPlayingTrackModel.value.data?.trackName ??
                          "",
                      maxLines: 1,
                      overflow: TextOverflow.fade,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(
                      width: Get.width * 0.7,
                      child: Text(
                        controller.getArtistNames(controller
                            .currentPlayingTrackModel.value.data?.artists),
                        maxLines: 1,
                        overflow: TextOverflow.fade,
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      );
    } else {
      return const SizedBox();
    }
  }
}
