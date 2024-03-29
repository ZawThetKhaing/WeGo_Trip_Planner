import 'package:get/get.dart';
import 'package:we_go/binding/trip_plan_binding.dart';
import 'package:we_go/binding/app_binding.dart';
import 'package:we_go/binding/login_binding.dart';
import 'package:we_go/screen/about_screen.dart';
import 'package:we_go/screen/change_password_screen.dart';
import 'package:we_go/screen/edit_profile_screen.dart';
import 'package:we_go/screen/home_screen.dart';
import 'package:we_go/screen/invite_friend_screen.dart';
import 'package:we_go/screen/login_screen.dart';
import 'package:we_go/screen/sign_up_screen.dart';
import 'package:we_go/screen/trip_plan_screen.dart';
import 'package:we_go/screen/wrapper_screen.dart';

abstract class AppRoutes {
  static const String home = '/home';
  static const String login = '/login';
  static const String signUp = '/signUp';
  static const String wrapper = '/wrapper';
  static const String tripPlanScreen = '/tripPlanScreen';
  static const String inviteFriend = '/inviteFriend';
  static const String changePassword = '/changePassword';
  static const String about = '/about';
  static const String editProfile = '/editProfile';

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
        TripPlanBinding(),
      ],
    ),
    GetPage(
      name: tripPlanScreen,
      page: () => const TripPlanScreen(),
      bindings: [
        AppBinding(),
        TripPlanBinding(),
      ],
    ),
    GetPage(
      name: inviteFriend,
      page: () => const InviteFriendScreen(),
      bindings: [
        AppBinding(),
        TripPlanBinding(),
      ],
    ),
    GetPage(
      name: changePassword,
      page: () => const ChangePassword(),
      bindings: [
        AppBinding(),
      ],
    ),
    GetPage(
      name: about,
      page: () => const AboutScreen(),
      bindings: [
        AppBinding(),
      ],
    ),
    GetPage(
      name: editProfile,
      page: () => const EditProfileScreen(),
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
