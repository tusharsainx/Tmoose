import 'package:uuid/uuid.dart';

class ArtistPageHelper {
  static String uniqueid = "0";
  static void setUniqueId() {
    uniqueid = const Uuid().v4();
  }
}

class TrackPageHelper {
  static String uniqueid = "0";
  static void setUniqueId() {
    uniqueid = const Uuid().v4();
  }
}

class MusicPlayerHelper {
  static String uniqueid = "0";
  static void setUniqueId() {
    uniqueid = const Uuid().v4();
  }
}
