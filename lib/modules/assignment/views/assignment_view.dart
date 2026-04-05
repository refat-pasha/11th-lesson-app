// placeholder
// lib/modules/assignment/views/assignment_view.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/assignment_controller.dart';
import '../../../app/theme/colors.dart';

class AssignmentView extends GetView<AssignmentController> {
  const AssignmentView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      appBar: AppBar(
        title: const Text("Assignments"),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (controller.assignments.isEmpty) {
          return const Center(
            child: Text(
              "No assignments available",
              style: TextStyle(color: Colors.white70),
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: controller.assignments.length,
          itemBuilder: (context, index) {
            final assignment = controller.assignments[index];

            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.cardDark,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    assignment.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    assignment.description,
                    style: const TextStyle(
                      color: Colors.white70,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Due: ${assignment.dueDate.toLocal().toString().split(' ')[0]}",
                        style: const TextStyle(
                          color: Colors.orange,
                          fontSize: 12,
                        ),
                      ),

                      IconButton(
                        icon: const Icon(
                          Icons.delete,
                          color: Colors.red,
                        ),
                        onPressed: () {
                          controller.deleteAssignment(assignment.id);
                        },
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      }),
    );
  }
}