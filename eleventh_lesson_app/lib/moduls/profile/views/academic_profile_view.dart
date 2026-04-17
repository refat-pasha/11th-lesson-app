import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/academic_profile_controller.dart';
import '../../../app/theme/colors.dart';

class AcademicProfileView extends GetView<AcademicProfileController> {
  const AcademicProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      appBar: AppBar(
        title: const Text("Academic Profile"),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: Obx(() {
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              const Text(
                "Manage your academic information",
                style: TextStyle(color: Colors.white70),
              ),

              const SizedBox(height: 20),

              TextField(
                controller: controller.universityController,
                style: const TextStyle(color: Colors.white),
                decoration: _inputDecoration(
                  "University",
                  "Enter your university name",
                ),
              ),

              const SizedBox(height: 16),

              TextField(
                controller: controller.departmentController,
                style: const TextStyle(color: Colors.white),
                decoration: _inputDecoration(
                  "Department",
                  "e.g. CSE",
                ),
              ),

              const SizedBox(height: 16),

              TextField(
                controller: controller.semesterController,
                style: const TextStyle(color: Colors.white),
                decoration: _inputDecoration(
                  "Semester",
                  "e.g. 5th Semester",
                ),
              ),

              const SizedBox(height: 16),

              TextField(
                controller: controller.subjectsController,
                style: const TextStyle(color: Colors.white),
                maxLines: 3,
                decoration: _inputDecoration(
                  "Subjects (comma separated)",
                  "e.g. AI, DBMS, Computer Networks",
                ),
              ),

              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: controller.isLoading.value
                      ? null
                      : controller.saveAcademicInfo,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                  ),
                  child: controller.isLoading.value
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text("Save Academic Info"),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  InputDecoration _inputDecoration(String label, String hint) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      labelStyle: const TextStyle(color: Colors.white70),
      hintStyle: const TextStyle(color: Colors.white38),
      filled: true,
      fillColor: AppColors.cardDark,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
    );
  }
}