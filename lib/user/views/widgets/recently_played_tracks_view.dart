import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:tmoose/info_aggregator/info_aggregator_view.dart';
import 'package:tmoose/routes/app_routes.dart';
import 'package:tmoose/tracks/models/track_model.dart';
import 'package:tmoose/user/controllers/user_profile_controller.dart';

class RecentlyPlayedTracksView extends StatelessWidget {
  const RecentlyPlayedTracksView({super.key});

  @override
  Widget build(BuildContext context) {
    final UserProfileController controller = Get.find<UserProfileController>();
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
              onTap: () {
                // Get.to(() => const InfoAggregatorView());
              },
              child: const Text(
                "View more",
                style: TextStyle(fontSize: 14, color: Color(0xff87CEEB)),
              ),
            ),
          ],
        ),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            final track = controller.recentlyPlayedTracksModel?.tracks?[index];
            return GestureDetector(
              onTap: () {
                Get.toNamed(AppRoutes.track, arguments: track ?? TrackModel());
              },
              child: Row(
                children: [
                  CachedNetworkImage(
                    imageUrl: track?.backgroundImage ?? "",
                    placeholder: (context, url) =>
                        const CircularProgressIndicator(),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
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
          itemCount:
              (controller.recentlyPlayedTracksModel?.tracks?.length ?? 0) > 10
                  ? 10
                  : (controller.recentlyPlayedTracksModel?.tracks?.length ?? 0),
        ),
      ],
    );
  }
}
