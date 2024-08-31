import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:tmoose/helpers/artist_page_helper.dart';
import 'package:tmoose/helpers/shimmer_widgets.dart';
import 'package:tmoose/helpers/status.dart';
import 'package:tmoose/info_aggregator/info_aggregator_view.dart';
import 'package:tmoose/routes/app_routes.dart';
import 'package:tmoose/user/controllers/user_profile_controller.dart';
import 'package:tmoose/user/helper/something_went_wrong.dart';

class TopArtistsView extends GetView<UserProfileController> {
  const TopArtistsView({super.key});
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      switch (controller.topArtists.value.apiStatus) {
        case ApiStatus.loading:
          return const _Loading();
        case ApiStatus.success:
          return const _Loaded();
        case ApiStatus.error:
          return const SomethingWentWrong();
        case ApiStatus.none:
          return const SizedBox();
      }
    });
  }
}

class _Loading extends StatelessWidget {
  const _Loading();

  @override
  Widget build(BuildContext context) {
    return const Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBoxShimmer(width: 200, height: 16),
            SizedBoxShimmer(width: 100, height: 16),
          ],
        ),
        SizedBox(height: 10),
        SizedBox(
          height: 150, // Adjust height as needed
          child: HorizontalListViewCircleShimmer(
            height: 150,
            width: 150,
          ),
        ),
      ],
    );
  }
}

class _Loaded extends StatelessWidget {
  const _Loaded();

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
              "Top artists",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            GestureDetector(
              onTap: () {
                Get.to(() => const InfoAggregatorView(
                      isUserTopArtists: true,
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
            itemCount:
                (controller.topArtists.value.data?.artists?.length ?? 0) > 10
                    ? 10
                    : (controller.topArtists.value.data?.artists?.length ?? 0),
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  ArtistPageHelper.setUniqueId();
                  Get.toNamed(AppRoutes.artist,
                      arguments:
                          controller.topArtists.value.data?.artists?[index]);
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 100,
                      child: CachedNetworkImage(
                        imageUrl: controller.topArtists.value.data
                                ?.artists?[index].imageUrl ??
                            "",
                        imageBuilder: (context, imageProvider) => Container(
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
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      width: 100,
                      child: Text(
                        "${index + 1}. ${controller.topArtists.value.data?.artists?[index].artistName}",
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
      ],
    );
  }
}
