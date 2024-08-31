import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class HorizontalListViewBoxShimmer extends StatelessWidget {
  final double height;
  final double width;
  const HorizontalListViewBoxShimmer({
    super.key,
    required this.height,
    required this.width,
  });
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: ListView.separated(
          separatorBuilder: (context, index) => const SizedBox(width: 5),
          scrollDirection: Axis.horizontal,
          itemCount: 10,
          itemBuilder: (context, index) {
            return Shimmer.fromColors(
              baseColor: Colors.black,
              highlightColor: const Color(0xff1d1d1f),
              child: Container(
                height: height,
                width: width,
                decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(20)),
              ),
            );
          }),
    );
  }
}

class HorizontalListViewCircleShimmer extends StatelessWidget {
  final double height;
  final double width;
  const HorizontalListViewCircleShimmer({
    super.key,
    required this.height,
    required this.width,
  });
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: ListView.separated(
          separatorBuilder: (context, index) => const SizedBox(width: 5),
          scrollDirection: Axis.horizontal,
          itemCount: 10,
          itemBuilder: (context, index) {
            return Shimmer.fromColors(
              baseColor: Colors.black,
              highlightColor: const Color(0xff1d1d1f),
              child: Container(
                height: height,
                width: width,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.black,
                ),
              ),
            );
          }),
    );
  }
}

class VerticalListViewShimmer extends StatelessWidget {
  final double height;

  const VerticalListViewShimmer({
    super.key,
    required this.height,
  });
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: ListView.separated(
          separatorBuilder: (context, index) => const SizedBox(height: 10),
          itemCount: 10,
          itemBuilder: (context, index) {
            return Shimmer.fromColors(
              baseColor: Colors.black,
              highlightColor: const Color(0xff1d1d1f),
              child: Container(
                height: height,
                decoration: const BoxDecoration(
                  color: Colors.black,
                ),
              ),
            );
          }),
    );
  }
}

class FullDeviceWidthShimmer extends StatelessWidget {
  final double height;
  const FullDeviceWidthShimmer({
    super.key,
    required this.height,
  });
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.black,
      highlightColor: const Color(0xff1d1d1f),
      child: Container(
        height: height,
        width: double.infinity,
        decoration: BoxDecoration(
            color: Colors.black, borderRadius: BorderRadius.circular(20)),
      ),
    );
  }
}

class SizedBoxShimmer extends StatelessWidget {
  final double height;
  final double width;
  const SizedBoxShimmer({
    super.key,
    required this.width,
    required this.height,
  });
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.black,
      highlightColor: const Color(0xff1d1d1f),
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
            color: Colors.black, borderRadius: BorderRadius.circular(20)),
      ),
    );
  }
}
