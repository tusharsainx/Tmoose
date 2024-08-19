import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:tmoose/helpers/assets_helper.dart';
import 'package:tmoose/user/controllers/user_profile_controller.dart';
import 'package:tmoose/user/helper/enums.dart';
import 'package:tmoose/user/helper/user_profile_shimmer.dart';
import 'package:tmoose/user/views/widgets/current_playing_track_view.dart';
import 'package:tmoose/user/views/widgets/recently_played_tracks_view.dart';
import 'package:tmoose/user/views/widgets/top_artists_view.dart';
import 'package:tmoose/user/views/widgets/top_tracks_view.dart';
import 'package:tmoose/user/views/widgets/user_details_view.dart';
import 'package:tmoose/user/views/widgets/user_followers_view.dart';
import 'package:tmoose/user/views/widgets/user_spotify_profile_view.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:visibility_detector/visibility_detector.dart';

class UserProfileView extends StatelessWidget {
  const UserProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final UserProfileController controller = Get.find<UserProfileController>();
    return VisibilityDetector(
      key: const Key("userProfile"),
      onVisibilityChanged: (info) {
        if (info.visibleFraction == 0.0) {
          controller.isScrolledSpecificHeight(false);
        }
      },
      child: Scaffold(
        bottomNavigationBar: Obx(() {
          if (!controller.isDataLoading.value) {
            return ColoredBox(
              color: Colors.black,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Obx(
                  () {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        GestureDetector(
                          onTap: () async {
                            if (controller.choosenTimeRange.value !=
                                TimeRange.short_term) {
                              controller.choosenTimeRange.value =
                                  TimeRange.short_term;
                              await controller.changeTimeOfSearch(
                                items: 10,
                              );
                            }
                          },
                          child: Text(
                            "4 weeks",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: controller.choosenTimeRange.value ==
                                      TimeRange.short_term
                                  ? const Color(0xff87CEEB)
                                  : Colors.white,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () async {
                            if (controller.choosenTimeRange.value !=
                                TimeRange.medium_term) {
                              controller.choosenTimeRange.value =
                                  TimeRange.medium_term;
                              await controller.changeTimeOfSearch(
                                items: 10,
                              );
                            }
                          },
                          child: Text(
                            "6 months",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: controller.choosenTimeRange.value ==
                                      TimeRange.medium_term
                                  ? const Color(0xff87CEEB)
                                  : Colors.white,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () async {
                            if (controller.choosenTimeRange.value !=
                                TimeRange.long_term) {
                              controller.choosenTimeRange.value =
                                  TimeRange.long_term;
                              await controller.changeTimeOfSearch(
                                items: 10,
                              );
                            }
                          },
                          child: Text(
                            "1 year",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: controller.choosenTimeRange.value ==
                                      TimeRange.long_term
                                  ? const Color(0xff87CEEB)
                                  : Colors.white,
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            );
          } else {
            return const SizedBox();
          }
        }),
        backgroundColor: Colors.black,
        body: Obx(
          () {
            if (controller.isDataLoading.value) {
              return const UserProfileShimmer();
            } else {
              return RefreshIndicator(
                color: const Color(0xff87CEEB),
                onRefresh: controller.init,
                child: CustomScrollView(
                  controller: controller.scrollController,
                  shrinkWrap: true,
                  physics: const ClampingScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  slivers: [
                    SliverPadding(
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                      sliver: SliverAppBar(
                        automaticallyImplyLeading: false,
                        backgroundColor: Colors.black,
                        expandedHeight: 200.0,
                        pinned: true,
                        flexibleSpace: FlexibleSpaceBar(
                            title: Obx(
                              () {
                                if (controller.isScrolledSpecificHeight.value) {
                                  return GestureDetector(
                                    onTap: () async {
                                      await launchUrl(
                                        Uri.parse(
                                          controller.userProfileModel
                                                  ?.userSpotifyProfile ??
                                              "",
                                        ),
                                      );
                                    },
                                    child: ClipRRect(
                                      borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(20),
                                          topRight: Radius.circular(20)),
                                      child: ColoredBox(
                                        color: const Color(0xff1d1d1f),
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              top: 10, bottom: 10),
                                          child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              100),
                                                      child: SvgPicture.asset(
                                                        AssetsHelper
                                                            .spotifyLogoGreen,
                                                        height: 30,
                                                        width: 30,
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      width: 10,
                                                    ),
                                                    SizedBox(
                                                      width: Get.width * 0.7,
                                                      child: const Text(
                                                        "Go to spotify profile",
                                                        maxLines: 1,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: TextStyle(
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ),
                                                    const Icon(
                                                        size: 20,
                                                        color:
                                                            Color(0xff87CEEB),
                                                        FontAwesomeIcons
                                                            .arrowUpRightFromSquare)
                                                  ],
                                                ),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                              ]),
                                        ),
                                      ),
                                    ),
                                  );
                                } else {
                                  return const Text("");
                                }
                              },
                            ),
                            titlePadding: const EdgeInsetsDirectional.only(
                                start: 0, end: 0),
                            background: const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                UserDetailsView(),
                                SizedBox(height: 20),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    UserFollowersView(),
                                    UserSpotifyProfileView(),
                                  ],
                                ),
                              ],
                            )),
                      ),
                    ),
                    SliverPadding(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                      sliver: SliverList(
                        delegate: SliverChildListDelegate(
                          [
                            const SizedBox(height: 15),
                            const TopArtistsView(),
                            Obx(() {
                              if (controller.isAnySongCurrentlyPlaying.value) {
                                return const Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CurrentPlayingTrackView(),
                                    SizedBox(height: 20),
                                  ],
                                );
                              }
                              return const SizedBox();
                            }),
                            const TopTracksView(),
                            const SizedBox(height: 20),
                            const RecentlyPlayedTracksView(),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
