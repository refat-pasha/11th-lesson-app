import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/routes/app_routes.dart';
import '../../../core/controllers/lms_controller.dart';

class AuthController extends GetxController {
  final LmsController _lms = Get.find<LmsController>();

  final isLoading = false.obs;
  final selectedRole = 'student'.obs;
  final setupStep = 0.obs;

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();
  final universityController = TextEditingController(text: 'DIU');
  final departmentController = TextEditingController(text: 'CSE');
  final semesterController = TextEditingController(text: '11th');
  final programController = TextEditingController(text: 'B.Sc in CSE');
  final sectionController = TextEditingController(text: '63_J');
  final subjectsController = TextEditingController(text: 'CSE 221, CSE 341, MATH 301');

  final language = 'English'.obs;
  final dailyGoalMinutes = 90.obs;
  final deadlineReminders = true.obs;
  final autoDownload = false.obs;
  final streakAlerts = true.obs;
  final darkMode = true.obs;

  final loginFormKey = GlobalKey<FormState>();
  final registerFormKey = GlobalKey<FormState>();

  List<String> get subjectList => subjectsController.text
      .split(',')
      .map((e) => e.trim())
      .where((e) => e.isNotEmpty)
      .toList();

  void nextStep() {
    if (setupStep.value < 2) {
      setupStep.value++;
    } else {
      completeProfile();
    }
  }

  void previousStep() {
    if (setupStep.value > 0) {
      setupStep.value--;
    }
  }

  Future<void> login() async {
    if (!loginFormKey.currentState!.validate()) return;
    try {
      isLoading.value = true;
      await _lms.login(emailController.text.trim(), passwordController.text.trim());
      Get.offAllNamed(Routes.DASHBOARD);
    } catch (e) {
      Get.snackbar('Login Failed', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loginWithDemo({
    required String email,
    required String password,
  }) async {
    emailController.text = email;
    passwordController.text = password;
    await login();
  }

  Future<void> register() async {
    if (!registerFormKey.currentState!.validate()) return;
    try {
      isLoading.value = true;
      await _lms.register(
        name: nameController.text.trim(),
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      setupStep.value = 0;
      Get.offAllNamed(Routes.SETUP_PROFILE);
    } catch (e) {
      Get.snackbar('Registration Failed', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> completeProfile() async {
    try {
      isLoading.value = true;
      await _lms.completeProfile(
        role: selectedRole.value,
        university: universityController.text.trim(),
        department: departmentController.text.trim(),
        semester: '${semesterController.text.trim()} · ${sectionController.text.trim()}',
        subjects: subjectList,
        program: programController.text.trim(),
        batch: sectionController.text.trim(),
      );
      await _lms.updatePreference(
        deadlineReminders: deadlineReminders.value,
        autoDownload: autoDownload.value,
        streakAlerts: streakAlerts.value,
        darkMode: darkMode.value,
        language: language.value,
        dailyGoalMinutes: dailyGoalMinutes.value,
      );
      Get.offAllNamed(Routes.DASHBOARD);
    } catch (e) {
      Get.snackbar('Profile Setup Failed', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    await _lms.logout();
    Get.offAllNamed(Routes.LOGIN);
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
    universityController.dispose();
    departmentController.dispose();
    semesterController.dispose();
    programController.dispose();
    sectionController.dispose();
    subjectsController.dispose();
    super.onClose();
  }
}
