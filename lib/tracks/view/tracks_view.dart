import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:tmoose/helpers/assets_helper.dart';
import 'package:tmoose/helpers/shimmer_widgets.dart';
import 'package:tmoose/tracks/controller/tracks_view_controller.dart';
import 'package:tmoose/tracks/view/track_view_shimmer.dart';
import 'package:url_launcher/url_launcher.dart';

class TrackPage extends GetView<TrackPageController> {
  const TrackPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Obx(() {
        if (controller.isDataLoading.value) {
          return const TrackViewShimmer();
        } else {
          return CustomScrollView(
            physics: const BouncingScrollPhysics(),
            shrinkWrap: true,
            controller: controller.scrollController,
            slivers: [
              SliverAppBar(
                pinned: true,
                expandedHeight: Get.height * 0.5,
                flexibleSpace: FlexibleSpaceBar(
                  background: SizedBox(
                    height: Get.height * 0.5,
                    child: CachedNetworkImage(
                      imageUrl: controller.trackModel?.backgroundImage ?? "",
                      errorWidget: (context, url, error) =>
                          SizedBox(height: Get.height * 0.5),
                      imageBuilder: (context, imageProvider) {
                        return Container(
                          height: Get.height * 0.5,
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
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.all(20),
                sliver: SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      Text(
                        controller.trackModel?.trackName ?? "",
                        style: const TextStyle(
                            fontSize: 30, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                            width: Get.width * 0.4,
                            decoration: BoxDecoration(
                              color: const Color(0xff1d1d1f),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    "${controller.trackModel?.trackPopularity ?? 0}",
                                    style: const TextStyle(
                                      color: Color(0xff87CEEB),
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const Text(
                                    "0-100 popularity",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            width: Get.width * 0.4,
                            decoration: BoxDecoration(
                              color: const Color(0xff1d1d1f),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    controller.getTrackDurtion(
                                        controller.trackModel?.trackDuration ??
                                            ""),
                                    style: const TextStyle(
                                      color: Color(0xff87CEEB),
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const Text("track length",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      if ((controller.trackModel?.previewUrl ?? "")
                          .isNotEmpty) ...[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const Text(
                              "Preview",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            SizedBox(
                              height: 20,
                              width: 20,
                              child: SvgPicture.asset(
                                  AssetsHelper.spotifyLogoGreen),
                            ),
                          ],
                        ),
                        Obx(
                          () {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: Get.width * 0.7,
                                  child: Slider(
                                    value: controller.position.value.inSeconds
                                        .toDouble(),
                                    max: controller.duration.value.inSeconds
                                        .toDouble(),
                                    onChanged: (value) async {
                                      await controller.seek(value);
                                    },
                                    inactiveColor: const Color(0xff1d1d1f),
                                    activeColor: const Color(0xff87CEEB),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                controller.isAudioLoading.value
                                    ? const SizedBox(
                                        height: 18,
                                        width: 18,
                                        child: CircularProgressIndicator(
                                          color: Color(0xff87CEEB),
                                        ),
                                      )
                                    : controller.isSongPlayed.value
                                        ? IconButton(
                                            onPressed: () async {
                                              await controller
                                                  .handleAudioPlayPause();
                                            },
                                            icon: const Icon(
                                              color: Colors.white,
                                              FontAwesomeIcons.pause,
                                              size: 18,
                                            ))
                                        : IconButton(
                                            onPressed: () async {
                                              await controller
                                                  .handleAudioPlayPause();
                                            },
                                            icon: const Icon(
                                              color: Colors.white,
                                              FontAwesomeIcons.play,
                                              size: 18,
                                            ),
                                          ),
                              ],
                            );
                          },
                        ),
                      ],
                      if (controller.trackModel?.album != null) ...[
                        const Text(
                          "Album",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 15),
                        GestureDetector(
                          onTap: () async {
                            await launchUrl(Uri.parse(controller
                                    .trackModel?.album?.albumSpotifyLink ??
                                ""));
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: const Color(0xff1d1d1f),
                            ),
                            child: Row(
                              children: [
                                SizedBox(
                                  height: 150,
                                  width: Get.width * 0.4,
                                  child: CachedNetworkImage(
                                    imageUrl: controller
                                            .trackModel?.album?.imageUrl ??
                                        "",
                                    errorWidget: (context, url, error) =>
                                        SizedBoxShimmer(
                                      width: Get.width * 0.4,
                                      height: 150,
                                    ),
                                    imageBuilder: (context, imageProvider) {
                                      return Container(
                                        height: 150,
                                        width: Get.width * 0.4,
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
                                    SizedBox(
                                      width: Get.width * 0.4,
                                      child: Text(
                                        controller
                                                .trackModel?.album?.albumName ??
                                            "",
                                        maxLines: 1,
                                        overflow: TextOverflow.fade,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16),
                                      ),
                                    ),
                                    SizedBox(
                                      width: Get.width * 0.4,
                                      child: Text(
                                        controller.getArtistNames(controller
                                            .trackModel?.album?.artists),
                                        maxLines: 1,
                                        overflow: TextOverflow.fade,
                                        style: const TextStyle(
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ),
                                    RichText(
                                      text: TextSpan(
                                        children: [
                                          const TextSpan(
                                            text: "Total tracks: ",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15),
                                          ),
                                          TextSpan(
                                            text:
                                                "${controller.trackModel?.album?.totalTracks ?? 1}",
                                            style: const TextStyle(
                                              color: Color(0xff87CEEB),
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        SizedBox(
                                          height: 20,
                                          width: 20,
                                          child: SvgPicture.asset(
                                            fit: BoxFit.cover,
                                            AssetsHelper.spotifyLogoGreen,
                                          ),
                                        ),
                                        const SizedBox(width: 20),
                                        const SizedBox(
                                            height: 16,
                                            width: 16,
                                            child: Icon(
                                              color: Color(0xff87CEEB),
                                              FontAwesomeIcons
                                                  .arrowUpRightFromSquare,
                                              size: 16,
                                            )),
                                      ],
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                      const SizedBox(
                        height: 20,
                      ),
                      const Text(
                        "Audio Features",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text(
                                "Danceability",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 5),
                              SizedBox(
                                width: Get.width * 0.2,
                                child: LinearProgressIndicator(
                                  value: controller.trackAudioFeaturesModel
                                          ?.danceability ??
                                      0.0,
                                  color: const Color(0xff87CEEB),
                                ),
                              ),
                            ],
                          ),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text(
                                "Energy",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 5),
                              SizedBox(
                                width: Get.width * 0.2,
                                child: LinearProgressIndicator(
                                  value: controller
                                          .trackAudioFeaturesModel?.energy ??
                                      0.0,
                                  color: const Color(0xff87CEEB),
                                ),
                              ),
                            ],
                          ),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text(
                                "Liveness",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 5),
                              SizedBox(
                                width: Get.width * 0.2,
                                child: LinearProgressIndicator(
                                  value: controller
                                          .trackAudioFeaturesModel?.liveness ??
                                      0.0,
                                  color: const Color(0xff87CEEB),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      /*
 
  String? modality;
  double? loudness;
  int? beatsPerBar;

                  */
                      const SizedBox(height: 20),
                      const Text(
                        "Audio Analysis",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 15),
                      Wrap(
                        spacing: 20,
                        runSpacing: 20,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: const Color(0xff1d1d1f),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    "${controller.trackAudioFeaturesModel?.beatsPerBar ?? 3}/4",
                                    style: const TextStyle(
                                        color: Color(0xff87CEEB),
                                        fontSize: 30,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const Text(
                                    "Beats per bar",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: const Color(0xff1d1d1f),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    controller.trackAudioFeaturesModel
                                            ?.modality ??
                                        "Minor",
                                    style: const TextStyle(
                                        color: Color(0xff87CEEB),
                                        fontSize: 30,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const Text("Modality",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: const Color(0xff1d1d1f),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    "${controller.trackAudioFeaturesModel?.loudness ?? -1} DB",
                                    style: const TextStyle(
                                        color: Color(0xff87CEEB),
                                        fontSize: 30,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const Text("Loudness",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      )),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const Text(
                        "External link",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      GestureDetector(
                        onTap: () async {
                          await launchUrl(Uri.parse(
                              controller.trackModel?.trackSpotifyLink ?? ""));
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            gradient: const LinearGradient(
                              colors: [
                                Colors.white,
                                Color(0xffB0E2FF),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: SvgPicture.asset(
                                      AssetsHelper.spotifyLogoGreen),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                const Text(
                                  "Open in Spotify",
                                  style: TextStyle(
                                    color: Color(0xff87CEEB),
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                const SizedBox(
                                  height: 16,
                                  width: 16,
                                  child: Icon(
                                    color: Color(0xff87CEEB),
                                    FontAwesomeIcons.arrowUpRightFromSquare,
                                    size: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          );
        }
      }),
    );
  }
}
