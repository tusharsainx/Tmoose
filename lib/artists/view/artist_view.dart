import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:tmoose/artists/controller/artist_view_controller.dart';
import 'package:tmoose/artists/models/artist_model.dart';
import 'package:tmoose/helpers/assets_helper.dart';
import 'package:tmoose/helpers/shimmer_widgets.dart';
import 'package:tmoose/routes/app_routes.dart';
import 'package:tmoose/tracks/models/track_model.dart';
import 'package:tmoose/tracks/view/track_artist_view_shimmer.dart';
import 'package:url_launcher/url_launcher.dart';

class ArtistPage extends GetView<ArtistViewController> {
  const ArtistPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Obx(() {
        if (controller.isDataLoading.value) {
          return const TrackArtistViewShimmer();
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
                  background: CachedNetworkImage(
                    imageUrl: controller.artistModel?.imageUrl ?? "",
                    errorWidget: (context, url, error) =>
                        FullDeviceWidthShimmer(
                      height: Get.height * 0.5,
                    ),
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
              SliverPadding(
                padding: const EdgeInsets.all(20),
                sliver: SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      Text(
                        controller.artistModel?.artistName ?? "",
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
                                    "${controller.artistModel?.popularityOutOf100 ?? 0}",
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
                                    controller.artistFollowers(
                                        controller.artistModel?.followers ??
                                            ""),
                                    style: const TextStyle(
                                      color: Color(0xff87CEEB),
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const Text("followers",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      const Text("Genres",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: [
                          for (int i = 0;
                              i < (controller.artistModel?.genres ?? []).length;
                              i++) ...[
                            Container(
                              decoration: BoxDecoration(
                                  color: const Color(0xff1d1d1f),
                                  borderRadius: BorderRadius.circular(15)),
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Text(
                                  controller.artistModel?.genres?[i] ?? "",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        "Top tracks",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 15),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          for (int i = 0;
                              i <
                                      (controller.artistTopTracksModel
                                                  ?.tracks ??
                                              [])
                                          .length &&
                                  i < 2;
                              i++) ...[
                            GestureDetector(
                              onTap: () async {
                                await Get.toNamed(
                                  AppRoutes.track,
                                  arguments: controller
                                          .artistTopTracksModel?.tracks?[i] ??
                                      TrackModel(),
                                );
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: const Color(0xff1d1d1f),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(20, 10, 10, 10),
                                  child: Row(
                                    children: [
                                      Text(
                                        "${i + 1}",
                                        style: const TextStyle(
                                            color: Color(0xff87CEEB),
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            width: Get.width * 0.60,
                                            child: Text(
                                              maxLines: 1,
                                              overflow: TextOverflow.fade,
                                              controller.artistTopTracksModel
                                                      ?.tracks?[i].trackName ??
                                                  "",
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 18),
                                            ),
                                          ),
                                          SizedBox(
                                            width: Get.width * 0.60,
                                            child: Text(
                                              maxLines: 1,
                                              overflow: TextOverflow.fade,
                                              controller.getArtistNames(
                                                  controller
                                                      .artistTopTracksModel
                                                      ?.tracks?[i]
                                                      .artists),
                                              style: const TextStyle(
                                                  color: Colors.grey),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const Spacer(),
                                      CachedNetworkImage(
                                        imageUrl: controller
                                                .artistTopTracksModel
                                                ?.tracks?[i]
                                                .backgroundImage ??
                                            "",
                                        errorWidget: (context, url, error) {
                                          return const SizedBoxShimmer(
                                              width: 50, height: 50);
                                        },
                                        imageBuilder: (context, imageProvider) {
                                          return Container(
                                            height: 50,
                                            width: 50,
                                            decoration: BoxDecoration(
                                                image: DecorationImage(
                                              image: imageProvider,
                                              fit: BoxFit.cover,
                                            )),
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                          ],
                        ],
                      ),
                      const Text(
                        "View more >",
                        textAlign: TextAlign.end,
                        style: TextStyle(
                          color: Color(0xff87CEEB),
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        "Top albums",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 15),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          for (int i = 0;
                              i <
                                      (controller.artistAlbums?.albums ?? [])
                                          .length &&
                                  i < 2;
                              i++) ...[
                            GestureDetector(
                              onTap: () async {
                                await launchUrl(Uri.parse(controller
                                        .artistAlbums
                                        ?.albums?[i]
                                        .albumSpotifyLink ??
                                    ""));
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: const Color(0xff1d1d1f),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(20, 10, 10, 10),
                                  child: Row(
                                    children: [
                                      Text(
                                        "${i + 1}",
                                        style: const TextStyle(
                                            color: Color(0xff87CEEB),
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            width: Get.width * 0.60,
                                            child: Text(
                                              maxLines: 1,
                                              overflow: TextOverflow.fade,
                                              controller.artistAlbums
                                                      ?.albums?[i].albumName ??
                                                  "",
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 18),
                                            ),
                                          ),
                                          SizedBox(
                                            width: Get.width * 0.60,
                                            child: Text(
                                              maxLines: 1,
                                              overflow: TextOverflow.fade,
                                              controller.getArtistNames(
                                                  controller.artistAlbums
                                                      ?.albums?[i].artists),
                                              style: const TextStyle(
                                                  color: Colors.grey),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const Spacer(),
                                      CachedNetworkImage(
                                        imageUrl: controller.artistAlbums
                                                ?.albums?[i].imageUrl ??
                                            "",
                                        errorWidget: (context, url, error) {
                                          return const SizedBoxShimmer(
                                              width: 50, height: 50);
                                        },
                                        imageBuilder: (context, imageProvider) {
                                          return Container(
                                            height: 50,
                                            width: 50,
                                            decoration: BoxDecoration(
                                                image: DecorationImage(
                                              image: imageProvider,
                                              fit: BoxFit.cover,
                                            )),
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                          ],
                        ],
                      ),
                      const Text(
                        "View more >",
                        textAlign: TextAlign.end,
                        style: TextStyle(
                          color: Color(0xff87CEEB),
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        "Related artists",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      SizedBox(
                        height: 150, // Adjust height as needed
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: controller
                                  .artistRelatedArtistsModel?.artists?.length ??
                              0,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () async {
                                final artistModel = controller
                                        .artistRelatedArtistsModel
                                        ?.artists?[index] ??
                                    ArtistModel();
                                await Get.offNamed(AppRoutes.artist,
                                    arguments: artistModel,
                                    preventDuplicates: false);
                              },
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CachedNetworkImage(
                                    imageUrl: controller
                                            .artistRelatedArtistsModel
                                            ?.artists?[index]
                                            .imageUrl ??
                                        "",
                                    imageBuilder: (context, imageProvider) =>
                                        Container(
                                      height: 100,
                                      width: 100,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: const Color(0xff87CEEB),
                                        ),
                                        shape: BoxShape.circle,
                                        image: DecorationImage(
                                          image: imageProvider,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  SizedBox(
                                    width: 100,
                                    child: Text(
                                      "${index + 1}. ${controller.artistRelatedArtistsModel?.artists?[index].artistName}",
                                      style: const TextStyle(fontSize: 14),
                                      maxLines: 1,
                                      overflow: TextOverflow.fade,
                                    ),
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
                      const SizedBox(height: 20),
                      const Text(
                        "External link",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      GestureDetector(
                        onTap: () async {
                          await launchUrl(Uri.parse(
                              controller.artistModel?.artistSpotifyLink ?? ""));
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
