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
    final id = json?["id"];
    final name = json?["name"];
    final link = json?["external_urls"]?["spotify"];
    return ArtistModelBase(
      artistId: id,
      artistName: name,
      artistSpotifyLink: link,
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
    String imageUrl = "";
    if (images != null && (images is List)) {
      if (images.isNotEmpty) imageUrl = (images[0]?["url"]) ?? "";
    }
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

class UserTopArtistsModel {
  List<ArtistModel>? artists;

  UserTopArtistsModel({this.artists});

  factory UserTopArtistsModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) return UserTopArtistsModel(artists: []);
    final artists = <ArtistModel>[];
    final items = json["items"];
    if (items == null) return UserTopArtistsModel(artists: []);

    for (int i = 0; i < items.length; i++) {
      artists.add(ArtistModel.fromJson(items[i]));
    }
    return UserTopArtistsModel(artists: artists);
  }
}

class ArtistRelatedArtistsModel {
  List<ArtistModel>? artists;

  ArtistRelatedArtistsModel({this.artists});

  factory ArtistRelatedArtistsModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) return ArtistRelatedArtistsModel(artists: []);
    final artists = <ArtistModel>[];
    final items = json["artists"];
    if (items == null) return ArtistRelatedArtistsModel(artists: []);

    for (int i = 0; i < items.length; i++) {
      artists.add(ArtistModel.fromJson(items[i]));
    }
    return ArtistRelatedArtistsModel(artists: artists);
  }
}
