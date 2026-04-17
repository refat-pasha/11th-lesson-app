import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/splash_controller.dart';
import '../../../app/theme/colors.dart';

class SplashView extends StatelessWidget {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    final SplashController controller = Get.find<SplashController>();

    /// Force splash flow after first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.checkUserFlow();
    });

    return const 
    Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children:  [
            Icon(
              Icons.school,
              size: 80,
              color: Colors.white,
            ),
            SizedBox(height: 20),
            Text(
              "11th Lesson",
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 10),
            Text(
              "Learn Faster. Learn Smarter.",
              style: TextStyle(
                color: Colors.white70,
                fontSize: 16,
              ),
            ),
            SizedBox(height: 40),
            CircularProgressIndicator(
              color: Colors.deepPurpleAccent,
            ),
          ],
        ),
      ),
    );
  }
}