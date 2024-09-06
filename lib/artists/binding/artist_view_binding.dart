import 'package:get/get.dart';
import 'package:tmoose/artists/controller/artist_view_controller.dart';
import 'package:tmoose/helpers/page_helper.dart';

class ArtistViewBinding extends Bindings {
  ArtistViewBinding();
  @override
  void dependencies() {
    Get.put<ArtistViewController>(
      ArtistViewController(),
      tag: ArtistPageHelper.uniqueid,
    );
  }
}
