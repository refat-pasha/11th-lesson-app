// lib/modules/assignment/controllers/assignment_controller.dart

import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../data/models/assignment_model.dart';
import '../../../data/models/assignment_submission_model.dart';
import '../../../data/providers/firebase_provider.dart';
import '../../../data/repositories/assignment_repository.dart';

class AssignmentController extends GetxController {
  late AssignmentRepository _assignmentRepository;

  /// ================= STATE =================
  final RxList<AssignmentModel> assignments = <AssignmentModel>[].obs;

  /// 🔥 NEW
  final RxList<AssignmentSubmissionModel> submissions =
      <AssignmentSubmissionModel>[].obs;

  final RxBool isLoading = false.obs;

  /// ================= USER ROLE =================
  final RxString userRole = "student".obs;
  bool get isTeacher => userRole.value == "teacher" || userRole.value == "admin";

  late final FirebaseProvider _firebaseProvider;

  /// ================= INIT =================
  @override
  void onInit() {
    super.onInit();

    _firebaseProvider = FirebaseProvider();
    _assignmentRepository = AssignmentRepository(_firebaseProvider);

    fetchUserRole();
    fetchAssignments();
    listenToAssignments();
  }

  /// ================= FETCH ROLE =================
  Future<void> fetchUserRole() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final doc = await _firebaseProvider.users().doc(user.uid).get();
    final data = doc.data() as Map<String, dynamic>?;
    if (data != null && data["role"] != null) {
      userRole.value = data["role"];
    }
  }

  
