import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:tmoose/helpers/page_helper.dart';
import 'package:tmoose/helpers/shimmer_widgets.dart';
import 'package:tmoose/helpers/status.dart';
import 'package:tmoose/info_aggregator/info_aggregator_view.dart';
import 'package:tmoose/routes/app_routes.dart';
import 'package:tmoose/tracks/models/track_model.dart';
import 'package:tmoose/user/controllers/user_profile_controller.dart';
import 'package:tmoose/user/helper/something_went_wrong.dart';

class TopTracksView extends GetView<UserProfileController> {
  const TopTracksView({super.key});
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Text(
                  "Top tracks",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  width: 10,
                ),
                InkWell(
                  onTap: () {
                    if (controller.topTracks.value.apiStatus ==
                        ApiStatus.success) {
                      MusicPlayerHelper.setUniqueId();
                      Get.toNamed(
                        AppRoutes.musicPlayer,
                        arguments: controller.topTracks.value.data ??
                            UserTopTracksModel(),
                      );
                    }
                  },
                  child: const Icon(
                    FontAwesomeIcons.play,
                    size: 18,
                    color: Colors.white,
                  ),
                )
              ],
            ),
            GestureDetector(
              onTap: () {
                Get.to(() => const InfoAggregatorView(
                      isArtistTopTracks: true,
                    ));
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
            switch (controller.topTracks.value.apiStatus) {
              case ApiStatus.loading:
                return const _Loading();
              case ApiStatus.success:
                return (controller.topTracks.value.data?.tracks ?? []).isEmpty
                    ? GenericInfo(
                        text: "Not found enough data to display",
                        height: 100,
                        width: double.infinity,
                        onTap: () {
                          controller.fetchTopTracks(
                              timeRange:
                                  controller.choosenTimeRange.value.name);
                        },
                      )
                    : const _Loaded();
              case ApiStatus.error:
                return GenericInfo(
                  text: "Something went wrong",
                  height: 100,
                  width: double.infinity,
                  onTap: () {
                    controller.fetchTopTracks(
                        timeRange: controller.choosenTimeRange.value.name);
                  },
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
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 10),
        SizedBox(
          height: 150, // Adjust height as needed
          child: HorizontalListViewBoxShimmer(
            height: 150,
            width: 150,
          ),
        ),
      ],
    );
  }
}

class _Loaded extends StatelessWidget {
  // ignore: unused_element
  const _Loaded({super.key});

  @override
  Widget build(BuildContext context) {
    final UserProfileController controller = Get.find<UserProfileController>();

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        SizedBox(
          height: 150, // Adjust height as needed
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount:
                (controller.topTracks.value.data?.tracks?.length ?? 0) > 10
                    ? 10
                    : (controller.topTracks.value.data?.tracks?.length ?? 0),
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  TrackPageHelper.setUniqueId();
                  Get.toNamed(AppRoutes.track,
                      preventDuplicates: false,
                      arguments:
                          (controller.topTracks.value.data?.tracks?[index]) ??
                              TrackModel());
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 100,
                      child: CachedNetworkImage(
                        imageUrl: controller.topTracks.value.data
                                ?.tracks?[index].backgroundImage ??
                            "",
                        errorWidget: (context, url, error) => const SizedBox(
                          width: 100,
                          height: 100,
                        ),
                        imageBuilder: (context, imageProvider) => Container(
                          height: 100,
                          width: 100,
                          decoration: BoxDecoration(
                            border: Border.all(color: const Color(0xff87CEEB)),
                            borderRadius: BorderRadius.circular(8),
                            image: DecorationImage(
                              image: imageProvider,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      width: 100,
                      child: Text(
                        "${index + 1}. ${controller.topTracks.value.data?.tracks?[index].trackName}",
                        style: const TextStyle(fontSize: 14),
                        maxLines: 1,
                        overflow: TextOverflow.fade,
                      ),
                    ),
                    Text(
                      controller.topTracks.value.data?.tracks?[index]
                              .artists?[0].artistName ??
                          "Unknown Artist",
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              );
            },
            separatorBuilder: (context, index) {
              return const SizedBox(width: 10);
            },
          ),
        ),
      ],
    );
  }
}
