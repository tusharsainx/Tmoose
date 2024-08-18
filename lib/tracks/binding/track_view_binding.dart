import 'package:get/get.dart';
import 'package:tmoose/tracks/controller/tracks_view_controller.dart';

class TrackPageBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(TrackPageController());
  }
}
