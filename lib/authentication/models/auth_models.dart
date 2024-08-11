import 'package:hive/hive.dart';
part 'auth_models.g.dart';

@HiveType(typeId: 0)
class CodeVerifierModel extends HiveObject {
  @HiveField(0)
  final String codeVerifier;
  CodeVerifierModel({
    required this.codeVerifier,
  });
}

@HiveType(typeId: 1)
class TokenModel extends HiveObject {
  @HiveField(0)
  String? accessToken;

  @HiveField(1)
  String? refreshToken;
  TokenModel({
    this.refreshToken,
    this.accessToken,
  });
}
