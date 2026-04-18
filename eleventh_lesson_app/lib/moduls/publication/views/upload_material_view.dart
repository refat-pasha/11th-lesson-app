import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_storage/get_storage.dart';

import '../controllers/publication_controller.dart';
import '../../../app/theme/colors.dart';
import '../../../core/services/download_service.dart';
import '../../../core/services/file_service.dart';

class UploadMaterialView extends GetView<PublicationController> {
  const UploadMaterialView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),

        /// ROLE BASED TITLE
        title: Obx(() {
          final isTeacher = controller.userRole.value == "teacher";
          return Text(isTeacher ? "Upload Content" : "Study Materials");
        }),
      ),

      body: Obx(() {
        final isTeacher = controller.userRole.value == "teacher";
        return isTeacher ? _buildUploadUI() : _buildStudentUI();
      }),
    );
  }

  /// ================= TEACHER UI =================
  Widget _buildUploadUI() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text(
          "Share notes, files & resources with your class",
          style: TextStyle(color: Colors.white70),
        ),

        const SizedBox(height: 20),

        GestureDetector(
          onTap: controller.pickFile,
          child: Container(
            padding: const EdgeInsets.all(30),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.blueAccent),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Column(
              children: [
                Icon(Icons.folder, size: 48, color: Colors.orange),
                SizedBox(height: 12),
                Text("Tap to upload files",
                    style: TextStyle(color: Colors.white)),
              ],
            ),
          ),
        ),

        const SizedBox(height: 20),

        TextField(
          controller: controller.titleController,
          decoration: inputDecoration("Title", "Enter material title"),
        ),

        const SizedBox(height: 16),

        TextField(
          controller: controller.descriptionController,
          maxLines: 3,
          decoration: inputDecoration("Description", "Describe material"),
        ),

        const SizedBox(height: 16),

        DropdownButtonFormField<String>(
          dropdownColor: AppColors.cardDark,
          value: controller.category.value,
          decoration: inputDecoration("Category", ""),
          items: controller.categories
              .map((e) => DropdownMenuItem(value: e, child: Text(e)))
              .toList(),
          onChanged: (value) => controller.category.value = value!,
        ),

        const SizedBox(height: 16),
