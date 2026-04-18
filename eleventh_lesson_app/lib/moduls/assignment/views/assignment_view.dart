import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../controllers/assignment_controller.dart';
import '../../../data/models/assignment_model.dart';
import 'my_submissions_view.dart';
import 'grade_submissions_view.dart';

class AssignmentView extends GetView<AssignmentController> {
  const AssignmentView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cardColor = theme.cardColor;
    final textColor = theme.textTheme.bodyMedium?.color;
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,

      appBar: AppBar(
        title: const Text("Assignments"),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(icon: const Icon(Icons.history), onPressed: () => Get.to(() => const MySubmissionsView())),
          Obx(() => controller.isTeacher
              ? IconButton(icon: const Icon(Icons.add), onPressed: _showCreateAssignmentDialog)
              : const SizedBox.shrink()),
        ],
      ),

      body: Obx(() {
        if (controller.isLoading.value) return const Center(child: CircularProgressIndicator());

        if (controller.assignments.isEmpty) {
          return Center(child: Text("No assignments available", style: TextStyle(color: textColor?.withValues(alpha: 0.7))));
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: controller.assignments.length,
          itemBuilder: (context, index) {
            final assignment = controller.assignments[index];

            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: cardColor, borderRadius: BorderRadius.circular(16)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    assignment.title,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textColor),
                  ),
                  const SizedBox(height: 8),
                  Text(assignment.description, style: TextStyle(color: textColor?.withValues(alpha: 0.7))),
                  const SizedBox(height: 10),
                  Text(
                    "Due: ${assignment.dueDate.toLocal().toString().split(' ')[0]}",
                    style: const TextStyle(color: Colors.orange),
                  ),
                  const SizedBox(height: 10),
                  Obx(() {
                    final isTeacher = controller.isTeacher;
                    return Row(
                      children: [
                        if (assignment.fileUrl != null && assignment.fileUrl!.isNotEmpty)
                          IconButton(
                            icon: const Icon(Icons.open_in_new, color: Colors.blue),
                            onPressed: () async => await launchUrl(Uri.parse(assignment.fileUrl!)),
                          ),
                        if (!isTeacher)
                          IconButton(
                            icon: const Icon(Icons.upload, color: Colors.green),
                            onPressed: () => _submitAssignment(assignment.id, assignment.courseId ?? "mad101"),
                          ),
                        if (isTeacher) ...[
                          IconButton(
                            icon: const Icon(Icons.rate_review, color: Colors.amber),
                            onPressed: () => Get.to(() => GradeSubmissionsView(assignmentId: assignment.id)),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => controller.deleteAssignment(assignment.id),
                          ),
                        ],
                      ],
                    );
                  }),
                ],
              ),
            );
          },
        );
      }),
    );
  }