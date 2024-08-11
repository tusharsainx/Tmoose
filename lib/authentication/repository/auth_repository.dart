import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:hive/hive.dart';
import 'package:tmoose/authentication/models/auth_models.dart';
import 'package:tmoose/helpers/constants.dart';
import 'package:tmoose/helpers/logger.dart';
import 'package:tmoose/network_requester/apis.dart';
import 'package:tmoose/network_requester/network_request_helper.dart';
import 'package:url_launcher/url_launcher.dart';

/// This class will be responsible for authentication of user
class AuthenticationRepository {
  static AuthenticationRepository? _instance;
  AuthenticationRepository._internal();
  factory AuthenticationRepository() {
    return _instance ??= AuthenticationRepository._internal();
  }

  String _generateCodeVerifier() {
    final random = Random.secure();
    final values = List<int>.generate(64, (e) => random.nextInt(256));
    return base64Url.encode(values).replaceAll("=", "");
  }

  String _generateCodeChallenge(String codeVerifier) {
    final bytes = utf8.encode(codeVerifier);
    final digest = sha256.convert(bytes);
    return base64Url.encode(digest.bytes).replaceAll("=", "");
  }

  void _saveCodeVerifier(String codeVerifier) async {
    final codeVerifierBox = Hive.box<CodeVerifierModel>("CodeVerifierModel");
    final codeVerifierModel = CodeVerifierModel(codeVerifier: codeVerifier);
    await codeVerifierBox.put("codeVerifier", codeVerifierModel);
  }

  Future<void> _saveTokens(dynamic tokenResponse) async {
    final tokenBox = Hive.box<TokenModel>("TokenModel");
    final tokenModel = TokenModel(
        refreshToken: tokenResponse["refresh_token"],
        accessToken: tokenResponse["access_token"]);
    await tokenBox.put("tokens", tokenModel);
  }

  Future<void> requestUserAuthorization() async {
    try {
      final codeVerifier = _generateCodeVerifier();
      final codeChallenge = _generateCodeChallenge(codeVerifier);
      _saveCodeVerifier(codeVerifier);
      const codeChallengeMethod = "S256";
      const clientId = Constants.clientId;
      const responseType = 'code';
      const redirectUri = Constants.redirectUri;
      final authUrl =
          Uri.parse("https://accounts.spotify.com/authorize").replace(
        queryParameters: {
          "response_type": responseType,
          "client_id": clientId,
          "scope": Constants.scope,
          "code_challenge_method": codeChallengeMethod,
          "code_challenge": codeChallenge,
          "redirect_uri": redirectUri,
        },
      );
      await launchUrl(authUrl);
    } catch (e) {
      logger.e("error: $e");
    }
  }

  Future<void> requestAccessToken(String authCode) async {
    final headers = {
      'Content-Type': 'application/x-www-form-urlencoded',
    };
    final codeVerifier = (Hive.box<CodeVerifierModel>('CodeVerifierModel')
            .get("codeVerifier") as CodeVerifierModel)
        .codeVerifier;
    final data = {
      "client_id": Constants.clientId,
      "grant_type": 'authorization_code',
      "code": authCode,
      "redirect_uri": Constants.redirectUri,
      "code_verifier": codeVerifier,
    };
    await Hive.box<TokenModel>("TokenModel").put(
      "tokens",
      TokenModel(
        accessToken: null,
        refreshToken: null,
      ),
    );
    final tokenResponse = await NetworkRequester().request(
      Api.authBaseUrl,
      Api.authBaseUrlPath,
      MethodType.POST.name,
      headers,
      data,
    );
    logger.d("via authcode: $tokenResponse");
    await _saveTokens(tokenResponse);
  }

  Future<dynamic> getAccessTokenViaRefreshToken({
    required String baseUrl,
    required String path,
    Map<String, dynamic>? prevData,
    Map<String, dynamic>? prevHeaders,
    required String methodType,
  }) async {
    final currheaders = {
      'Content-Type': 'application/x-www-form-urlencoded',
    };
    final refreshToken =
        (Hive.box<TokenModel>("TokenModel").get("tokens") as TokenModel)
            .refreshToken;
    await Hive.box<TokenModel>("TokenModel").put(
      "tokens",
      TokenModel(
        accessToken: null,
        refreshToken: refreshToken,
      ),
    );
    final data = {
      "client_id": Constants.clientId,
      "grant_type": 'refresh_token',
      "refresh_token": refreshToken,
    };
    final tokenResponse = await NetworkRequester().request(
      Api.authBaseUrl,
      Api.authBaseUrlPath,
      MethodType.POST.name,
      currheaders,
      data,
    );
    await _saveTokens(tokenResponse);
    return await NetworkRequester().request(
      baseUrl,
      path,
      methodType,
      prevHeaders,
      prevData,
    );
  }
}
