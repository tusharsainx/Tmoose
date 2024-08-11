import 'package:get/get.dart';
import 'package:tmoose/authentication/controller/auth_controller.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(AuthController());
  }
}
