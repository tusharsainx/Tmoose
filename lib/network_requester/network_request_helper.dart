import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'package:tmoose/authentication/repository/auth_repository.dart';
import 'package:tmoose/helpers/common_headers.dart';
import 'package:tmoose/helpers/logger.dart';

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
  Dio _dio = Dio();
  NetworkRequester() {
    _dio = Dio();
  }

  @override
  Future request(String baseUrl, String path, String methodType,
      Map<String, dynamic>? headers, Map<String, dynamic>? data) async {
    try {
      final headersForApiCall = CommonHeaders().getDefaultHeaders(headers);
      var response = await _dio.request(
        "$baseUrl$path",
        options: Options(
          method: methodType,
          headers: headersForApiCall,
        ),
        data: data,
      );

      if (response.statusCode == 200) {
        return response.data;
      } else if (response.statusCode == 401) {
        return await _handle401(
          baseUrl: baseUrl,
          methodType: methodType,
          headers: headers,
          path: path,
          data: data,
        );
      } else {
        return null;
      }
    } on DioException catch (e) {
      if (e.error is SocketException) {
        //handle internet down
        //dns looked failed
        logger.e("error is: $e");
      }
      if (e.response != null) {
        final statusCode = e.response?.statusCode;
        final responseheaders = e.response?.headers;
        final responseData = e.response?.data;
        if (statusCode == 401) {
          return await _handle401(
            baseUrl: baseUrl,
            methodType: methodType,
            headers: headers,
            path: path,
            data: data,
          );
        }
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future _handle401(
      {required String baseUrl,
      required String path,
      required String methodType,
      required Map<String, dynamic>? headers,
      required Map<String, dynamic>? data}) async {
    final response =
        await AuthenticationRepository().getAccessTokenViaRefreshToken(
      baseUrl: baseUrl,
      path: path,
      prevData: data,
      prevHeaders: headers,
      methodType: methodType,
    );
    return response;
  }
}
