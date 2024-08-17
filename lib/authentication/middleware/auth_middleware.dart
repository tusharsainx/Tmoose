import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:tmoose/authentication/models/auth_models.dart';
import 'package:tmoose/routes/app_routes.dart';

class AuthMiddleware extends GetMiddleware {
  @override
  int? get priority => 1;

  @override
  RouteSettings? redirect(String? route) {
    bool isAuthenticated = checkAuthentication();
    if (!isAuthenticated) {
      return RouteSettings(name: AppRoutes.auth);
    }
    return null;
  }

  bool checkAuthentication() {
    final tokens = Hive.box<TokenModel>("TokenModel").get("tokens");
    if (tokens == null) {
      return false;
    } else {
      final tokensmodel = tokens;
      final accessToken = tokensmodel.accessToken;
      return accessToken != null;
    }
  }
}
