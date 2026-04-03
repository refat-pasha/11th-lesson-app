import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';

import 'app/routes/app_pages.dart';
import 'app/bindings/initial_binding.dart';
import 'app/theme/colors.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();

  /// Initialize Firebase
  await Firebase.initializeApp();

  runApp(const EleventhLessonApp());
}

class EleventhLessonApp extends StatelessWidget {
  const EleventhLessonApp({super.key});

  @override
  Widget build(BuildContext context) {

    return GetMaterialApp(

      title: "11th Lesson LMS",

      debugShowCheckedModeBanner: false,

      /// INITIAL DEPENDENCIES
      initialBinding: InitialBinding(),

      /// ROUTES
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,

      /// THEMES
      theme: ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: Colors.white,
        primaryColor: Colors.blue,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 0,
        ),
      ),

      darkTheme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: AppColors.backgroundDark,
        primaryColor: Colors.blue,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.white,
          elevation: 0,
        ),
      ),

      /// Default Theme
      themeMode: ThemeMode.dark,

    );
  }
}