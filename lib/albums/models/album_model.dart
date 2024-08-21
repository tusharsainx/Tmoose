import 'package:tmoose/artists/models/artist_model.dart';

class AlbumModel {
  String? albumId;
  String? albumName;
  String? albumSpotifyLink;
  String? imageUrl;
  int? totalTracks;
  List<ArtistModelBase>? artists;
  AlbumModel({
    this.imageUrl,
    this.albumId,
    this.albumName,
    this.albumSpotifyLink,
    this.totalTracks,
    this.artists,
  });
  factory AlbumModel.fromJson(Map<String, dynamic>? json) {
    List<ArtistModelBase> singers = [];
    if (json == null) return AlbumModel();
    final artists = json["artists"];
    if (artists != null) {
      for (int i = 0; i < artists.length; i++) {
        singers.add(ArtistModelBase.fromJson(artists[i]));
      }
    }
    final imageUrl = json["images"]?[0]["url"];
    return AlbumModel(
      artists: singers,
      imageUrl: imageUrl,
      totalTracks: json["total_tracks"],
      albumId: json["id"],
      albumName: json["name"],
      albumSpotifyLink: json["external_urls"]?["spotify"],
    );
  }
}

class ArtistAlbumsModel {
  List<AlbumModel>? albums;
  ArtistAlbumsModel({this.albums});
  factory ArtistAlbumsModel.fromJson(Map<String, dynamic>? json) {
    final albums = <AlbumModel>[];
    final items = json?["items"];
    if (items == null) return ArtistAlbumsModel();
    for (int i = 0; i < items.length; i++) {
      final AlbumModel albumModel = AlbumModel.fromJson(items[i]);
      if ((albumModel.totalTracks ?? 0) > 1) {
        albums.add(albumModel);
      }
    }
    return ArtistAlbumsModel(
      albums: albums,
    );
  }
}
