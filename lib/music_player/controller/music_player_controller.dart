import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tmoose/artists/models/artist_model.dart';
import 'package:tmoose/helpers/status.dart';
import 'package:tmoose/music_player/model/music_player_model.dart';
import 'package:tmoose/tracks/models/track_model.dart';

class MusicPlayerController extends GetxController {
  //list of song previews
  // add to playlist and import playlist to spotify,
  Rx<Status<PlayableTracksList>> playableTracks =
      Status<PlayableTracksList>.loading().obs;
  PageController? pageController;
  bool isPageChangedBySwiping = false;
  bool isPageChangedByButtonPress = false;
  final isSongPlaying = false.obs;
  final isAudioLoading = false.obs;
  RxInt trackNo = 0.obs;
  AudioPlayer? musicPlayer;
  StreamSubscription? onDurationChanged;
  StreamSubscription? onPositionChanged;
  StreamSubscription? onPlayerCompleted;
  final duration = Duration.zero.obs;
  final position = Duration.zero.obs;
  final isTracksEmptyOrNull = false.obs;
  @override
  void onInit() {
    init();
    super.onInit();
  }

  void init() {
    playableTracks.value = Status.loading();
    pageController = PageController();
    musicPlayer = AudioPlayer();
    onDurationChanged = musicPlayer!.onDurationChanged.listen((value) {
      duration.value = value;
    });
    onPlayerCompleted = musicPlayer!.onPlayerComplete.listen((data) {
      nextSong();
    });
    onPositionChanged = musicPlayer!.onPositionChanged.listen((data) {
      position.value = data;
    });
    final tracksToPlay = Get.arguments;
    if (tracksToPlay.tracks == null || tracksToPlay.tracks.isEmpty) {
      isTracksEmptyOrNull(true);
    } else {
      playableTracks.value = Status.success(
        data: PlayableTracksList.fromTracks(
          tracksToPlay.tracks,
        ),
      );
      playPause();
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

  void previousSong() {
    if (trackNo.value > 0) {
      isSongPlaying(false);
      trackNo.value = trackNo.value - 1;
      if (isPageChangedBySwiping == false) {
        isPageChangedByButtonPress = true;
      }
      if (isPageChangedByButtonPress) {
        pageController?.animateToPage(trackNo.value,
            duration: const Duration(
              milliseconds: 300,
            ),
            curve: Curves.easeInOut);
      }
      musicPlayer!.seek(Duration.zero);
      playPause();
    }
  }

  void playPause() async {
    if (isSongPlaying.value) {
      isSongPlaying.value = false;
      musicPlayer!.pause();
    } else {
      isSongPlaying.value = true;
      isAudioLoading(true);
      await musicPlayer!.play(UrlSource(
          playableTracks.value.data!.tracks![trackNo.value].previewUrl!));
      isAudioLoading(false);
    }
  }

  void pauseMusic() {
    isSongPlaying(false);
    musicPlayer!.pause();
  }

  String getPositionValue(Duration value) {
    if (value.inSeconds.toDouble() < 10.0) {
      return "0:0${value.inSeconds}";
    }
    return "0:${value.inSeconds}";
  }

  void seek(double value) async {
    musicPlayer!.seek(Duration(seconds: value.toInt()));
  }

  void nextSong() {
    if (trackNo.value <
        (playableTracks.value.data!.tracks ?? [TrackModel()]).length - 1) {
      isSongPlaying.value = false;
      trackNo.value = trackNo.value + 1;
      if (isPageChangedBySwiping == false) {
        isPageChangedByButtonPress = true;
      }
      if (isPageChangedByButtonPress) {
        pageController?.animateToPage(
          trackNo.value,
          duration: const Duration(microseconds: 300),
          curve: Curves.easeInOut,
        );
      }
      musicPlayer!.seek(Duration.zero);
      playPause();
    }
  }

  @override
  void onClose() {
    pageController?.dispose();
    musicPlayer?.dispose();
    onDurationChanged?.cancel();
    onPositionChanged?.cancel();
    onPlayerCompleted?.cancel();
    super.onClose();
  }
}
