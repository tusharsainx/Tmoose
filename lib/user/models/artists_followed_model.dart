class ArtistsFollowedModel {
  final List<ArtistModel> followedArtists;

  ArtistsFollowedModel({
    this.followedArtists = const [],
  });

  void addArtist(ArtistModel artist) {
    followedArtists.add(artist);
  }

  void removeArtist(String artistId) {
    followedArtists.removeWhere((artist) => artist.artistId == artistId);
  }
}

class ArtistModelBase {
  final String artistId;
  final String artistName;
  final String artistSpotifyLink;
  final String imageUrl;
  ArtistModelBase({
    required this.imageUrl,
    required this.artistId,
    required this.artistName,
    required this.artistSpotifyLink,
  });
}

class ArtistModel extends ArtistModelBase {
  final String followers;
  final List<String> genres;
  final int popularityOutOf100;

  ArtistModel({
    required super.artistId,
    required super.artistName,
    required super.artistSpotifyLink,
    required super.imageUrl,
    this.followers = '0',
    this.genres = const [],
    this.popularityOutOf100 = 0,
  });
}
