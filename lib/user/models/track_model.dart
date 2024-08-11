import 'package:tmoose/user/models/artists_followed_model.dart';

class TrackModel {
  final String trackId;
  final String previewUrl;
  final String trackSpotifyLink;
  final String backgroundImage;
  final List<ArtistModelBase> artists;
  final String trackPopularity;
  final String trackName;
  final String albumSpotifyLink;
  final String trackDuration;
  TrackModel({
    required this.trackDuration,
    required this.albumSpotifyLink,
    required this.trackName,
    required this.artists,
    required this.previewUrl,
    required this.trackId,
    required this.trackSpotifyLink,
    required this.backgroundImage,
    required this.trackPopularity,
  });
}

class CurrentPlayingTrackModel extends TrackModel {
  CurrentPlayingTrackModel({
    required super.albumSpotifyLink,
    required super.trackName,
    required super.trackPopularity,
    required super.backgroundImage,
    required super.artists,
    required super.previewUrl,
    required super.trackDuration,
    required super.trackId,
    required super.trackSpotifyLink,
  });
}

class RecentlyPlayedTracksListModel {
  final List<RecentlyPlayedTrackModel> recentlyPlayedTracks;
  RecentlyPlayedTracksListModel({
    required this.recentlyPlayedTracks,
  });
}

class RecentlyPlayedTrackModel extends TrackModel {
  final String lastPlayedAt;
  RecentlyPlayedTrackModel({
    required super.trackDuration,
    required super.albumSpotifyLink,
    required this.lastPlayedAt,
    required super.previewUrl,
    required super.trackName,
    required super.artists,
    required super.trackId,
    required super.trackSpotifyLink,
    required super.backgroundImage,
    required super.trackPopularity,
  });
}
