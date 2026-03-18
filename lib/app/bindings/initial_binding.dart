import 'package:get/get.dart';

import '../../core/controllers/lms_controller.dart';
import '../../data/providers/firebase_provider.dart';
import '../../data/providers/local_storage_provider.dart';
import '../../data/repositories/auth_repository.dart';
import '../../data/repositories/course_repository.dart';
import '../../data/repositories/assignment_repository.dart';
import '../../data/repositories/quiz_repository.dart';
import '../../data/repositories/material_repository.dart';

class InitialBinding extends Bindings {

  @override
  void dependencies() {

    /// Providers
    Get.put<FirebaseProvider>(FirebaseProvider(), permanent: true);
    Get.put<LocalStorageProvider>(LocalStorageProvider(), permanent: true);
    Get.put<LmsController>(
      LmsController(Get.find<LocalStorageProvider>()),
      permanent: true,
    );

    /// Repositories
    Get.put<AuthRepository>(
      AuthRepository(Get.find<FirebaseProvider>()),
      permanent: true,
    );

    Get.lazyPut<CourseRepository>(
      () => CourseRepository(Get.find<FirebaseProvider>()),
    );

    Get.lazyPut<AssignmentRepository>(
      () => AssignmentRepository(Get.find<FirebaseProvider>()),
    );

    Get.lazyPut<QuizRepository>(
      () => QuizRepository(Get.find<FirebaseProvider>()),
    );

    Get.lazyPut<MaterialRepository>(
      () => MaterialRepository(Get.find<FirebaseProvider>()),
    );
  }
}
