import 'package:get/get.dart';
import 'package:tmoose/helpers/page_helper.dart';
import 'package:tmoose/music_player/controller/music_player_controller.dart';

class MusicPlayerBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<MusicPlayerController>(
      MusicPlayerController(),
      tag: MusicPlayerHelper.uniqueid,
    );
  }
}
