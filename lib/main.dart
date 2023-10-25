import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:social_hub/routes/routes.dart';
import 'package:social_hub/theme/appTheme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Platform.isAndroid
      ? await Firebase.initializeApp(
          options: const FirebaseOptions(
            apiKey: "AIzaSyA2MP3AqpSpHicH35e5qAs-oRwlCxa7Beg",
            appId: "1:548767648028:android:85099ed2d974beec9cd2d9",
            messagingSenderId: "548767648028",
            projectId: "trip-planner-app-54f21",
          ),
        )
      : await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      getPages: AppRoutes.getPages,
      initialRoute: AppRoutes.wrapper,
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          foregroundColor: Colors.black,
          backgroundColor: Colors.white,
          elevation: 0,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(
              AppTheme.buttonColor,
            ),
            overlayColor: MaterialStateProperty.all(
              Colors.transparent,
            ),
            elevation: MaterialStateProperty.all(0),
            textStyle: MaterialStateProperty.all(
              const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: ButtonStyle(
            overlayColor: MaterialStateProperty.all(
              Colors.transparent,
            ),
          ),
        ),
        inputDecorationTheme: AppTheme.inputDecorationTheme,
      ),
    );
  }
}
