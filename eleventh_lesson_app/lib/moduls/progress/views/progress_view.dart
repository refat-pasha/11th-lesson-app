import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/progress_controller.dart';
import '../../../app/theme/colors.dart';

class ProgressView extends GetView<ProgressController> {
  const ProgressView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: SafeArea(
        child: Obx(() {

          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          final user = controller.user.value;

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [

              /// TITLE
              const Text(
                "Progress & Analytics",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 4),

              const Text(
                "Your academic performance overview",
                style: TextStyle(color: Colors.white70),
              ),

              const SizedBox(height: 24),

              /// COURSE MILESTONES
              const Text(
                "Course Milestones",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),

              const SizedBox(height: 16),

              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                children: controller.courses.map((course) {

                  final progress = controller.getProgress(course.id);

                  return milestoneCard(
                    progress,
                    course.code,
                    course.title,
                  );

                }).toList(),
              ),

              const SizedBox(height: 30),

              /// WEEKLY GRAPH
              const Text(
                "Weekly Graph",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),

              const SizedBox(height: 12),

              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.cardDark,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [

                    bar(0.2),
                    bar(0.5),
                    bar(0.7),
                    bar(0.3),
                    bar(0.6),
                    bar(0.1),
                    bar(0.8),

                  ],
                ),
              ),

              const SizedBox(height: 30),

              /// XP SECTION
              const Text(
                "XP & Level",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),

              const SizedBox(height: 12),

              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.cardDark,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [

                        Text(
                          "${user?.xp ?? 0} / 3500 XP",
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const Text(
                          "Lv. 8 • Scholar",
                          style: TextStyle(
                            color: Colors.orange,
                            fontWeight: FontWeight.bold,
                          ),
                        )

                      ],
                    ),

                    const SizedBox(height: 10),

                    LinearProgressIndicator(
                      value: (user?.xp ?? 0) / 3500,
                      minHeight: 8,
                      backgroundColor: Colors.white12,
                    ),

                    const SizedBox(height: 6),

                    const Text(
                      "680 XP to reach Level 9 — Expert",
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    )

                  ],
                ),
              ),

              const SizedBox(height: 30),

            ],
          );
        }),
      ),
    );
  }
  /// COURSE MILESTONE CARD
  Widget milestoneCard(double progress, String code, String title) {

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardDark,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          const Icon(Icons.school, color: Colors.white),

          const SizedBox(height: 10),

          Text(
            "${(progress * 100).toInt()}%",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),

          Text(
            "$code • $title",
            style: const TextStyle(color: Colors.white70),
          ),

          const SizedBox(height: 10),

          LinearProgressIndicator(
            value: progress,
            backgroundColor: Colors.white12,
          )

        ],
      ),
    );
  }