import 'package:tmoose/albums/models/album_model.dart';
import 'package:tmoose/artists/models/artist_model.dart';
import 'package:tmoose/network_requester/apis.dart';
import 'package:tmoose/network_requester/network_request_helper.dart';
import 'package:tmoose/tracks/models/track_model.dart';

class ArtistsRepository {
  final NetworkRequester _networkRequester = NetworkRequester();
  Future<ArtistAlbumsModel> fetchArtistAlbums({
    required String artistId,
    required String limit,
  }) async {
    try {
      final artistAlbumsResponse = await _networkRequester.request(
        Api.baseUrl,
        "${Api.getArtistInfo}/$artistId${Api.albums}?limit=$limit",
        MethodType.GET.name,
        null,
        null,
      );
      return ArtistAlbumsModel.fromJson(artistAlbumsResponse);
    } catch (e) {
      return ArtistAlbumsModel();
    }
  }

  Future<ArtistTopTracksModel> fetchArtistTopTracks(
      {required String artistId}) async {
    try {
      final artistTopTracksResponse = await _networkRequester.request(
        Api.baseUrl,
        "${Api.getArtistInfo}/$artistId${Api.artisttopTracks}",
        MethodType.GET.name,
        null,
        null,
      );

      return ArtistTopTracksModel.fromJson(artistTopTracksResponse);
    } catch (e) {
      return ArtistTopTracksModel();
    }
  }

  Future<ArtistRelatedArtistsModel> fetchArtistRelatedArtists(
      {required String artistId}) async {
    try {
      final artistRelatedArtistsResponse = await _networkRequester.request(
        Api.baseUrl,
        "${Api.getArtistInfo}/$artistId${Api.relatedArtists}",
        MethodType.GET.name,
        null,
        null,
      );

      return ArtistRelatedArtistsModel.fromJson(artistRelatedArtistsResponse);
    } catch (e) {
      return ArtistRelatedArtistsModel();
    }
  }
}
