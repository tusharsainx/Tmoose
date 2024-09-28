import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:tmoose/helpers/colors.dart';
import 'package:tmoose/helpers/page_helper.dart';
import 'package:tmoose/helpers/shimmer_widgets.dart';
import 'package:tmoose/music_player/controller/music_player_controller.dart';
import 'package:tmoose/routes/app_routes.dart';
import 'package:tmoose/tracks/models/track_model.dart';

class MusicPlayerView extends StatelessWidget {
  const MusicPlayerView({super.key});

  @override
  Widget build(BuildContext context) {
    MusicPlayerController controller =
        Get.find<MusicPlayerController>(tag: MusicPlayerHelper.uniqueid);
    return Obx(() {
      return controller.isTracksEmptyOrNull.value
          ? const Scaffold(
              backgroundColor: Colors.black,
              body: Center(
                child: Text("No tracks found",
                    style: TextStyle(color: Colors.grey)),
              ),
            )
          : Scaffold(
              body: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.grey,
                      kAppBoxBackgroundColor,
                      Colors.black,
                    ],
                  ),
                ),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "T.Moose",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Colors.grey,
                          ),
                        ),
                        SizedBox(
                          height: Get.height * 0.05,
                        ),
                        SizedBox(
                          height: Get.height * 0.35,
                          width: Get.width,
                          child: PageView(
                            controller: controller.pageController,
                            onPageChanged: (index) {
                              if (controller.isPageChangedByButtonPress ==
                                  false) {
                                controller.isPageChangedBySwiping = true;
                              }
                              if (controller.isPageChangedBySwiping) {
                                if (index > controller.trackNo.value) {
                                  controller.nextSong();
                                } else {
                                  controller.previousSong();
                                }
                              }
                              controller.isPageChangedByButtonPress = false;
                              controller.isPageChangedBySwiping = false;
                            },
                            children: [
                              for (int i = 0;
                                  i <
                                      (controller.playableTracks.value.data!
                                                  .tracks ??
                                              [])
                                          .length;
                                  i++) ...[
                                TrackImageWidget(
                                  index: i,
                                ),
                              ],
                            ],
                          ),
                        ),
                        SizedBox(
                          height: Get.height * 0.08,
                        ),
                        const _TrackNameArtistNameRowWidget(),
                        SizedBox(
                          height: Get.height * 0.04,
                        ),
                        const _TrackTimelineWidget(),
                        SizedBox(
                          height: Get.height * 0.06,
                        ),
                        const _FrontbackPlayPauseWidget(),
                      ],
                    ),
                  ),
                ),
              ),
            );
    });
  }
}

class TrackImageWidget extends StatelessWidget {
  const TrackImageWidget({super.key, required this.index});
  final int index;
  @override
  Widget build(BuildContext context) {
    MusicPlayerController controller =
        Get.find<MusicPlayerController>(tag: MusicPlayerHelper.uniqueid);
    return CachedNetworkImage(
      imageUrl: controller
              .playableTracks.value.data?.tracks?[index].backgroundImage ??
          "",
      placeholder: (context, url) => SizedBoxShimmer(
        height: Get.height * 0.35,
        width: Get.height * 0.35,
      ),
      errorWidget: (context, url, error) => SizedBox(
        height: Get.height * 0.35,
        width: Get.height * 0.35,
      ),
      imageBuilder: (context, imageProvider) => Container(
        height: Get.height * 0.35,
        width: Get.height * 0.35,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: imageProvider,
          ),
        ),
      ),
    );
  }
}

class _TrackNameArtistNameRowWidget extends StatelessWidget {
  const _TrackNameArtistNameRowWidget();

  @override
  Widget build(BuildContext context) {
    MusicPlayerController controller =
        Get.find<MusicPlayerController>(tag: MusicPlayerHelper.uniqueid);
    return Obx(
      () {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  width: Get.width * 0.7,
                  child: Text(
                    controller.playableTracks.value.data
                            ?.tracks?[controller.trackNo.value].trackName ??
                        "",
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(
                  width: Get.width * 0.7,
                  child: Text(
                    maxLines: 1,
                    overflow: TextOverflow.fade,
                    controller.getArtistNames(controller.playableTracks.value
                        .data?.tracks?[controller.trackNo.value].artists),
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(1000),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(1000),
                    onTap: () {},
                    child: ColoredBox(
                      color: Colors.white.withOpacity(0.2),
                      child: const Padding(
                        padding: EdgeInsets.all(4.0),
                        child: Icon(
                          FontAwesomeIcons.plus,
                          size: 16,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                ClipRRect(
                  borderRadius: BorderRadius.circular(1000),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(1000),
                    onTap: () {
                      controller.pauseMusic();
                      TrackPageHelper.setUniqueId();
                      Get.toNamed(AppRoutes.track,
                          arguments: controller.playableTracks.value.data
                                  ?.tracks?[controller.trackNo.value] ??
                              TrackModel());
                    },
                    child: ColoredBox(
                      color: Colors.white.withOpacity(0.2),
                      child: const Padding(
                        padding: EdgeInsets.all(4.0),
                        child: Icon(
                          FontAwesomeIcons.info,
                          size: 16,
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ],
        );
      },
    );
  }
}

class _TrackTimelineWidget extends StatelessWidget {
  const _TrackTimelineWidget();

  @override
  Widget build(BuildContext context) {
    MusicPlayerController controller =
        Get.find<MusicPlayerController>(tag: MusicPlayerHelper.uniqueid);
    return Obx(
      () {
        return Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            SizedBox(
              width: Get.width,
              child: SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  thumbShape: SliderComponentShape.noOverlay,
                  trackHeight: 8,
                ),
                child: Slider(
                  value: controller.position.value.inSeconds.toDouble(),
                  max: controller.duration.value.inSeconds.toDouble(),
                  onChanged: (value) {
                    controller.seek(value);
                  },
                  inactiveColor: Colors.white.withOpacity(0.2),
                  activeColor: Colors.white.withOpacity(0.7),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    controller.getPositionValue(controller.position.value),
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.4),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "0:${controller.duration.value.inSeconds}",
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.4),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            )
          ],
        );
      },
    );
  }
}

class _FrontbackPlayPauseWidget extends StatelessWidget {
  const _FrontbackPlayPauseWidget();

  @override
  Widget build(BuildContext context) {
    MusicPlayerController controller =
        Get.find<MusicPlayerController>(tag: MusicPlayerHelper.uniqueid);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        GestureDetector(
          onTap: () {
            controller.previousSong();
          },
          child: const Icon(
            FontAwesomeIcons.backwardStep,
            size: 50,
          ),
        ),
        Obx(
          () {
            return GestureDetector(
              onTap: () {
                controller.playPause();
              },
              child: controller.isAudioLoading.value
                  ? const SizedBox(
                      height: 50,
                      width: 50,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                      ),
                    )
                  : Icon(
                      controller.isSongPlaying.value
                          ? FontAwesomeIcons.pause
                          : FontAwesomeIcons.play,
                      size: 50,
                    ),
            );
          },
        ),
        GestureDetector(
          onTap: () {
            controller.nextSong();
          },
          child: const Icon(
            FontAwesomeIcons.forwardStep,
            size: 50,
          ),
        ),
      ],
    );
  }
}
