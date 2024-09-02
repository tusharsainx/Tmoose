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
    if (json == null) return UserProfileModel();
    String backgroundImage = "";
    final images = json["images"];
    if (images != null && (images is List)) {
      if (images.isNotEmpty) backgroundImage = (images[0]?["url"]) ?? "";
    }
    return UserProfileModel(
      name: json["display_name"],
      image: backgroundImage,
      userSpotifyProfile: json["external_urls"]?["spotify"],
      followers: json["followers"]?["total"]?.toString(),
    );
  }
}
