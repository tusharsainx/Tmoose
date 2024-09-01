import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:tmoose/helpers/logger.dart';
import 'package:tmoose/network_requester/internet_down_screen.dart';
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

      if (response.statusCode == 200) {
        return response.data;
      } else {
        return _handleError(response.statusCode, response.data);
      }
    } on DioException catch (e) {
      return _handleDioException(e, baseUrl, path, methodType, headers, data);
    } catch (e) {
      logger.e("Unhandled error: $e");
      return null;
    }
  }

  Future _handleDioException(
    DioException e,
    String baseUrl,
    String path,
    String methodType,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? data,
  ) async {
    if (e.error is SocketException) {
      if (!isInternetDownVisible) {
        isInternetDownVisible = true;
        Get.to(() => const InternetDownScreen())?.then((_) {
          isInternetDownVisible = false;
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
    logger
        .e("Request failed with status: $statusCode, Response: $responseData");
    return null;
  }
}
