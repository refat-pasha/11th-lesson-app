import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/offline_controller.dart';
import '../../../app/theme/colors.dart';

class OfflineView extends GetView<OfflineController> {
  const OfflineView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      appBar: AppBar(
        title: const Text("Offline Materials"),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.offlineMaterials.isEmpty) {
          return const Center(
            child: Text(
              "No offline materials",
              style: TextStyle(color: Colors.white70),
            ),
          );
        }