import 'dart:async';
import 'package:get/get.dart';
import 'package:tmoose/authentication/repository/auth_repository.dart';
import 'package:tmoose/helpers/logger.dart';
import 'package:tmoose/routes/app_routes.dart';
import 'package:uni_links/uni_links.dart';

class RedirectUriListener {
  static final AuthenticationRepository _authenticationRepository =
      AuthenticationRepository();
  static StreamSubscription? _urlStreamSubscription;
  static void init() {
    _urlStreamSubscription = uriLinkStream.listen((Uri? uri) {
      if (uri != null) {
        final queryParams = uri.queryParameters;
        if (queryParams.containsKey("code")) {
          String authCode = queryParams["code"] ?? "";
          _handleAccessTokenFetching(authCode);
        } else if (queryParams.containsKey("error")) {
          String error = queryParams["error"] ?? "";
          logger.e("error is $error");
        }
      }
    });
  }

  static void _handleAccessTokenFetching(String authCode) async {
    await _authenticationRepository.requestAccessToken(authCode);
    _navigationToHome();
  }

  static void _navigationToHome() {
    Get.offAllNamed(AppRoutes.home);
  }

  static void dispose() {
    _urlStreamSubscription?.cancel();
  }
}
