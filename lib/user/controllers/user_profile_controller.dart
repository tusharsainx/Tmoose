import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tmoose/helpers/status.dart';
import 'package:tmoose/user/helper/enums.dart';
import 'package:tmoose/artists/models/artist_model.dart';
import 'package:tmoose/tracks/models/track_model.dart';
import 'package:tmoose/user/models/user_profile_model.dart';
import 'package:tmoose/user/repository/user_profile_repository.dart';

class UserProfileController extends GetxController {
  final UserProfileRepository _userProfileRepository = UserProfileRepository();
  final isAnySongCurrentlyPlaying = false.obs;
  final choosenTimeRange = TimeRange.short_term.obs;
  final scrollController = ScrollController();
  final isScrolledSpecificHeight = false.obs;
  final topArtists = Status<UserTopArtistsModel>.loading().obs;
  final topTracks = Status<UserTopTracksModel>.loading().obs;
  final userProfileModel = Status<UserProfileModel>.loading().obs;
  final currentPlayingTrackModel =
      Status<CurrentPlayingTrackModel>.loading().obs;
  final recentlyPlayedTracksModel =
      Status<RecentlyPlayedTracksModel>.loading().obs;
  @override
  void onInit() {
    scrollController.addListener(() {
      if (scrollController.hasClients) {
        double offset = scrollController.offset;
        if (offset > 200) {
          isScrolledSpecificHeight.value = true;
        } else {
          isScrolledSpecificHeight.value = false;
        }
      }
    });
    init();
    super.onInit();
  }

  Future<void> init() async {
    initTracksAndArtists(
      timeRange: choosenTimeRange.value.name,
    );
    fetchUserProfile();
    fetchRecentlyPlayedTracks();
    fetchCurrentlyPlayingTrack();
  }

  void changeTimeOfSearch({required int items}) {
    isScrolledSpecificHeight(false);
    initTracksAndArtists(
      timeRange: choosenTimeRange.value.name,
    );
  }

  void initTracksAndArtists({
    required String timeRange,
  }) {
    fetchTopArtists(
      timeRange: timeRange,
    );
    fetchTopTracks(
      timeRange: timeRange,
    );
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }

  Future fetchTopArtists({required String timeRange}) async {
    topArtists.value = Status.loading();
    topArtists.value = await _userProfileRepository.fetchTopArtists(
      timeRange: timeRange,
      items: 50,
    );
  }

  Future fetchTopTracks({required String timeRange}) async {
    topTracks.value = Status.loading();
    topTracks.value = await _userProfileRepository.fetchTopTracks(
      timeRange: timeRange,
      items: 50,
    );
  }

  Future fetchRecentlyPlayedTracks() async {
    recentlyPlayedTracksModel.value = Status.loading();
    recentlyPlayedTracksModel.value =
        await _userProfileRepository.fetchRecentlyPlayedTracks(limit: 50);
  }

  Future fetchCurrentlyPlayingTrack() async {
    currentPlayingTrackModel.value = Status.loading();
    currentPlayingTrackModel.value =
        await _userProfileRepository.fetchCurrentlyPlayingTrack();
    if (currentPlayingTrackModel.value.data?.album == null &&
        currentPlayingTrackModel.value.data?.artists == null &&
        currentPlayingTrackModel.value.data?.backgroundImage == null &&
        currentPlayingTrackModel.value.data?.trackName == null) {
      isAnySongCurrentlyPlaying.value = false;
    } else {
      isAnySongCurrentlyPlaying.value = true;
    }
  }

  Future fetchUserProfile() async {
    userProfileModel.value = Status.loading();
    userProfileModel.value = await _userProfileRepository.fetchUserProfile();
  }

  String songAgoTime(String timestamp) {
    if (timestamp.isEmpty) return "";
    DateTime parsedDate = DateTime.parse(timestamp);
    DateTime now = DateTime.now();
    Duration diff = now.difference(parsedDate);
    int years = (diff.inDays) ~/ 365;
    int months = (diff.inDays) ~/ 30;
    int days = diff.inDays;
    int hours = diff.inHours;
    int minutes = diff.inMinutes;

    if (years > 0) {
      return "${years}years";
    } else if (months > 0) {
      return "${months}months";
    } else if (days > 0) {
      return "${days}d";
    } else if (hours > 0) {
      return "${hours}h";
    } else if (minutes > 0) {
      return "${minutes}m";
    } else {
      return "Just now";
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

  String userFollowers(String? followers) {
    if (followers == null) return "0";
    if (followers.length <= 4) return followers;
    if (followers.length == 5) return "${followers.substring(0, 2)}K";
    if (followers.length == 6) return "${followers.substring(0, 3)}K";
    if (followers.length == 7) return "${followers.substring(0, 1)}M";
    if (followers.length == 8) return "${followers.substring(0, 2)}M";
    if (followers.length == 9) return "${followers.substring(0, 3)}M";
    if (followers.length == 10) return "${followers.substring(0, 1)}B";
    if (followers.length == 11) return "${followers.substring(0, 2)}B";
    if (followers.length == 12) return "${followers.substring(0, 3)}B";
    return "~";
  }
}
