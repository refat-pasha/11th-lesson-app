// placeholder
// lib/modules/assignment/controllers/assignment_controller.dart

import 'package:get/get.dart';

import '../../../data/models/assignment_model.dart';
import '../../../data/providers/firebase_provider.dart';
import '../../../data/repositories/assignment_repository.dart';

class AssignmentController extends GetxController {
  late AssignmentRepository _assignmentRepository;

  final RxList<AssignmentModel> assignments = <AssignmentModel>[].obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    _assignmentRepository =
        AssignmentRepository(FirebaseProvider());
    fetchAssignments();
    super.onInit();
  }

Future<void> fetchAssignments() async {
    try {
      isLoading.value = true;

      final data = await _assignmentRepository.getAssignments();

      assignments.assignAll(data);
    } catch (e) {
      Get.snackbar(
        "Error",
        e.toString(),
      );
    } finally {
      isLoading.value = false;
    }
  }