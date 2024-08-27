import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:tmoose/helpers/colors.dart';
import 'package:tmoose/routes/app_routes.dart';
import 'package:tmoose/tracks/models/track_model.dart';
import 'package:tmoose/user/controllers/user_profile_controller.dart';

class RecentlyPlayedTracksBottomsheet {
  static Future<void> show({required BuildContext context}) async {
    final controller = Get.find<UserProfileController>();
    await showModalBottomSheet(
      backgroundColor: kAppBoxBackgroundColor,
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      enableDrag: true,
      builder: (context) {
        return SizedBox(
          height: Get.height * 0.8,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Recently Played Tracks",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const ClampingScrollPhysics(),
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          Get.toNamed(
                            AppRoutes.track,
                            arguments: controller.recentlyPlayedTracksModel
                                    ?.tracks?[index] ??
                                TrackModel(),
                          );
                        },
                        child: Row(
                          children: [
                            SizedBox(
                              height: 50,
                              width: 50,
                              child: CachedNetworkImage(
                                imageUrl: controller.recentlyPlayedTracksModel
                                        ?.tracks?[index].backgroundImage ??
                                    "",
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
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                    maxLines: 1,
                                    overflow: TextOverflow.fade,
                                  ),
                                ),
                                SizedBox(
                                  width: Get.width * 0.65,
                                  child: Text(
                                    controller
                                            .recentlyPlayedTracksModel
                                            ?.tracks?[index]
                                            .artists
                                            ?.first
                                            .artistName ??
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
                      );
                    },
                    separatorBuilder: (context, index) {
                      return const SizedBox(height: 15);
                    },
                    itemCount:
                        controller.recentlyPlayedTracksModel?.tracks?.length ??
                            0,
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
