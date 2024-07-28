import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/route_manager.dart';
import 'package:tmoose/routes/app_pages.dart';
import 'package:tmoose/routes/app_routes.dart';

void main() {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  initializeMyMusicApp();
}

void initializeMyMusicApp() async {
  
  //do all initializtions
  FlutterNativeSplash.remove();
  runApp(const Startup());
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
