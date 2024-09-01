import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:tmoose/helpers/assets_helper.dart';
import 'package:tmoose/helpers/logger.dart';
import 'package:tmoose/helpers/generic_error_screen.dart';
import 'package:tmoose/network_requester/network_interceptors.dart';

enum MethodType { GET, POST, PUT, DELETE }

abstract interface class NetworkRequesterBase {
  Future request(
    String baseUrl,
    String path,
    String methodType,
    Map<String, dynamic> headers,
    Map<String, dynamic> data,
  );
}

class NetworkRequester implements NetworkRequesterBase {
  static final Dio _dio = Dio();
  static final NetworkRequester _instance = NetworkRequester.internal();
  factory NetworkRequester() {
    _dio.interceptors.add(NetworkInterceptor(dio: _dio));
    return _instance;
  }
  NetworkRequester.internal();
  bool isInternetDownVisible = false;
  bool isServerDownVisible = false;
  bool isServerUnavailableVisible = false;
  @override
  Future request(
    String baseUrl,
    String path,
    String methodType,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? data,
  ) async {
    try {
      var response = await _dio.request(
        "$baseUrl$path",
        options: Options(
          method: methodType,
          headers: headers,
        ),
        data: data,
      );
      if (response.statusCode == 200 ||
          response.statusCode == 201 ||
          response.statusCode == 204) {
        return response.data;
      } else {
        return _handleError(response.statusCode, response.data);
      }
    } on DioException catch (e) {
      return _handleDioException(e);
    } catch (e) {
      return "unhandled error: $e";
    }
  }

  Future _handleDioException(
    DioException e,
  ) async {
    if (e.error is SocketException) {
      if (!isInternetDownVisible) {
        isInternetDownVisible = true;
        isServerDownVisible = true;
        isServerUnavailableVisible = true;
        Get.to(() => const GenericErrorScreen(
              title: "Network issue!",
              description:
                  "We have received Socket Exception, saying host lookup failed, make sure you are connected to good internet.",
              imagePath: AssetsHelper.internetDown,
            ))?.then((_) {
          isInternetDownVisible = false;
          isServerDownVisible = false;
          isServerUnavailableVisible = false;
        });
        logger.e("Network error: $e");
      }
    } else if (e.response != null) {
      final statusCode = e.response?.statusCode;
      return _handleError(statusCode, e.response?.data);
    }
    logger.e("Unhandled Dio exception: $e");
    return null;
  }

  dynamic _handleError(int? statusCode, dynamic responseData) {
    if (statusCode == 500) {
      if (!isServerDownVisible) {
        isInternetDownVisible = true;
        isServerDownVisible = true;
        isServerUnavailableVisible = true;
        Get.to(() => const GenericErrorScreen(
              title: "Internal Server Error!",
              description:
                  "You should never receive this error because our clever coders catch them all ... but if you are unlucky enough to get one, please report it to us through https://support.spotify.com/us/contact-spotify-support/",
              imagePath: AssetsHelper.serverDown,
            ))?.then((_) {
          isInternetDownVisible = false;
          isServerDownVisible = false;
          isServerUnavailableVisible = false;
        });
      }
    } else if (statusCode == 503) {
      if (!isServerUnavailableVisible) {
        isInternetDownVisible = true;
        isServerDownVisible = true;
        isServerUnavailableVisible = true;
        Get.to(() => const GenericErrorScreen(
              title: "Service Unavailable!",
              description:
                  "The server is currently unable to handle the request due to a temporary condition which will be alleviated after some delay.",
              imagePath: AssetsHelper.serverUnavailable,
            ))?.then((_) {
          isInternetDownVisible = false;
          isServerDownVisible = false;
          isServerUnavailableVisible = false;
        });
      }
    } else if (statusCode == 429) {
      // Too Many Requests - Rate limiting has been applied.
    } else if (statusCode == 404) {
      // Not Found - The requested resource could not be found. This error can be due to a temporary or permanent condition.
    }
    logger
        .e("Request failed with status: $statusCode, Response: $responseData");
    return null;
  }
}
