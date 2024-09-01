import 'package:get/get.dart';
import 'package:tmoose/authentication/repository/auth_repository.dart';
import 'package:tmoose/helpers/deeplink_handler.dart';

class AuthController extends GetxController {
  late AuthenticationRepository _authenticationRepository;
  @override
  void onInit() {
    _authenticationRepository = AuthenticationRepository();
    RedirectUriListener.init();
    super.onInit();
  }

  @override
  void onClose() {
    RedirectUriListener.dispose();
    super.onClose();
  }

  void handeSpotifyAuthNavigation() async {
    await _authenticationRepository.requestUserAuthorization();
  }
}
