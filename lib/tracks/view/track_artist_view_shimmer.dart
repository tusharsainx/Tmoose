import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tmoose/helpers/shimmer_widgets.dart';

class TrackArtistViewShimmer extends StatelessWidget {
  const TrackArtistViewShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FullDeviceWidthShimmer(
            height: Get.height * 0.5,
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBoxShimmer(width: Get.width * 0.4, height: 100),
              const SizedBox(
                width: 10,
              ),
              SizedBoxShimmer(width: Get.width * 0.4, height: 100),
            ],
          ),
          const SizedBox(height: 20),
          const FullDeviceWidthShimmer(height: 200),
        ],
      ),
    );
  }
}
