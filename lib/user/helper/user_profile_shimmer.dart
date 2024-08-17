import 'package:flutter/material.dart';
import 'package:tmoose/helpers/shimmer_widgets.dart';

class UserProfileShimmer extends StatelessWidget {
  const UserProfileShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    // Changed Object to BuildContext
    return const Padding(
      padding: EdgeInsets.all(20.0),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            FullDeviceWidthShimmer(height: 200),
            SizedBox(height: 20),
            HorizontalListViewCircleShimmer(height: 100, width: 100),
            SizedBox(height: 20),
            FullDeviceWidthShimmer(height: 50),
            SizedBox(height: 20),
            HorizontalListViewBoxShimmer(height: 100, width: 70),
            SizedBox(height: 20),
            FullDeviceWidthShimmer(height: 50),
            SizedBox(height: 20),
            HorizontalListViewBoxShimmer(height: 100, width: 70),
          ],
        ),
      ),
    );
  }
}
