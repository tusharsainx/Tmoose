import 'package:get/get.dart';
import 'package:tmoose/home/controllers/home_controller.dart';
import 'package:tmoose/moodify_home/controller/moodify_home_controller.dart';
import 'package:tmoose/offline/controller/offline_music_controller.dart';
import 'package:tmoose/playlists/controller/playlist_controller.dart';
import 'package:tmoose/user/controllers/user_profile_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UserProfileController>(() => UserProfileController());
    Get.lazyPut<MoodifyHomeController>(() => MoodifyHomeController());
    Get.lazyPut<OfflineMusicController>(() => OfflineMusicController());
    Get.lazyPut<PlaylistController>(() => PlaylistController());
    Get.lazyPut<HomeController>(() => HomeController());
  }
}
