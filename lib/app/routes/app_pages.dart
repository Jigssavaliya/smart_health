import 'package:get/get.dart';

import '../modules/calories_screen/bindings/calories_screen_binding.dart';
import '../modules/calories_screen/views/calories_screen_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/login/bindings/login_binding.dart';
import '../modules/login/views/login_view.dart';
import '../modules/profile_screen/bindings/profile_screen_binding.dart';
import '../modules/profile_screen/views/profile_screen_view.dart';
import '../modules/sleep/bindings/sleep_binding.dart';
import '../modules/sleep/views/sleep_view.dart';
import '../modules/splash/bindings/splash_binding.dart';
import '../modules/splash/views/splash_view.dart';
import '../modules/waking_activity/bindings/waking_activity_binding.dart';
import '../modules/waking_activity/views/waking_activity_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.SPLASH;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => const LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.SLEEP,
      page: () => const SleepView(),
      binding: SleepBinding(),
    ),
    GetPage(
      name: _Paths.WAKING_ACTIVITY,
      page: () => const WalkingActivityView(),
      binding: WakingActivityBinding(),
    ),
    GetPage(
      name: _Paths.CALORIES_SCREEN,
      page: () => const CaloriesScreen(),
      binding: CaloriesScreenBinding(),
    ),
    GetPage(
      name: _Paths.PROFILE_SCREEN,
      page: () => const ProfileScreenView(),
      binding: ProfileScreenBinding(),
    ),
    GetPage(
      name: _Paths.SPLASH,
      page: () => const SplashView(),
      binding: SplashBinding(),
    ),
  ];
}
