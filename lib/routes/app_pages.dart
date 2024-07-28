import 'package:get/route_manager.dart';
import 'package:tmoose/home/bindings/home_binding.dart';
import 'package:tmoose/home/views/home_view.dart';
import 'package:tmoose/routes/app_routes.dart';

class AppPages {
  static List<GetPage> pages = [
    GetPage(
      name: AppRoutes.home,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
  ];
}
