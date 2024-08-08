import 'dart:convert';

import 'package:dio/dio.dart';

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
      Map<String, dynamic> headers, Map<String, dynamic>? data) async {
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
        print(json.encode(response.data));
      } else {
        print(response.statusMessage);
      }
      return response;
    } catch (e) {
      return {};
    }
  }

  Future generateAccessToken() async {
    try {
      var headers = {
        'Content-Type': 'application/x-www-form-urlencoded',
      };
      var data = {
        'grant_type': 'client_credentials',
        'client_id': '9434fb590d3841d786bdb22d7c7fdb59',
        'client_secret': 'd85f058d4fcf451790cd06998598261e'
      };
      final response = await request("https://accounts.spotify.com",
          "/api/token", MethodType.POST.name, headers, data);
      print(response.toString());
      return response["access_token"];
    } catch (e) {
      print("error");
    }
  }

  Future handleResponse(Response response) async {}
}
