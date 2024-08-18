import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tmoose/helpers/logger.dart';
import 'package:tmoose/tracks/models/track_model.dart';
import 'package:tmoose/tracks/repository/tracks_repository.dart';

class TrackPageController extends GetxController {
  TrackAudioFeaturesModel? trackAudioFeaturesModel;
  final isDataLoading = true.obs;
  final TracksRepository _tracksRepository = TracksRepository();
  final scrollController = ScrollController();
  TrackModel? trackModel;
  @override
  void onInit() {
    init();
    super.onInit();
  }

  Future<void> init() async {
    isDataLoading(true);
    trackModel = Get.arguments as TrackModel;
    await fetchTrackAudioFeatures(trackId: trackModel?.trackId);
    isDataLoading(false);
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }

  Future fetchTrackAudioFeatures({required String? trackId}) async {
    if (trackId == null) {
      Get.snackbar(
          "Page not found", "Unfortunately requested page is not available");
    } else {
      trackAudioFeaturesModel =
          await _tracksRepository.findTrackAudioAnalysis(trackId: trackId);
    }
    return;
  }

  String getTrackDurtion(String? trackDuration) {
    if (trackDuration == null) return "X:XX";
    int inSeconds = (int.parse(trackDuration) ~/ 1000);
    int numBeforeColon = inSeconds ~/ 60;
    int numAfterColor = inSeconds - numBeforeColon * 60;
    int len = log(numAfterColor) ~/ log(10) + 1;
    if (len == 1) {
      return "$numBeforeColon:0$numAfterColor";
    }
    return "$numBeforeColon:$numAfterColor";
  }
}
