import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../data/providers/firebase_provider.dart';
import '../../../core/services/google_drive_service.dart';
import 'dart:io';
import 'dart:typed_data';

class PublicationController extends GetxController {

  /// Firebase Provider
  final FirebaseProvider firebaseProvider = Get.find();

  /// Google Drive Service
  final GoogleDriveService _driveService = GoogleDriveService();

  /// ================= USER ROLE =================
  final RxString userRole = "student".obs;

  /// ================= TEXT CONTROLLERS =================
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final tagsController = TextEditingController();

  /// ================= FILE =================
  PlatformFile? selectedFile;

  /// ================= UI STATE =================
  var fileName = "".obs;
  var isUploading = false.obs;

  /// ================= DROPDOWN =================
  var category = "Lecture Notes".obs;
  var selectedCourse = "CSE 221".obs;
  var visibility = "My Courses".obs;

  final categories = [
    "Lecture Notes",
    "Slides",
    "Assignment",
    "Exam Prep",
  ];

  final courseNames = [
    "CSE 221",
    "MATH 301",
    "CSE 341",
  ];

  final visibilityOptions = [
    "My Courses",
    "Public",
    "Private"
  ];

  /// ================= INIT =================
  @override
  void onInit() {
    super.onInit();
    fetchUserRole();
  }

  /// ================= FETCH ROLE =================
  Future<void> fetchUserRole() async {
    try {
      final user = FirebaseAuth.instance.currentUser;

      if (user == null) return;

      final userDoc = await firebaseProvider.users().doc(user.uid).get();

      final data = userDoc.data() as Map<String, dynamic>?;

      if (data != null && data["role"] != null) {
        userRole.value = data["role"];
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to load user role");
    }
  }

  /// ================= PICK FILE =================
  Future<void> pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      withData: true,
    );

    if (result != null) {
      selectedFile = result.files.first;
      fileName.value = selectedFile!.name;
    }
  }
