import 'package:get/route_manager.dart';
import 'package:tmoose/authentication/bindings/auth_binding.dart';
import 'package:tmoose/authentication/middleware/auth_middleware.dart';
import 'package:tmoose/authentication/views/auth_view.dart';
import 'package:tmoose/home/bindings/home_binding.dart';
import 'package:tmoose/home/views/home_view.dart';
import 'package:tmoose/routes/app_routes.dart';

class AppPages {
  static List<GetPage> pages = [
    GetPage(
      name: AppRoutes.home,
      page: () => const HomeView(),
      binding: HomeBinding(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: AppRoutes.auth,
      page: () => const AuthView(),
      binding: AuthBinding(),
    ),
  ];
}
