import 'package:get/get.dart';
import 'package:social_hub/binding/app_binding.dart';
import 'package:social_hub/binding/login_binding.dart';
import 'package:social_hub/screen/home_screen.dart';
import 'package:social_hub/screen/login_screen.dart';
import 'package:social_hub/screen/sign_up_screen.dart';
import 'package:social_hub/screen/wrapper_screen.dart';

abstract class AppRoutes {
  static const String home = '/home';
  static const String login = '/login';
  static const String signUp = '/signUp';
  static const String wrapper = '/wrapper';

  static List<GetPage> getPages = [
    GetPage(
      name: wrapper,
      page: () => const WrapperScreen(),
      bindings: [
        AppBinding(),
      ],
    ),
    GetPage(
      name: home,
      page: () => const HomeScreen(),
      bindings: [
        AppBinding(),
      ],
    ),
    GetPage(
      name: login,
      page: () => const LoginScreen(),
      bindings: [
        LoginBinding(),
      ],
    ),
    GetPage(
      name: signUp,
      page: () => const SignUpScreen(),
    ),
  ];
}
