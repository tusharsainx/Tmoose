import 'package:tmoose/albums/models/album_model.dart';
import 'package:tmoose/helpers/logger.dart';
import 'package:tmoose/artists/models/artist_model.dart';

class TrackModel {
  String? playedAt;
  String? trackId;
  String? previewUrl;
  String? trackSpotifyLink;
  String? backgroundImage;
  List<ArtistModelBase>? artists;
  int? trackPopularity;
  String? trackName;
  AlbumModel? album;
  String? trackDuration;
  TrackModel({
    this.playedAt,
    this.trackDuration,
    this.album,
    this.trackName,
    this.artists,
    this.previewUrl,
    this.trackId,
    this.trackSpotifyLink,
    this.backgroundImage,
    this.trackPopularity,
  });
  factory TrackModel.fromJson(Map<String, dynamic>? json) {
    final trackId = json?["id"];
    final previewUrl = json?["preview_url"];
    final trackSpotifyLink = json?["external_urls"]?["spotify"];
    String backgroundImage = "";
    final images = json?["album"]?["images"];
    if (images != null && (images is List)) {
      if (images.isNotEmpty) backgroundImage = (images[0]?["url"]) ?? "";
    }
    final artists = json?["artists"];
    final artistModels = <ArtistModelBase>[];
    final album = AlbumModel.fromJson(json?["album"]);
    if (artists != null) {
      for (int i = 0; i < artists.length; i++) {
        artistModels.add(ArtistModelBase.fromJson(artists[i]));
      }
    }
    final trackPopularity = json?["popularity"];
    final trackName = json?["name"];
    try {
      final trackDuration = json?["duration_ms"];
      return TrackModel(
        album: album,
        trackId: trackId,
        previewUrl: previewUrl,
        trackSpotifyLink: trackSpotifyLink,
        backgroundImage: backgroundImage,
        artists: artistModels,
        trackDuration: trackDuration?.toString(),
        trackName: trackName,
        trackPopularity: trackPopularity,
        playedAt: null,
      );
    } catch (e) {
      logger.e(e);
      return TrackModel();
    }
  }
}

class CurrentPlayingTrackModel extends TrackModel {
  CurrentPlayingTrackModel({
    super.album,
    super.artists,
    super.backgroundImage,
    super.previewUrl,
    super.trackDuration,
    super.trackId,
    super.trackName,
    super.trackPopularity,
    super.trackSpotifyLink,
  });
  factory CurrentPlayingTrackModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return CurrentPlayingTrackModel();
    }
    final trackModel = TrackModel.fromJson(json["item"]);
    return CurrentPlayingTrackModel(
      album: trackModel.album,
      artists: trackModel.artists,
      backgroundImage: trackModel.backgroundImage,
      previewUrl: trackModel.previewUrl,
      trackDuration: trackModel.trackDuration,
      trackId: trackModel.trackId,
      trackName: trackModel.trackName,
      trackPopularity: trackModel.trackPopularity,
      trackSpotifyLink: trackModel.trackSpotifyLink,
    );
  }
}

class RecentlyPlayedTracksModel {
  List<TrackModel>? tracks;
  RecentlyPlayedTracksModel({this.tracks});
  factory RecentlyPlayedTracksModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return RecentlyPlayedTracksModel(tracks: []);
    }
    final tracks = <TrackModel>[];
    final items = json["items"];
    if (items != null) {
      for (int i = 0; i < items.length; i++) {
        TrackModel currModel = TrackModel.fromJson(items[i]?["track"]);
        currModel.playedAt = items[i]?["played_at"];
        tracks.add(currModel);
      }
    }
    return RecentlyPlayedTracksModel(
      tracks: tracks,
    );
  }
}

class UserTopTracksModel {
  List<TrackModel>? tracks;

  UserTopTracksModel({
    this.tracks,
  });

  factory UserTopTracksModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) return UserTopTracksModel(tracks: []);
    final tracks = <TrackModel>[];
    final items = json["items"];
    if (items != null) {
      for (int i = 0; i < items.length; i++) {
        tracks.add(TrackModel.fromJson(items[i]));
      }
    }
    return UserTopTracksModel(
      tracks: tracks,
    );
  }
}

class ArtistTopTracksModel {
  List<TrackModel>? tracks;

  ArtistTopTracksModel({
    this.tracks,
  });

  factory ArtistTopTracksModel.fromJson(Map<String, dynamic>? json) {
    final tracks = <TrackModel>[];
    final items = json?["tracks"];
    if (items == null) return ArtistTopTracksModel(tracks: []);
    for (int i = 0; i < items.length; i++) {
      tracks.add(TrackModel.fromJson(items[i]));
    }
    return ArtistTopTracksModel(
      tracks: tracks,
    );
  }
}

class TrackAudioFeaturesModel {
  double? danceability;
  String? modality;
  double? loudness;
  int? beatsPerBar;
  double? energy;
  double? liveness;
  TrackAudioFeaturesModel({
    this.liveness,
    this.energy,
    this.danceability,
    this.modality,
    this.beatsPerBar,
    this.loudness,
  });
  factory TrackAudioFeaturesModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) return TrackAudioFeaturesModel();
    return TrackAudioFeaturesModel(
      danceability: json["danceability"],
      modality: json["mode"] == 1
          ? "Major"
          : json["mode"] == 0
              ? "Minor"
              : null,
      loudness: json["loudness"],
      beatsPerBar: json["time_signature"],
      energy: json["energy"],
      liveness: json["liveness"],
    );
  }
}

class RecommendedTracksModel {
  List<TrackModel>? recommendedTracks;
  RecommendedTracksModel({this.recommendedTracks});
  factory RecommendedTracksModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) return RecommendedTracksModel(recommendedTracks: []);
    final tracks = <TrackModel>[];
    final items = json["tracks"];
    if (items == null) return RecommendedTracksModel();
    for (int i = 0; i < items.length; i++) {
      tracks.add(TrackModel.fromJson(items[i]));
    }
    return RecommendedTracksModel(
      recommendedTracks: tracks,
    );
  }
}
