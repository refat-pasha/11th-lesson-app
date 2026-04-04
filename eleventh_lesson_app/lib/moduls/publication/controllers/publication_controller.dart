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