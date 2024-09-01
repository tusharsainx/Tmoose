import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tmoose/authentication/repository/auth_repository.dart';
import 'package:tmoose/helpers/colors.dart';
import 'package:tmoose/helpers/common_headers.dart';
import 'package:tmoose/routes/app_routes.dart';

class NetworkInterceptor extends InterceptorsWrapper {
  final Dio dio;
  NetworkInterceptor({required this.dio});
  static bool isRefreshing = false;
  static bool hasReachedAuth = false;
  static List<({RequestOptions options, ErrorInterceptorHandler handler})>
      requestRetryQueue = [];
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.headers = CommonHeaders().getDefaultHeaders(options.headers);
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    final response = err.response;
    if (response != null) {
      final statusCode = response.statusCode;
      final reqPath = response.requestOptions.path;

      ///incase if anyone of the token api fails, we navigate to auth page
      if (reqPath.contains("api/token")) {
        if (!hasReachedAuth) {
          hasReachedAuth = true;
          requestRetryQueue.clear();
          isRefreshing = false;
          Get.snackbar(
            backgroundGradient: const LinearGradient(
              colors: [
                kAppHeroColor,
                Color(0xFF000000),
              ], // Deep Blue to Black
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            "Session Expired",
            "Please login again!",
            duration: const Duration(seconds: 2),
          );
          Get.offAllNamed(AppRoutes.auth)?.then((_) {
            hasReachedAuth = false;
          });
        }
      } else {
        if (statusCode == 401) {
          if (isRefreshing) {
            requestRetryQueue
                .add((options: response.requestOptions, handler: handler));
          } else {
            isRefreshing = true;
            requestRetryQueue
                .add((options: response.requestOptions, handler: handler));
            await AuthenticationRepository().getAccessTokenViaRefreshToken();
            for (var req in requestRetryQueue) {
              dio.fetch(req.options).then((res) {
                req.handler.resolve(res);
              });
            }
            requestRetryQueue.clear();
            isRefreshing = false;
          }
        } else {
          handler.next(err);
        }
      }
    } else {
      handler.next(err);
    }
  }
}
