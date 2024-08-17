import 'package:tmoose/helpers/logger.dart';
import 'package:tmoose/network_requester/apis.dart';
import 'package:tmoose/network_requester/network_request_helper.dart';
import 'package:tmoose/user/models/artist_model.dart';
import 'package:tmoose/user/models/track_model.dart';
import 'package:tmoose/user/models/user_profile_model.dart';

class UserProfileRepository {
  final NetworkRequester _networkRequester = NetworkRequester();
  Future<UserProfileModel> fetchUserProfile() async {
    try {
      final userProfileResponse = await _networkRequester.request(
        Api.baseUrl,
        Api.userProfile,
        MethodType.GET.name,
        null,
        null,
      );
      return UserProfileModel.fromJson(userProfileResponse);
    } catch (e) {
      return UserProfileModel();
    }
  }

  Future<List<ArtistModel>?> fetchTopArtists({
    required String timeRange,
    required int items,
  }) async {
    try {
      final topArtistsResponse = await _networkRequester.request(
        Api.baseUrl,
        "${Api.topArtists}?time_range=$timeRange&limit=$items",
        MethodType.GET.name,
        null,
        null,
      );
      TopArtistsModel.instance.fromJson(topArtistsResponse);
      return TopArtistsModel.instance.returnArtists;
    } catch (e) {
      return TopArtistsModel.instance.returnArtists;
    }
  }

  Future<List<TrackModel>?> fetchTopTracks({
    required String timeRange,
    required int items,
  }) async {
    try {
      final topTracksResponse = await _networkRequester.request(
        Api.baseUrl,
        "${Api.topTracks}?time_range=$timeRange&limit=$items",
        MethodType.GET.name,
        null,
        null,
      );
      TopTracksModel.instance.fromJson(topTracksResponse);
      return TopTracksModel.instance.returnTracks;
    } catch (e) {
      return TopTracksModel.instance.returnTracks;
    }
  }

  Future<CurrentPlayingTrackModel> fetchCurrentlyPlayingTrack() async {
    try {
      final currentPlayingTrackResponse = await _networkRequester.request(
        Api.baseUrl,
        Api.currentPlayingTracks,
        MethodType.GET.name,
        null,
        null,
      );
      return CurrentPlayingTrackModel.fromJson(currentPlayingTrackResponse);
    } catch (e) {
      return CurrentPlayingTrackModel();
    }
  }

  Future<RecentlyPlayedTracksModel> fetchRecentlyPlayedTracks(
      {required int limit}) async {
    try {
      final recentlyPlayedTracksResponse = await _networkRequester.request(
        Api.baseUrl,
        "${Api.recentlyPlayedTracks}?limit=$limit",
        MethodType.GET.name,
        null,
        null,
      );
      return RecentlyPlayedTracksModel.fromJson(recentlyPlayedTracksResponse);
    } catch (e) {
      return RecentlyPlayedTracksModel();
    }
  }
}
