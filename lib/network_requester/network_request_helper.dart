import 'package:dio/dio.dart';

abstract interface class NetworkRequesterBase {
  Future get(String baseUrl, String path);
  Future post(String baseUrl, String path, Map<String, dynamic> payload);
}

class NetworkRequester implements NetworkRequesterBase {
  Dio _dio = Dio();
  NetworkRequester() {
    _dio = Dio();
  }

  @override
  Future get(String baseUrl, String path) async {
    try{
    Response response = await _dio.get('$baseUrl$path');
    handleResponse(response);
    }catch(e){
      
    }
  }

  @override
  Future post(String baseUrl, String path, Map<String, dynamic> payload) {
    // TODO: implement post
    throw UnimplementedError();
  }

  Future handleResponse(Response response) async {}
}
