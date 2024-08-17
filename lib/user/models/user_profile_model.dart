class UserProfileModel {
  String? name;
  String? image;
  String? userSpotifyProfile;
  String? followers;
  UserProfileModel({
    this.followers,
    this.image,
    this.name,
    this.userSpotifyProfile,
  });
  factory UserProfileModel.fromJson(Map<String, dynamic>? json) {
    return UserProfileModel(
      name: json?["display_name"],
      image: json?["images"]?[0]["url"],
      userSpotifyProfile: json?["external_urls"]?["spotify"],
      followers: json?["followers"]?["total"]?.toString(),
    );
  }
}
