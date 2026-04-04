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