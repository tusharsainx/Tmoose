import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
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
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Recently played",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              "More",
              style: TextStyle(fontSize: 14, color: Color(0xff87CEEB)),
            ),
          ],
        ),
        SizedBox(
          height: 72 *
              ((controller.recentlyPlayedTracksModel?.tracks?.length) ?? 0)
                  .toDouble(),
          child: ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  Get.toNamed(AppRoutes.track,
                      arguments: (controller
                              .recentlyPlayedTracksModel?.tracks?[index]) ??
                          TrackModel());
                },
                child: SizedBox(
                  height: 50,
                  child: Row(
                    children: [
                      SizedBox(
                        height: 50,
                        child: CachedNetworkImage(
                          imageUrl: controller.recentlyPlayedTracksModel
                                  ?.tracks?[index].backgroundImage ??
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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            width: Get.width * 0.65,
                            child: Text(
                              controller.recentlyPlayedTracksModel
                                      ?.tracks?[index].trackName ??
                                  "",
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                              maxLines: 1,
                              overflow: TextOverflow.fade,
                            ),
                          ),
                          SizedBox(
                            width: Get.width * 0.65,
                            child: Text(
                              controller.recentlyPlayedTracksModel
                                      ?.tracks?[index].artists?[0].artistName ??
                                  "",
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
                            controller.songAgoTime(controller
                                    .recentlyPlayedTracksModel
                                    ?.tracks?[index]
                                    .playedAt ??
                                ""),
                            style: const TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              );
            },
            separatorBuilder: (context, index) {
              return const SizedBox(height: 20);
            },
            itemCount:
                controller.recentlyPlayedTracksModel?.tracks?.length ?? 0,
          ),
        ),
      ],
    );
  }
}
