import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tmoose/albums/models/album_model.dart';
import 'package:tmoose/artists/models/artist_model.dart';
import 'package:tmoose/artists/repository/artist_repository.dart';
import 'package:tmoose/tracks/models/track_model.dart';

class ArtistViewController extends GetxController {
  ArtistModel? artistModel;
  ArtistAlbumsModel? artistAlbums;
  ArtistRelatedArtistsModel? artistRelatedArtistsModel;
  ArtistTopTracksModel? artistTopTracksModel;
  ScrollController? scrollController;
  final ArtistsRepository _artistsRepository = ArtistsRepository();
  final isDataLoading = false.obs;
  @override
  void onInit() {
    init();
    super.onInit();
  }

  void init() async {
    isDataLoading(true);
    scrollController = ScrollController();
    artistModel = Get.arguments as ArtistModel;
    await fetchArtistAlbums(artistId: artistModel?.artistId ?? "", limit: 50);
    await fetchArtistTopTracks(artistId: artistModel?.artistId ?? "");
    await fetchArtistRelatedArtists(artistId: artistModel?.artistId ?? "");
    isDataLoading(false);
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

  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
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
    artistAlbums = await _artistsRepository.fetchArtistAlbums(
        artistId: artistId, limit: limit);
  }

  Future fetchArtistTopTracks({required String artistId}) async {
    artistTopTracksModel =
        await _artistsRepository.fetchArtistTopTracks(artistId: artistId);
  }

  Future fetchArtistRelatedArtists({required String artistId}) async {
    artistRelatedArtistsModel =
        await _artistsRepository.fetchArtistRelatedArtists(artistId: artistId);
  }
}
