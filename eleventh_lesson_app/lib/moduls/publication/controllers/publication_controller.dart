import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../../../data/providers/firebase_provider.dart';

class PublicationController extends GetxController {

  /// Firebase Provider
  final FirebaseProvider firebaseProvider = Get.find();

  /// Text Controllers
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final tagsController = TextEditingController();

  /// Selected File
  PlatformFile? selectedFile;

  /// UI State
  var fileName = "".obs;
  var isUploading = false.obs;

  /// Dropdown values
  var category = "Lecture Notes".obs;
  var selectedCourse = "CSE 221".obs;
  var visibility = "My Courses".obs;

  /// Dropdown options
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

/// Pick File
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

  /// Upload Material
  Future<void> uploadMaterial() async {

    if (selectedFile == null) {
      Get.snackbar("Error", "Please select a file");
      return;
    }

    if (titleController.text.isEmpty) {
      Get.snackbar("Error", "Title is required");
      return;
    }

    try {

      isUploading.value = true;

      /// Current user
      final user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        Get.snackbar("Error", "User not logged in");
        return;
      }

      final userId = user.uid;

      /// Storage path
      final storageRef = FirebaseStorage.instance
          .ref()
          .child("materials/${selectedCourse.value}/${selectedFile!.name}");

      /// Upload file
      final uploadTask =
          await storageRef.putData(selectedFile!.bytes!);

      /// Get download URL
      final downloadUrl = await uploadTask.ref.getDownloadURL();

      /// Save metadata to Firestore
      await firebaseProvider.materials().add({

        "title": titleController.text,
        "description": descriptionController.text,
        "category": category.value,
        "courseId": selectedCourse.value,
        "visibility": visibility.value,
        "tags": tagsController.text.split(","),
        "fileName": selectedFile!.name,
        "fileUrl": downloadUrl,
        "uploadedBy": userId,
        "createdAt": DateTime.now(),

      });