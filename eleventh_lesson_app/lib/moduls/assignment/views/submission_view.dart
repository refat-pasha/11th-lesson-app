import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';

class SubmissionView extends StatelessWidget {
  final String assignmentId;

  const SubmissionView({super.key, required this.assignmentId});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cardColor = theme.cardColor;
    final textColor = theme.textTheme.bodyMedium?.color;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(title: const Text("Submissions"), backgroundColor: Colors.transparent, elevation: 0),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('assignment_submissions')
            .where("assignmentId", isEqualTo: assignmentId)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

          final submissions = snapshot.data!.docs;

          if (submissions.isEmpty) {
            return Center(child: Text("No submissions yet", style: TextStyle(color: textColor?.withValues(alpha: 0.7))));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: submissions.length,
            itemBuilder: (context, index) {
              final data = submissions[index].data();

              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: cardColor, borderRadius: BorderRadius.circular(12)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Student ID: ${data['userId'] ?? 'Unknown'}", style: TextStyle(color: textColor)),
                    const SizedBox(height: 6),
                    Text(
                      "Submitted: ${data['submittedAt'] != null ? (data['submittedAt'] as Timestamp).toDate().toString().split(' ')[0] : ''}",
                      style: TextStyle(color: textColor?.withValues(alpha: 0.7)),
                    ),
                    const SizedBox(height: 10),
                    if (data['fileUrl'] != null)
                      TextButton(
                        onPressed: () => Get.to(() => _FileViewer(url: data['fileUrl'])),
                        child: const Text("View File"),
                      ),
                    const SizedBox(height: 10),
                    TextField(
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: "Grade"),
                      onSubmitted: (value) async {
                        await FirebaseFirestore.instance
                            .collection('assignment_submissions')
                            .doc(submissions[index].id)
                            .update({"grade": int.parse(value), "gradedAt": FieldValue.serverTimestamp()});
                        Get.snackbar("Success", "Graded");
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _submitAssignment(),
        child: const Icon(Icons.upload),
      ),
    );
  }