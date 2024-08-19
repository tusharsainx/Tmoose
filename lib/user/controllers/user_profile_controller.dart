import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tmoose/helpers/logger.dart';
import 'package:tmoose/user/helper/enums.dart';
import 'package:tmoose/artists/models/artist_model.dart';
import 'package:tmoose/tracks/models/track_model.dart';
import 'package:tmoose/user/models/user_profile_model.dart';
import 'package:tmoose/user/repository/user_profile_repository.dart';

class UserProfileController extends GetxController {
  final UserProfileRepository _userProfileRepository = UserProfileRepository();
  final isDataLoading = true.obs;
  final isAnySongCurrentlyPlaying = false.obs;
  final choosenTimeRange = TimeRange.short_term.obs;
  final scrollController = ScrollController();
  final isScrolledSpecificHeight = false.obs;
  UserTopArtistsModel? topArtists;
  UserTopTracksModel? topTracks;
  UserProfileModel? userProfileModel;
  CurrentPlayingTrackModel? currentPlayingTrackModel;
  RecentlyPlayedTracksModel? recentlyPlayedTracksModel;
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
    isDataLoading(true);
    await initTracksAndArtists(
      timeRange: choosenTimeRange.value.name,
      items: 10,
    );
    await fetchUserProfile();
    await fetchRecentlyPlayedTracks(
      limit: 20,
    );
    await fetchCurrentlyPlayingTrack();
    isDataLoading(false);
  }

  Future<void> changeTimeOfSearch({required int items}) async {
    isDataLoading(true);
    isScrolledSpecificHeight(false);
    await initTracksAndArtists(
      timeRange: choosenTimeRange.value.name,
      items: items,
    );
    isDataLoading(false);
  }

  Future<void> initTracksAndArtists(
      {required String timeRange, required int items}) async {
    await fetchTopArtists(
      timeRange: timeRange,
      items: items,
    );
    await fetchTopTracks(
      timeRange: timeRange,
      items: items,
    );
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }

  Future fetchTopArtists(
      {required String timeRange, required int items}) async {
    topArtists = await _userProfileRepository.fetchTopArtists(
        timeRange: timeRange, items: items);
    logger.i("top artists: $topArtists");
  }

  Future fetchTopTracks({required String timeRange, required int items}) async {
    topTracks = await _userProfileRepository.fetchTopTracks(
        timeRange: timeRange, items: items);
    logger.i("top tracks: $topTracks");
  }

  Future fetchRecentlyPlayedTracks({required int limit}) async {
    recentlyPlayedTracksModel =
        await _userProfileRepository.fetchRecentlyPlayedTracks(limit: limit);
    logger.i("recently played tracks: ${recentlyPlayedTracksModel?.tracks}");
  }

  Future fetchCurrentlyPlayingTrack() async {
    currentPlayingTrackModel =
        await _userProfileRepository.fetchCurrentlyPlayingTrack();
    if (currentPlayingTrackModel?.album == null &&
        currentPlayingTrackModel?.artists == null &&
        currentPlayingTrackModel?.backgroundImage == null &&
        currentPlayingTrackModel?.trackName == null) {
      isAnySongCurrentlyPlaying.value = false;
    } else {
      isAnySongCurrentlyPlaying.value = true;
    }
    logger.i(
        "current playing model: ${currentPlayingTrackModel?.album?.albumName}");
  }

  Future fetchUserProfile() async {
    userProfileModel = await _userProfileRepository.fetchUserProfile();
    logger.i("user profile: ${userProfileModel?.name}");
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
