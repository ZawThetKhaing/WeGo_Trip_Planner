import 'package:get/get.dart';
import 'package:we_go/binding/app_binding.dart';
import 'package:we_go/binding/login_binding.dart';
import 'package:we_go/screen/home_screen.dart';
import 'package:we_go/screen/login_screen.dart';
import 'package:we_go/screen/sign_up_screen.dart';
import 'package:we_go/screen/wrapper_screen.dart';

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
