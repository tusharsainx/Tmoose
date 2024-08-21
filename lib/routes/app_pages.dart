import 'package:get/route_manager.dart';
import 'package:tmoose/artists/binding/artist_view_binding.dart';
import 'package:tmoose/artists/view/artist_view.dart';
import 'package:tmoose/authentication/bindings/auth_binding.dart';
import 'package:tmoose/authentication/middleware/auth_middleware.dart';
import 'package:tmoose/authentication/views/auth_view.dart';
import 'package:tmoose/home/bindings/home_binding.dart';
import 'package:tmoose/home/views/home_view.dart';
import 'package:tmoose/routes/app_routes.dart';
import 'package:tmoose/tracks/binding/track_view_binding.dart';
import 'package:tmoose/tracks/view/tracks_view.dart';

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
    GetPage(
      name: AppRoutes.track,
      page: () => const TrackPage(),
      binding: TrackPageBinding(),
    ),
    GetPage(
      name: AppRoutes.artist,
      page: () => const ArtistPage(),
      binding: ArtistViewBinding(),
    ),
  ];
}
