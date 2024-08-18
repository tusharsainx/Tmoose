import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tmoose/tracks/controller/tracks_view_controller.dart';

class TrackPage extends GetView<TrackPageController> {
  const TrackPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: CustomScrollView(
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                style: TextStyle(fontWeight: FontWeight.bold),
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
                                    controller.trackModel?.trackDuration ?? ""),
                                style: const TextStyle(
                                  color: Color(0xff87CEEB),
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const Text("track length",
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
