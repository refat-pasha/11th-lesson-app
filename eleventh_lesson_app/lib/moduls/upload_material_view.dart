import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/publication_controller.dart';
import '../../../app/theme/colors.dart';

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
        title: const Text("Upload Content"),
      ),
      body: Obx(() {
        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const Text(
              "Share notes, files & resources with your class",
              style: TextStyle(color: Colors.white70),
            ),

            const SizedBox(height: 20),

            /// FILE UPLOAD BOX
            GestureDetector(
              onTap: controller.pickFile,
              child: Container(
                padding: const EdgeInsets.all(30),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.blueAccent,
                    style: BorderStyle.solid,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: const [
                    Icon(
                      Icons.folder,
                      size: 48,
                      color: Colors.orange,
                    ),
                    SizedBox(height: 12),
                    Text(
                      "Tap to upload files",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(
                      "PDFs, notes, images, audio, video",
                      style: TextStyle(color: Colors.white70),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            /// TITLE
            TextField(
              controller: controller.titleController,
              decoration: inputDecoration(
                "Title",
                "e.g. DSA Chapter 7 — Binary Trees Notes",
              ),
            ),

            const SizedBox(height: 16),

            /// DESCRIPTION
            TextField(
              controller: controller.descriptionController,
              maxLines: 3,
              decoration: inputDecoration(
                "Description",
                "Describe this material briefly...",
              ),
            ),

            const SizedBox(height: 16),

            /// CATEGORY
            DropdownButtonFormField<String>(
              dropdownColor: AppColors.cardDark,
              value: controller.category.value,
              decoration: inputDecoration("Category", ""),
              items: controller.categories
                  .map((e) => DropdownMenuItem(
                        value: e,
                        child: Text(e),
                      ))
                  .toList(),
              onChanged: (value) {
                controller.category.value = value!;
              },
            ),

            const SizedBox(height: 16),

            /// COURSE
            DropdownButtonFormField<String>(
              dropdownColor: AppColors.cardDark,
              value: controller.selectedCourse.value,
              decoration: inputDecoration("Course", ""),
              items: controller.courseNames
                  .map((e) => DropdownMenuItem(
                        value: e,
                        child: Text(e),
                      ))
                  .toList(),
              onChanged: (value) {
                controller.selectedCourse.value = value!;
              },
            ),

            const SizedBox(height: 16),

            /// TAGS
            TextField(
              controller: controller.tagsController,
              decoration: inputDecoration(
                "Tags",
                "e.g. midterm, trees, recursion",
              ),
            ),

            const SizedBox(height: 20),

            /// SELECTED FILE
            if (controller.fileName.value.isNotEmpty)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.cardDark,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.insert_drive_file, color: Colors.orange),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        controller.fileName.value,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                    const Icon(Icons.check, color: Colors.green),
                  ],
                ),
              ),

            const SizedBox(height: 30),

            /// PUBLISH BUTTON
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: Colors.blueAccent,
              ),
              onPressed: controller.uploadMaterial,
              child: const Text("Publish Material"),
            ),
          ],
        );
      }),
    );
  }

  InputDecoration inputDecoration(String label, String hint) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      filled: true,
      fillColor: AppColors.cardDark,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }
}
