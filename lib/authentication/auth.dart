import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:tmoose/helpers/constants.dart';
import 'package:url_launcher/url_launcher.dart';

/// This class will be responsible for authentication of user
class AuthenticationHelper {
  static AuthenticationHelper? _instance;
  AuthenticationHelper._internal();
  factory AuthenticationHelper() {
    return _instance ??= AuthenticationHelper._internal();
  }

  String generateCodeVerifier() {
    final random = Random.secure();
    final values = List<int>.generate(64, (e) => random.nextInt(256));
    return base64Url.encode(values).replaceAll("=", "");
  }

  String generateCodeChallenge(String codeVerifier) {
    final bytes = utf8.encode(codeVerifier);
    final digest = sha256.convert(bytes);
    return base64Url.encode(digest.bytes).replaceAll("=", "");
  }

  Future<void> requestUserAuthorization() async {
    try{
    final codeVerifier = generateCodeVerifier();
    final codeChallenge = generateCodeChallenge(codeVerifier);
    const codeChallengeMethod = "S256";
    const clientId = Constants.clientId;
    const responseType = 'code';
    const scope =
        "ugc-image-upload user-read-playback-state user-modify-playback-state user-read-currently-playing app-remote-control streaming user-read-private user-read-email playlist-read-private playlist-read-collaborative playlist-modify-private playlist-modify-public user-follow-modify user-follow-read user-read-playback-position user-top-read user-read-recently-played user-library-modify user-library-read";
    const redirectUri = "tmoose://auth_callback";
    final authUrl = Uri.parse("https://accounts.spotify.com/authorize")
        .replace(queryParameters: {
      "response_type": responseType,
      "client_id": clientId,
      "scope": scope,
      "code_challenge_method": codeChallengeMethod,
      "code_challenge": codeChallenge,
      "redirect_uri": redirectUri,
    },);
    
    if(await launchUrl(authUrl)){
      print("launch is successfull: $authUrl");
    }
    else{
      print("launch is unsuccessfull $authUrl");
    }
    }catch(e){
      print("error: $e");
    }
  }
}
