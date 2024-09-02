import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:tmoose/bottomsheets/recently_played_tracks_bottomsheet.dart';
import 'package:tmoose/helpers/shimmer_widgets.dart';
import 'package:tmoose/helpers/status.dart';
import 'package:tmoose/routes/app_routes.dart';
import 'package:tmoose/tracks/models/track_model.dart';
import 'package:tmoose/user/controllers/user_profile_controller.dart';
import 'package:tmoose/user/helper/something_went_wrong.dart';

class RecentlyPlayedTracksView extends GetView<UserProfileController> {
  const RecentlyPlayedTracksView({super.key});
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Recently played",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            GestureDetector(
              onTap: () async {
                await RecentlyPlayedTracksBottomsheet.show(context: context);
              },
              child: const Text(
                "View more",
                style: TextStyle(fontSize: 14, color: Color(0xff87CEEB)),
              ),
            ),
          ],
        ),
        Obx(
          () {
            switch (controller.recentlyPlayedTracksModel.value.apiStatus) {
              case ApiStatus.loading:
                return const _Loading();
              case ApiStatus.success:
                return (controller
                                .recentlyPlayedTracksModel.value.data?.tracks ??
                            [])
                        .isEmpty
                    ? GenericInfo(
                        text: "Not found enough data to display",
                        height: 100,
                        width: double.infinity,
                        onTap: controller.fetchRecentlyPlayedTracks,
                      )
                    : const _Loaded();
              case ApiStatus.error:
                return GenericInfo(
                  text: "Something went wrong",
                  height: 100,
                  width: double.infinity,
                  onTap: controller.fetchRecentlyPlayedTracks,
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return const Row(
              children: [
                SizedBoxShimmer(width: 50, height: 50),
                SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBoxShimmer(width: 200, height: 16),
                    SizedBoxShimmer(width: 200, height: 16),
                  ],
                ),
                Spacer(),
                SizedBoxShimmer(width: 40, height: 40),
              ],
            );
          },
          separatorBuilder: (context, index) {
            return const SizedBox(height: 20);
          },
          itemCount: 10,
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            final track =
                controller.recentlyPlayedTracksModel.value.data?.tracks?[index];
            return GestureDetector(
              onTap: () {
                Get.toNamed(AppRoutes.track, arguments: track ?? TrackModel());
              },
              child: Row(
                children: [
                  CachedNetworkImage(
                    imageUrl: track?.backgroundImage ?? "",
                    placeholder: (context, url) =>
                        const CircularProgressIndicator(
                      color: Color(0xff87CEEB),
                    ),
                    errorWidget: (context, url, error) => const SizedBox(
                      width: 50,
                      height: 50,
                    ),
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
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: Get.width * 0.65,
                        child: Text(
                          track?.trackName ?? "",
                          style: const TextStyle(fontWeight: FontWeight.bold),
                          maxLines: 1,
                          overflow: TextOverflow.fade,
                        ),
                      ),
                      SizedBox(
                        width: Get.width * 0.65,
                        child: Text(
                          track?.artists?.first.artistName ?? "",
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const Icon(
                        FontAwesomeIcons.clock,
                        color: Colors.grey,
                      ),
                      Text(
                        controller.songAgoTime(track?.playedAt ?? ""),
                        style: const TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            );
          },
          separatorBuilder: (context, index) {
            return const SizedBox(height: 20);
          },
          itemCount: (controller.recentlyPlayedTracksModel.value.data?.tracks
                          ?.length ??
                      0) >
                  10
              ? 10
              : (controller
                      .recentlyPlayedTracksModel.value.data?.tracks?.length ??
                  0),
        ),
      ],
    );
  }
}
