import 'package:tmoose/helpers/status.dart';
import 'package:tmoose/network_requester/apis.dart';
import 'package:tmoose/network_requester/network_request_helper.dart';
import 'package:tmoose/tracks/models/track_model.dart';

class TracksRepository {
  final NetworkRequester _networkRequester = NetworkRequester();
  Future<Status<TrackAudioFeaturesModel>> findTrackAudioAnalysis(
      {required String trackId}) async {
    try {
      final trackAudioFeaturesResponse = await _networkRequester.request(
        Api.baseUrl,
        "${Api.audioFeatures}/$trackId",
        MethodType.GET.name,
        null,
        null,
      );
      return Status.success(
          data: TrackAudioFeaturesModel.fromJson(trackAudioFeaturesResponse));
    } catch (e) {
      return Status.error();
    }
  }

  Future findRecommendations({
    required Map<String, dynamic> queryPrams,
  }) async {
    try {
      final recommendedTracksResponse = await _networkRequester.request(
        Api.baseUrl,
        "${Api.trackRecomendations}?${buildQueryParams(queryPrams)}",
        MethodType.GET.name,
        null,
        null,
      );
      return RecentlyPlayedTracksModel.fromJson(recommendedTracksResponse);
    } catch (e) {
      return RecentlyPlayedTracksModel();
    }
  }

  String buildQueryParams(Map<String, dynamic> query) {
    //todo
    return "";
  }
}
