import 'dart:async';
import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tmoose/artists/models/artist_model.dart';
import 'package:tmoose/artists/repository/artist_repository.dart';
import 'package:tmoose/helpers/status.dart';
import 'package:tmoose/tracks/models/track_model.dart';
import 'package:tmoose/tracks/repository/tracks_repository.dart';

class TrackPageController extends GetxController with WidgetsBindingObserver {
  Rx<Status<TrackAudioFeaturesModel>> trackAudioFeaturesModel =
      Status<TrackAudioFeaturesModel>.loading().obs;
  final TracksRepository _tracksRepository = TracksRepository();
  final ArtistsRepository _artistsRepository = ArtistsRepository();
  final isAudioLoading = false.obs;
  final scrollController = ScrollController();
  final isSongPlayed = false.obs;
  final audioPlayer = AudioPlayer();
  final duration = Duration.zero.obs;
  final position = Duration.zero.obs;
  Rx<Status<List<ArtistModel>>> artistModels =
      Status<List<ArtistModel>>.loading().obs;
  StreamSubscription? onDurationChanged;
  StreamSubscription? onPositionChanged;
  StreamSubscription? onPlayerComplete;
  dynamic trackModel;
  @override
  void onInit() {
    init();

    super.onInit();
  }

  void fetchArtistData() async {
    artistModels.value = Status.loading();
    List<ArtistModel> artistsCompleteList = [];
    List<ArtistModelBase> artists = trackModel.artists ?? [];
    for (int i = 0; i < artists.length && i < 5; i++) {
      await _artistsRepository
          .getArtistInfo(artistId: artists[i].artistId ?? "")
          .then((value) {
        if (value.imageUrl != null && (value.imageUrl ?? "").isNotEmpty) {
          artistsCompleteList.add(value);
        }
      });
    }
    artistModels.value = Status.success(
      data: artistsCompleteList,
    );
    return;
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        break;
      case AppLifecycleState.inactive:
        break;
      case AppLifecycleState.paused:
        break;
      case AppLifecycleState.detached:
        break;
      case AppLifecycleState.hidden:
        globalPause();
        break;
    }
  }

  void init() {
    WidgetsBinding.instance.addObserver(this);
    if (Get.arguments is CurrentPlayingTrackModel) {
      trackModel = Get.arguments as CurrentPlayingTrackModel;
    } else {
      trackModel = Get.arguments as TrackModel;
    }
    fetchTrackAudioFeatures(trackId: trackModel?.trackId);
    fetchArtistData();
    onDurationChanged = audioPlayer.onDurationChanged.listen((event) {
      duration.value = event;
    });
    onPositionChanged = audioPlayer.onPositionChanged.listen((event) {
      position.value = event;
    });
    onPlayerComplete = audioPlayer.onPlayerComplete.listen((event) {
      position.value = Duration.zero;
      isAudioLoading.value = false;
      isSongPlayed.value = false;
    });
  }

  @override
  void onClose() {
    scrollController.dispose();
    onPlayerComplete?.cancel();
    onDurationChanged?.cancel();
    onPositionChanged?.cancel();
    audioPlayer.dispose();
    super.onClose();
  }

  Future<void> seek(double value) async {
    await audioPlayer.seek(
      Duration(
        seconds: value.toInt(),
      ),
    );
  }

  void globalPause() {
    isSongPlayed(false);
    audioPlayer.pause();
  }

  Future<void> handleAudioPlayPause() async {
    if (isSongPlayed.value == true) {
      isSongPlayed.value = false;
      audioPlayer.pause();
    } else {
      isSongPlayed.value = true;
      isAudioLoading.value = true;
      await audioPlayer.play(UrlSource(trackModel?.previewUrl ?? ""));
      isAudioLoading.value = false;
    }
  }

  String getArtistNames(List<ArtistModelBase>? artists) {
    if (artists == null) return "";
    String singers = "";
    for (ArtistModelBase artist in artists) {
      singers += (artist.artistName ?? "");
      singers += ", ";
    }
    return singers.substring(0, singers.length - 2);
  }

  Future fetchTrackAudioFeatures({required String? trackId}) async {
    trackAudioFeaturesModel.value = Status.loading();
    if (trackId == null) {
      Get.snackbar(
          "Page not found", "Unfortunately requested page is not available");
    } else {
      trackAudioFeaturesModel.value =
          await _tracksRepository.findTrackAudioAnalysis(trackId: trackId);
    }
    return;
  }

  String getTrackDurtion(String? trackDuration) {
    if (trackDuration == null) return "X:XX";
    int inSeconds = (int.parse(trackDuration) ~/ 1000);
    int numBeforeColon = inSeconds ~/ 60;
    int numAfterColor = inSeconds - numBeforeColon * 60;
    if (numAfterColor == 0) {
      return "$numBeforeColon:00";
    }
    int len = log(numAfterColor) ~/ log(10) + 1;
    if (len == 1) {
      return "$numBeforeColon:0$numAfterColor";
    }
    return "$numBeforeColon:$numAfterColor";
  }
}
