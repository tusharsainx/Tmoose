import 'package:tmoose/helpers/logger.dart';
import 'package:tmoose/user/models/artist_model.dart';

class TrackModel {
  String? playedAt;
  String? trackId;
  String? previewUrl;
  String? trackSpotifyLink;
  String? backgroundImage;
  List<ArtistModelBase>? artists;
  int? trackPopularity;
  String? trackName;
  String? albumSpotifyLink;
  String? trackDuration;
  TrackModel({
    this.playedAt,
    this.trackDuration,
    this.albumSpotifyLink,
    this.trackName,
    this.artists,
    this.previewUrl,
    this.trackId,
    this.trackSpotifyLink,
    this.backgroundImage,
    this.trackPopularity,
  });
  factory TrackModel.fromJson(Map<String, dynamic>? json) {
    final albumSpotifyLink = json?["album"]?["external_urls"]?["spotify"];
    final trackId = json?["id"];
    final previewUrl = json?["preview_url"];
    final trackSpotifyLink = json?["external_urls"]?["spotify"];
    final backgroundImage = json?["album"]?["images"]?[0]?["url"];
    final artists = json?["artists"];
    final artistModels = <ArtistModelBase>[];
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
        albumSpotifyLink: albumSpotifyLink,
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

class TopTracksModel {
  static TopTracksModel? _instance;
  TopTracksModel._internal();
  static TopTracksModel get instance =>
      _instance ??= TopTracksModel._internal();

  List<TrackModel>? tracks;

  List<TrackModel>? get returnTracks {
    return tracks;
  }

  void fromJson(Map<String, dynamic>? json) {
    final tracks = <TrackModel>[];
    final items = json?["items"];
    if (items != null) {
      for (int i = 0; i < items.length; i++) {
        tracks.add(TrackModel.fromJson(items[i]));
      }
    }
    this.tracks = tracks;
    return;
  }
}

class CurrentPlayingTrackModel extends TrackModel {
  CurrentPlayingTrackModel({
    super.albumSpotifyLink,
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
      albumSpotifyLink: trackModel.albumSpotifyLink,
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
    final tracks = <TrackModel>[];
    final items = json?["items"];
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
