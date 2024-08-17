import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/route_manager.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:tmoose/authentication/models/auth_models.dart';
import 'package:tmoose/routes/app_pages.dart';
import 'package:tmoose/routes/app_routes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  initializeMyMusicApp();
}

void initializeMyMusicApp() async {
  //do all initializtions
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await Hive.initFlutter();
  _registerAdapters();
  await _openBoxes();
  FlutterNativeSplash.remove();
  runApp(const Startup());
}

void _registerAdapters() {
  Hive.registerAdapter(CodeVerifierModelAdapter());
  Hive.registerAdapter(TokenModelAdapter());
}

Future<void> _openBoxes() async {
  await Hive.openBox<CodeVerifierModel>("CodeVerifierModel");
  await Hive.openBox<TokenModel>("TokenModel");
}

class Startup extends StatelessWidget {
  const Startup({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'T-Moose',
      getPages: AppPages.pages,
      initialRoute: AppRoutes.home,
      theme: ThemeData.dark(),
    );
  }
}
