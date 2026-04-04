import 'package:get/get.dart';

import '../../../data/models/course_model.dart';
import '../../../data/models/user_model.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../../data/repositories/course_repository.dart';
import '../../../data/providers/firebase_provider.dart';


class ProgressController extends GetxController {
  final AuthRepository authRepository = Get.find();
  final CourseRepository courseRepository = Get.find();
  final FirebaseProvider firebaseProvider = Get.find();

   var isLoading = true.obs;

  final user = Rxn<UserModel>();

  final courses = <CourseModel>[].obs;

  final progressMap = <String, double>{}.obs;

    @override
  void onInit() {
    super.onInit();
    loadProgress();
  }
 Future<void> loadProgress() async {
    try {
      isLoading.value = true;

      final firebaseUser = authRepository.currentUser;

      if (firebaseUser == null) return;

      /// Load user profile
      final profile = await authRepository.getUserProfile(firebaseUser.uid);

      user.value = profile;

      /// Load courses
      final fetchedCourses = await courseRepository.getCourses();

      courses.assignAll(fetchedCourses);

      /// Calculate progress for each course
      for (var course in fetchedCourses) {
        final progress = await calculateCourseProgress(course.id);

        progressMap[course.id] = progress;
      }
    } catch (e) {
      Get.snackbar("Progress Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }


   Future<double> calculateCourseProgress(String courseId) async {
    final firebaseUser = authRepository.currentUser;

    if (firebaseUser == null) return 0;

    /// total materials in course
    final materials = await firebaseProvider
        .materials()
        .where("courseId", isEqualTo: courseId)
        .get();

    final total = materials.docs.length;

    if (total == 0) return 0;

    /// completed materials by user
    final completed = await firebaseProvider
        .materialViews()
        .where("courseId", isEqualTo: courseId)
        .where("userId", isEqualTo: firebaseUser.uid)
        .get();

    final done = completed.docs.length;

    return done / total;
  }

  /// get progress for UI
  double getProgress(String courseId) {
    return progressMap[courseId] ?? 0;
  }

  /// XP progress
  double get xpProgress {
    final currentXP = user.value?.xp ?? 0;

    const maxXP = 3500;

    return currentXP / maxXP;
  }

  Future<void> refreshProgress() async {
    await loadProgress();
  }
}
