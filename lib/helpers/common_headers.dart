import 'package:hive/hive.dart';
import 'package:tmoose/authentication/models/auth_models.dart';

class CommonHeaders {
  Map<String, dynamic>? getDefaultHeaders(
      Map<String, dynamic>? currentHeaders) {
    final tokenModel =
        Hive.box<TokenModel>("TokenModel").get("tokens") as TokenModel;
    if (tokenModel.accessToken == null) return currentHeaders;
    Map<String, dynamic> headers = {
      if (currentHeaders != null) ...currentHeaders,
      "Authorization": "Bearer ${tokenModel.accessToken}",
    };
    return headers;
  }
}
