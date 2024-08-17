import 'dart:convert';

import 'package:tmoose/helpers/logger.dart';

class ArtistModelBase {
  String? artistId;
  String? artistName;
  String? artistSpotifyLink;
  String? imageUrl;
  ArtistModelBase({
    this.imageUrl,
    this.artistId,
    this.artistName,
    this.artistSpotifyLink,
  });
  factory ArtistModelBase.fromJson(Map<String, dynamic>? json) {
    return ArtistModelBase(
      artistId: json?["id"],
      artistName: json?["name"],
      artistSpotifyLink: json?["external_urls"]?["spotify"],
    );
  }
}

class ArtistModel extends ArtistModelBase {
  String? followers;
  List<String>? genres;
  int? popularityOutOf100;

  ArtistModel({
    super.artistId,
    super.artistName,
    super.artistSpotifyLink,
    super.imageUrl,
    this.followers,
    this.genres,
    this.popularityOutOf100,
  });
  factory ArtistModel.fromJson(Map<String, dynamic>? json) {
    final externalUrl = json?["external_urls"]?["spotify"];
    final followers = json?["followers"]?["total"]?.toString();
    final genres = List<String>.from(json?["genres"] ?? []);
    final artistId = json?["id"];
    final name = json?["name"];
    final popularity = json?["popularity"];
    final images = json?["images"];
    final imageUrl = images?[0]["url"];
    return ArtistModel(
      artistId: artistId,
      artistName: name,
      artistSpotifyLink: externalUrl,
      followers: followers,
      genres: genres,
      popularityOutOf100: popularity,
      imageUrl: imageUrl,
    );
  }
}

class TopArtistsModel {
  static TopArtistsModel? _instance;
  TopArtistsModel._internal();
  static TopArtistsModel get instance =>
      _instance ??= TopArtistsModel._internal();

  List<ArtistModel>? artists;

  List<ArtistModel>? get returnArtists {
    return artists;
  }

  void fromJson(Map<String, dynamic>? json) {
    final artists = <ArtistModel>[];
    final items = json?["items"];
    if (items != null) {
      for (int i = 0; i < items.length; i++) {
        artists.add(ArtistModel.fromJson(items[i]));
      }
    }
    this.artists = artists;
    return;
  }
}
