import 'package:uuid/uuid.dart';

class ArtistPageHelper {
  static String uniqueid = "0";
  static void setUniqueId() {
    uniqueid = const Uuid().v4();
  }
}
