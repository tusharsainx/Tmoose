import 'package:tmoose/albums/models/album_model.dart';
import 'package:tmoose/artists/models/artist_model.dart';
import 'package:tmoose/helpers/status.dart';
import 'package:tmoose/network_requester/apis.dart';
import 'package:tmoose/network_requester/network_request_helper.dart';
import 'package:tmoose/tracks/models/track_model.dart';

class ArtistsRepository {
  final NetworkRequester _networkRequester = NetworkRequester();
  Future<ArtistModel> getArtistInfo({required String artistId}) async {
    try {
      final artistModel = await _networkRequester.request(
        Api.baseUrl,
        "${Api.getArtistInfo}/$artistId",
        MethodType.GET.name,
        null,
        null,
      );
      return ArtistModel.fromJson(artistModel);
    } catch (e) {
      return ArtistModel();
    }
  }

  Future<Status<ArtistAlbumsModel>> fetchArtistAlbums({
    required String artistId,
    required int limit,
  }) async {
    try {
      final artistAlbumsResponse = await _networkRequester.request(
        Api.baseUrl,
        "${Api.getArtistInfo}/$artistId${Api.albums}?limit=$limit",
        MethodType.GET.name,
        null,
        null,
      );
      return Status.success(
          data: ArtistAlbumsModel.fromJson(artistAlbumsResponse));
    } catch (e) {
      return Status.error(exception: e);
    }
  }

  Future<Status<ArtistTopTracksModel>> fetchArtistTopTracks(
      {required String artistId}) async {
    try {
      final artistTopTracksResponse = await _networkRequester.request(
        Api.baseUrl,
        "${Api.getArtistInfo}/$artistId${Api.artisttopTracks}",
        MethodType.GET.name,
        null,
        null,
      );

      return Status.success(
          data: ArtistTopTracksModel.fromJson(artistTopTracksResponse));
    } catch (e) {
      return Status.error(exception: e);
    }
  }

  Future<Status<ArtistRelatedArtistsModel>> fetchArtistRelatedArtists(
      {required String artistId}) async {
    try {
      final artistRelatedArtistsResponse = await _networkRequester.request(
        Api.baseUrl,
        "${Api.getArtistInfo}/$artistId${Api.relatedArtists}",
        MethodType.GET.name,
        null,
        null,
      );

      return Status.success(
          data:
              ArtistRelatedArtistsModel.fromJson(artistRelatedArtistsResponse));
    } catch (e) {
      return Status.error(exception: e);
    }
  }
}
