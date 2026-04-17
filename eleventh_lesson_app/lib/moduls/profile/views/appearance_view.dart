import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/appearance_controller.dart';
import '../../../app/theme/colors.dart';

class AppearanceView extends GetView<AppearanceController> {

  const AppearanceView({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: AppColors.backgroundDark,

      appBar: AppBar(
        title: const Text("Appearance"),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),

        child: Column(
          children: [

            const SizedBox(height: 10),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.cardDark,
                borderRadius: BorderRadius.circular(14),
              ),

              child: Obx(() {

                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [

                    const Text(
                      "Dark Mode",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),

                    Switch(
                      value: controller.isDarkMode.value,
                      onChanged: controller.toggleTheme,
                    )

                  ],
                );

              }),
            ),

            const SizedBox(height: 20),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.cardDark,
                borderRadius: BorderRadius.circular(14),
              ),

              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Text(
                    "Theme Options",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  SizedBox(height: 8),

                  Text(
                    "You can switch between light and dark theme for better readability.",
                    style: TextStyle(
                      color: Colors.white54,
                    ),
                  ),

                ],
              ),
            ),

          ],
        ),
      ),

    );
  }
}