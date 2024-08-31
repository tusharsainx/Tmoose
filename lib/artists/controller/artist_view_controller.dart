import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tmoose/albums/models/album_model.dart';
import 'package:tmoose/artists/models/artist_model.dart';
import 'package:tmoose/artists/repository/artist_repository.dart';
import 'package:tmoose/helpers/status.dart';
import 'package:tmoose/tracks/models/track_model.dart';

class ArtistViewController extends GetxController {
  ArtistModel? artistModel;
  final artistAlbums = Status<ArtistAlbumsModel>.loading().obs;
  final artistRelatedArtistsModel =
      Status<ArtistRelatedArtistsModel>.loading().obs;
  final artistTopTracksModel = Status<ArtistTopTracksModel>.loading().obs;
  ScrollController? scrollController;
  final ArtistsRepository _artistsRepository = ArtistsRepository();
  @override
  void onInit() {
    init();
    super.onInit();
  }

  void init() {
    scrollController = ScrollController();
    artistModel = Get.arguments as ArtistModel;
    fetchArtistAlbums(artistId: artistModel?.artistId ?? "", limit: 50);
    fetchArtistTopTracks(artistId: artistModel?.artistId ?? "");
    fetchArtistRelatedArtists(artistId: artistModel?.artistId ?? "");
  }

  @override
  void onClose() {
    scrollController?.dispose();
    super.onClose();
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

  String artistFollowers(String? followers) {
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

  Future fetchArtistAlbums({
    required String artistId,
    required int limit,
  }) async {
    artistAlbums.value = Status.loading();
    artistAlbums.value = await _artistsRepository.fetchArtistAlbums(
        artistId: artistId, limit: limit);
  }

  Future fetchArtistTopTracks({required String artistId}) async {
    artistTopTracksModel.value = Status.loading();
    artistTopTracksModel.value =
        await _artistsRepository.fetchArtistTopTracks(artistId: artistId);
  }

  Future fetchArtistRelatedArtists({required String artistId}) async {
    artistRelatedArtistsModel.value = Status.loading();
    artistRelatedArtistsModel.value =
        await _artistsRepository.fetchArtistRelatedArtists(artistId: artistId);
  }
}
