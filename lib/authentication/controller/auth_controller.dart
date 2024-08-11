import 'package:get/get.dart';
import 'package:tmoose/authentication/repository/auth_repository.dart';
import 'package:tmoose/helpers/deeplink_handler.dart';

class AuthController extends GetxController {
  @override
  void onInit() {
    RedirectUriListener.init();
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    RedirectUriListener.dispose();
    super.onClose();
  }

  void handeSpotifyAuthNavigation() async {
    await AuthenticationRepository().requestUserAuthorization();
  }
}
