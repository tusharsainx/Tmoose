import 'package:tmoose/artists/models/artist_model.dart';
import 'package:tmoose/tracks/models/track_model.dart';

class MusicPlayerModel {
  final String? songName;
  final List<String>? artistNames;
  final String? image;
  final String? previewUrl;
  MusicPlayerModel({
    this.artistNames,
    this.image,
    this.songName,
    this.previewUrl,
  });
  factory MusicPlayerModel.fromTrack(TrackModel? track) {
    if (track == null) {
      return MusicPlayerModel();
    }
    List<String> artists = [];
    for (int i = 0; i < (track.artists ?? []).length; i++) {
      ArtistModelBase? artistModel = track.artists?[i];
      artists.add(artistModel?.artistName ?? "");
    }
    return MusicPlayerModel(
        songName: track.trackName,
        image: track.backgroundImage,
        artistNames: artists,
        previewUrl: track.previewUrl);
  }
}

class PlayableTracksList {
  final List<TrackModel>? tracks;
  PlayableTracksList({this.tracks});
  factory PlayableTracksList.fromTracks(List<TrackModel>? tracks) {
    if (tracks == null) return PlayableTracksList(tracks: []);
    List<TrackModel> playableTracks = [];
    for (int i = 0; i < tracks.length; i++) {
      MusicPlayerModel trackModel = MusicPlayerModel.fromTrack(tracks[i]);
      if (trackModel.previewUrl != null &&
          trackModel.previewUrl!.isNotEmpty &&
          trackModel.songName != null &&
          trackModel.songName!.isNotEmpty &&
          trackModel.artistNames != null &&
          trackModel.artistNames!.isNotEmpty &&
          trackModel.image != null &&
          trackModel.image!.isNotEmpty) {
        playableTracks.add(tracks[i]);
      }
    }
    return PlayableTracksList(tracks: playableTracks);
  }
}
