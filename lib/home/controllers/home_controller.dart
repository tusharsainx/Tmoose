import 'package:get/get.dart';
import 'package:tmoose/helpers/deeplink_handler.dart';

class HomeController extends GetxController {
  @override
  void onInit() {
    RedirectUriListener.init();
    super.onInit();
  }
}
