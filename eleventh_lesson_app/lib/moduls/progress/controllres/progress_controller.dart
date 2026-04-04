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