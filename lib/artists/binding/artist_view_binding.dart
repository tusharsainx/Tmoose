import 'package:get/get.dart';
import 'package:tmoose/artists/controller/artist_view_controller.dart';

class ArtistViewBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<ArtistViewController>(
      ArtistViewController(),
    );
  }
}
