import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tmoose/info_aggregator/info_aggregator_view.dart';
import 'package:tmoose/routes/app_routes.dart';
import 'package:tmoose/tracks/models/track_model.dart';
import 'package:tmoose/user/controllers/user_profile_controller.dart';

class TopTracksView extends StatelessWidget {
  const TopTracksView({super.key});

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
            const Text(
              "Top tracks",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
        const SizedBox(height: 10),
        SizedBox(
          height: 150, // Adjust height as needed
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: (controller.topTracks?.tracks?.length ?? 0) > 10
                ? 10
                : (controller.topTracks?.tracks?.length ?? 0),
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  Get.toNamed(AppRoutes.track,
                      arguments: (controller.topTracks?.tracks?[index]) ??
                          TrackModel());
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 100,
                      child: CachedNetworkImage(
                        imageUrl: controller
                                .topTracks?.tracks?[index].backgroundImage ??
                            "",
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
                        "${index + 1}. ${controller.topTracks?.tracks?[index].trackName}",
                        style: const TextStyle(fontSize: 14),
                        maxLines: 1,
                        overflow: TextOverflow.fade,
                      ),
                    ),
                    Text(
                      controller.topTracks?.tracks?[index].artists?[0]
                              .artistName ??
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
