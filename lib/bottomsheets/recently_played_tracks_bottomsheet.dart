import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:tmoose/helpers/colors.dart';
import 'package:tmoose/helpers/page_helper.dart';
import 'package:tmoose/routes/app_routes.dart';
import 'package:tmoose/tracks/models/track_model.dart';
import 'package:tmoose/user/controllers/user_profile_controller.dart';
import 'package:tmoose/user/helper/something_went_wrong.dart';

class RecentlyPlayedTracksBottomsheet {
  static Future<void> show({required BuildContext context}) async {
    final controller = Get.find<UserProfileController>();
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      showDragHandle: false,
      enableDrag: false,
      builder: (context) {
        return Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20)),
            gradient: LinearGradient(
              colors: [
                kAppHeroColor,
                Color(0xFF000000),
              ], // Deep Blue to Black
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          height: Get.height * 0.7,
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
                        color: Colors.black),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Obx(() {
                    return (controller.recentlyPlayedTracksModel.value.data
                                    ?.tracks ??
                                [])
                            .isEmpty
                        ? GenericInfo(
                            text: "Not found enough data to display",
                            height: 100,
                            width: double.infinity,
                            onTap: controller.fetchRecentlyPlayedTracks,
                          )
                        : ListView.separated(
                            shrinkWrap: true,
                            physics: const ClampingScrollPhysics(),
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () {
                                  TrackPageHelper.setUniqueId();
                                  Get.toNamed(
                                    AppRoutes.track,
                                    preventDuplicates: false,
                                    arguments: controller
                                            .recentlyPlayedTracksModel
                                            .value
                                            .data
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
                                        imageUrl: controller
                                                .recentlyPlayedTracksModel
                                                .value
                                                .data
                                                ?.tracks?[index]
                                                .backgroundImage ??
                                            "",
                                        placeholder: (context, url) =>
                                            const CircularProgressIndicator(
                                          color: Color(0xff87CEEB),
                                        ),
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        SizedBox(
                                          width: Get.width * 0.65,
                                          child: Text(
                                            controller
                                                    .recentlyPlayedTracksModel
                                                    .value
                                                    .data
                                                    ?.tracks?[index]
                                                    .trackName ??
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
                                                    .value
                                                    .data
                                                    ?.tracks?[index]
                                                    .artists
                                                    ?.first
                                                    .artistName ??
                                                "",
                                            style: const TextStyle(
                                                color: Colors.grey),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const Spacer(),
                                    Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        const Icon(
                                          FontAwesomeIcons.clock,
                                          color: Colors.grey,
                                        ),
                                        Text(
                                          controller.songAgoTime(controller
                                                  .recentlyPlayedTracksModel
                                                  .value
                                                  .data
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
                            itemCount: controller.recentlyPlayedTracksModel
                                    .value.data?.tracks?.length ??
                                0,
                          );
                  }),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
