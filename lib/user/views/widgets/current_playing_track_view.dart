import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tmoose/user/controllers/user_profile_controller.dart';

class CurrentPlayingTrackView extends StatelessWidget {
  const CurrentPlayingTrackView({super.key});

  @override
  Widget build(BuildContext context) {
    final UserProfileController controller = Get.find<UserProfileController>();
    if (controller.currentPlayingTrackModel?.backgroundImage != null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Currently playing",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              SizedBox(
                height: 50,
                child: CachedNetworkImage(
                  imageUrl:
                      controller.currentPlayingTrackModel?.backgroundImage ??
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
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    controller.currentPlayingTrackModel?.trackName ?? "",
                    maxLines: 1,
                    overflow: TextOverflow.fade,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(
                    width: Get.width * 0.7,
                    child: Text(
                      controller.getArtistNames(
                          controller.currentPlayingTrackModel?.artists),
                      maxLines: 1,
                      overflow: TextOverflow.fade,
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ),
                ],
              )
            ],
          ),
        ],
      );
    } else {
      return const SizedBox();
    }
  }
}
