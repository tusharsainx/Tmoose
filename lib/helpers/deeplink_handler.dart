import 'dart:async';

import 'package:uni_links/uni_links.dart';

class RedirectUriListener {
  static StreamSubscription? _urlStreamSubscription;
  static void init() {
    _urlStreamSubscription = uriLinkStream.listen((Uri? uri) {
      if (uri != null) {
        print("uri path ${uri.queryParameters}");
        final queryParams = uri.queryParameters;
        if (queryParams.containsKey("code")) {
          String authCode = queryParams["code"] ?? "";
          print("auth code is: $authCode");
        } else if (queryParams.containsKey("error")) {
          String error = queryParams["error"] ?? "";
          print("error is: $error");
        }
      }
    });
  }

  static void dispose() {
    _urlStreamSubscription?.cancel();
  }
}
