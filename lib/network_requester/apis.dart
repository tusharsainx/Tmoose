class Api {
  static const baseUrl = "https://api.spotify.com";
  static const clientId = "9434fb590d3841d786bdb22d7c7fdb59";
  static const clientSecret = "d85f058d4fcf451790cd06998598261e";
  static const authBaseUrl = "https://accounts.spotify.com";
  static const authBaseUrlPath = "/api/token";

  // user profile endpoints
  static const userProfile = "/v1/me";
  static const topArtists = "/v1/me/top/artists";
  static const topTracks = "/v1/me/top/tracks";
  static const currentPlayingTracks = "/v1/me/player/currently-playing";
  static const recentlyPlayedTracks = "/v1/me/player/recently-played";
}
