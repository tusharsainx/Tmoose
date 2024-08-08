class SessionManagerHelper {
  static SessionManagerHelper? _instance;
  SessionManagerHelper._internal();
  factory SessionManagerHelper() {
    return _instance ??= SessionManagerHelper._internal();
  }
  String? token;
  
}
