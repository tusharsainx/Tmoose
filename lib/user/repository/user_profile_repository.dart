import 'package:tmoose/helpers/status.dart';
import 'package:tmoose/network_requester/apis.dart';
import 'package:tmoose/network_requester/network_request_helper.dart';
import 'package:tmoose/artists/models/artist_model.dart';
import 'package:tmoose/tracks/models/track_model.dart';
import 'package:tmoose/user/models/user_profile_model.dart';

class UserProfileRepository {
  final NetworkRequester _networkRequester = NetworkRequester();
  Future<Status<UserProfileModel>> fetchUserProfile() async {
    try {
      final userProfileResponse = await _networkRequester.request(
        Api.baseUrl,
        Api.userProfile,
        MethodType.GET.name,
        null,
        null,
      );
      return Status.success(
          data: UserProfileModel.fromJson(userProfileResponse));
    } catch (e) {
      return Status.error(exception: e.toString());
    }
  }

  Future<Status<UserTopArtistsModel>> fetchTopArtists({
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

      return Status.success(
          data: UserTopArtistsModel.fromJson(topArtistsResponse));
    } catch (e) {
      return Status.error(exception: e.toString());
    }
  }

  Future<Status<UserTopTracksModel>> fetchTopTracks({
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
      return Status.success(
          data: UserTopTracksModel.fromJson(topTracksResponse));
    } catch (e) {
      return Status.error(exception: e.toString());
    }
  }

  Future<Status<CurrentPlayingTrackModel>> fetchCurrentlyPlayingTrack() async {
    try {
      final currentPlayingTrackResponse = await _networkRequester.request(
        Api.baseUrl,
        Api.currentPlayingTracks,
        MethodType.GET.name,
        null,
        null,
      );
      return Status.success(
          data: CurrentPlayingTrackModel.fromJson(currentPlayingTrackResponse));
    } catch (e) {
      return Status.error(exception: e.toString());
    }
  }

  Future<Status<RecentlyPlayedTracksModel>> fetchRecentlyPlayedTracks(
      {required int limit}) async {
    try {
      final recentlyPlayedTracksResponse = await _networkRequester.request(
        Api.baseUrl,
        "${Api.recentlyPlayedTracks}?limit=$limit",
        MethodType.GET.name,
        null,
        null,
      );
      return Status.success(
          data:
              RecentlyPlayedTracksModel.fromJson(recentlyPlayedTracksResponse));
    } catch (e) {
      return Status.error(exception: e.toString());
    }
  }
}
