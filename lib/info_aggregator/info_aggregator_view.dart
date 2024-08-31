import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:tmoose/artists/controller/artist_view_controller.dart';
import 'package:tmoose/artists/models/artist_model.dart';
import 'package:tmoose/helpers/assets_helper.dart';
import 'package:tmoose/helpers/colors.dart';
import 'package:tmoose/helpers/shimmer_widgets.dart';
import 'package:tmoose/routes/app_routes.dart';
import 'package:tmoose/tracks/models/track_model.dart';
import 'package:tmoose/user/controllers/user_profile_controller.dart';
import 'package:tmoose/user/helper/enums.dart';
import 'package:url_launcher/url_launcher.dart';

class InfoAggregatorView extends StatelessWidget {
  const InfoAggregatorView({
    super.key,
    this.isArtistTopAlbums,
    this.isArtistTopTracks,
    this.isUserTopArtists,
    this.isUserTopTracks,
    this.artistPageControllerId,
  });
  final bool? isUserTopArtists;
  final bool? isUserTopTracks;
  final bool? isArtistTopTracks;
  final bool? isArtistTopAlbums;
  final String? artistPageControllerId;
  @override
  Widget build(BuildContext context) {
    UserProfileController? userProfileController =
        Get.isRegistered<UserProfileController>()
            ? Get.find<UserProfileController>()
            : null;
    ArtistViewController? artistViewController =
        Get.isRegistered<ArtistViewController>(tag: artistPageControllerId)
            ? Get.find<ArtistViewController>(tag: artistPageControllerId)
            : null;
    if (artistViewController != null) {
      return DefaultTabController(
        length: 2,
        initialIndex: isArtistTopTracks != null && isArtistTopTracks! ? 0 : 1,
        child: Scaffold(
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(70),
            child: Container(
              decoration: const BoxDecoration(
                  gradient: LinearGradient(
                colors: [
                  Color(0xFF1A237E),
                  Color(0xFF000000)
                ], // Deep Blue to Black
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )),
              child: AppBar(
                backgroundColor: Colors.transparent,
                bottom: const TabBar(
                  indicator: BoxDecoration(),
                  labelColor: kAppHeroColor,
                  indicatorColor: kAppHeroColor,
                  tabs: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(bottom: 10),
                      child: Text(
                        "Artist top tracks",
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 10),
                      child: Text(
                        "Artist albums",
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          body: TabBarView(
            children: <Widget>[
              ListView.builder(
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () => Get.toNamed(AppRoutes.track,
                        arguments: artistViewController
                                .artistTopTracksModel?.tracks?[index] ??
                            TrackModel()),
                    child: Padding(
                      padding: const EdgeInsets.only(
                        left: 10,
                        right: 10,
                        top: 20,
                      ),
                      child: Container(
                        height: 70,
                        decoration: BoxDecoration(
                            color: kAppBoxBackgroundColor,
                            borderRadius: BorderRadius.circular(20)),
                        child: Row(
                          children: [
                            Text(
                              "#${index + 1}",
                              style: const TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(width: 10),
                            CachedNetworkImage(
                              width: 70,
                              imageUrl: artistViewController
                                      .artistTopTracksModel
                                      ?.tracks?[index]
                                      .backgroundImage ??
                                  "",
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: Get.width * 0.4,
                                  child: Text(
                                    maxLines: 1,
                                    overflow: TextOverflow.fade,
                                    artistViewController.artistTopTracksModel
                                            ?.tracks?[index].trackName ??
                                        "",
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: kAppHeroColor),
                                  ),
                                ),
                                SizedBox(
                                  width: Get.width * 0.4,
                                  child: Text(
                                    maxLines: 1,
                                    overflow: TextOverflow.fade,
                                    artistViewController.getArtistNames(
                                        artistViewController
                                            .artistTopTracksModel
                                            ?.tracks?[index]
                                            .artists),
                                    style: const TextStyle(color: Colors.grey),
                                  ),
                                ),
                              ],
                            ),
                            const Spacer(),
                            Padding(
                              padding: const EdgeInsets.only(right: 20.0),
                              child: SvgPicture.asset(
                                  height: 20,
                                  width: 20,
                                  AssetsHelper.spotifyLogoGreen),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
                itemCount:
                    artistViewController.artistTopTracksModel?.tracks?.length ??
                        0,
              ),
              ListView.builder(
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () async => await launchUrl(Uri.parse(
                        artistViewController.artistAlbums?.albums?[index]
                                .albumSpotifyLink ??
                            "")),
                    child: Padding(
                      padding: const EdgeInsets.only(
                        left: 10,
                        right: 10,
                        top: 20,
                      ),
                      child: Container(
                        height: 70,
                        decoration: BoxDecoration(
                            color: kAppBoxBackgroundColor,
                            borderRadius: BorderRadius.circular(20)),
                        child: Row(
                          children: [
                            Text(
                              "#${index + 1}",
                              style: const TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(width: 10),
                            CachedNetworkImage(
                              width: 70,
                              imageUrl: artistViewController
                                      .artistAlbums?.albums?[index].imageUrl ??
                                  "",
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: Get.width * 0.4,
                                  child: Text(
                                    maxLines: 1,
                                    overflow: TextOverflow.fade,
                                    artistViewController.artistAlbums
                                            ?.albums?[index].albumName ??
                                        "",
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: kAppHeroColor),
                                  ),
                                ),
                                SizedBox(
                                  width: Get.width * 0.4,
                                  child: Text(
                                    maxLines: 1,
                                    overflow: TextOverflow.fade,
                                    artistViewController.getArtistNames(
                                        artistViewController.artistAlbums
                                            ?.albums?[index].artists),
                                    style: const TextStyle(color: Colors.grey),
                                  ),
                                ),
                              ],
                            ),
                            const Spacer(),
                            const Icon(
                              FontAwesomeIcons.arrowUpRightFromSquare,
                              size: 20,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 20.0),
                              child: SvgPicture.asset(
                                  height: 20,
                                  width: 20,
                                  AssetsHelper.spotifyLogoGreen),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
                itemCount:
                    artistViewController.artistAlbums?.albums?.length ?? 0,
              ),
            ],
          ),
        ),
      );
    } else if (userProfileController != null) {
      return DefaultTabController(
        length: 2,
        initialIndex: isUserTopArtists != null && isUserTopArtists! ? 1 : 0,
        child: Scaffold(
            bottomNavigationBar: ColoredBox(
              color: kAppScaffoldBackgroundColor,
              child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Obx(() {
                    if (!userProfileController.isDataLoading.value) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          GestureDetector(
                            onTap: () async {
                              if (userProfileController
                                      .choosenTimeRange.value !=
                                  TimeRange.short_term) {
                                userProfileController.choosenTimeRange.value =
                                    TimeRange.short_term;
                                await userProfileController.changeTimeOfSearch(
                                  items: 50,
                                );
                              }
                            },
                            child: Text(
                              "4 weeks",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: userProfileController
                                            .choosenTimeRange.value ==
                                        TimeRange.short_term
                                    ? const Color(0xff87CEEB)
                                    : Colors.white,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () async {
                              if (userProfileController
                                      .choosenTimeRange.value !=
                                  TimeRange.medium_term) {
                                userProfileController.choosenTimeRange.value =
                                    TimeRange.medium_term;
                                await userProfileController.changeTimeOfSearch(
                                  items: 50,
                                );
                              }
                            },
                            child: Text(
                              "6 months",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: userProfileController
                                            .choosenTimeRange.value ==
                                        TimeRange.medium_term
                                    ? const Color(0xff87CEEB)
                                    : Colors.white,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () async {
                              if (userProfileController
                                      .choosenTimeRange.value !=
                                  TimeRange.long_term) {
                                userProfileController.choosenTimeRange.value =
                                    TimeRange.long_term;
                                await userProfileController.changeTimeOfSearch(
                                  items: 50,
                                );
                              }
                            },
                            child: Text(
                              "1 year",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: userProfileController
                                            .choosenTimeRange.value ==
                                        TimeRange.long_term
                                    ? const Color(0xff87CEEB)
                                    : Colors.white,
                              ),
                            ),
                          ),
                        ],
                      );
                    } else {
                      return const SizedBox();
                    }
                  })),
            ),
            appBar: PreferredSize(
              preferredSize: const Size.fromHeight(70),
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFF1A237E),
                      Color(0xFF000000)
                    ], // Deep Blue to Black
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: AppBar(
                  backgroundColor: Colors.transparent,
                  bottom: const TabBar(
                    indicator: BoxDecoration(),
                    labelColor: kAppHeroColor,
                    indicatorColor: kAppHeroColor,
                    tabs: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(bottom: 10),
                        child: Text(
                          "User top tracks",
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: 10),
                        child: Text(
                          "User top artists",
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            backgroundColor: kAppScaffoldBackgroundColor,
            body: TabBarView(
              children: <Widget>[
                Obx(
                  () {
                    return userProfileController.isDataLoading.value
                        ? const VerticalListViewShimmer(height: 70)
                        : ListView.builder(
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () => Get.toNamed(AppRoutes.track,
                                    arguments: userProfileController
                                            .topTracks?.tracks?[index] ??
                                        TrackModel()),
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                    left: 10,
                                    right: 10,
                                    top: 20,
                                  ),
                                  child: Container(
                                    height: 70,
                                    decoration: BoxDecoration(
                                        color: kAppBoxBackgroundColor,
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    child: Row(
                                      children: [
                                        Text(
                                          "#${index + 1}",
                                          style: const TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        const SizedBox(width: 10),
                                        CachedNetworkImage(
                                          width: 70,
                                          imageUrl: userProfileController
                                                  .topTracks
                                                  ?.tracks?[index]
                                                  .backgroundImage ??
                                              "",
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
                                              width: Get.width * 0.4,
                                              child: Text(
                                                maxLines: 1,
                                                overflow: TextOverflow.fade,
                                                userProfileController
                                                        .topTracks
                                                        ?.tracks?[index]
                                                        .trackName ??
                                                    "",
                                                style: const TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                    color: kAppHeroColor),
                                              ),
                                            ),
                                            SizedBox(
                                              width: Get.width * 0.4,
                                              child: Text(
                                                maxLines: 1,
                                                overflow: TextOverflow.fade,
                                                userProfileController
                                                    .getArtistNames(
                                                        userProfileController
                                                            .topTracks
                                                            ?.tracks?[index]
                                                            .artists),
                                                style: const TextStyle(
                                                    color: Colors.grey),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const Spacer(),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              right: 20.0),
                                          child: SvgPicture.asset(
                                              height: 20,
                                              width: 20,
                                              AssetsHelper.spotifyLogoGreen),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                            itemCount: userProfileController
                                    .topTracks?.tracks?.length ??
                                0,
                          );
                  },
                ),
                Obx(() {
                  return userProfileController.isDataLoading.value
                      ? const VerticalListViewShimmer(height: 70)
                      : ListView.builder(
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () => Get.toNamed(AppRoutes.artist,
                                  arguments: userProfileController
                                          .topArtists?.artists?[index] ??
                                      ArtistModel()),
                              child: Padding(
                                padding: const EdgeInsets.only(
                                  left: 10,
                                  right: 10,
                                  top: 20,
                                ),
                                child: Container(
                                  height: 70,
                                  decoration: BoxDecoration(
                                      color: kAppBoxBackgroundColor,
                                      borderRadius: BorderRadius.circular(20)),
                                  child: Row(
                                    children: [
                                      Text(
                                        "#${index + 1}",
                                        style: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(width: 10),
                                      CachedNetworkImage(
                                        width: 70,
                                        imageUrl: userProfileController
                                                .topArtists
                                                ?.artists?[index]
                                                .imageUrl ??
                                            "",
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      SizedBox(
                                        width: Get.width * 0.4,
                                        child: Text(
                                          maxLines: 1,
                                          overflow: TextOverflow.fade,
                                          userProfileController
                                                  .topArtists
                                                  ?.artists?[index]
                                                  .artistName ??
                                              "",
                                          style: const TextStyle(
                                              color: Colors.grey),
                                        ),
                                      ),
                                      const Spacer(),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(right: 20.0),
                                        child: SvgPicture.asset(
                                            height: 20,
                                            width: 20,
                                            AssetsHelper.spotifyLogoGreen),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                          itemCount: userProfileController
                                  .topArtists?.artists?.length ??
                              0,
                        );
                })
              ],
            )),
      );
    } else {
      return const Scaffold(
        body: Center(
          child: Text(
            "No data is available to show.",
            style: TextStyle(fontSize: 30),
          ),
        ),
      );
    }
  }
}
