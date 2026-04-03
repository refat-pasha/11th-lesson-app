import 'package:get/get.dart';

import '../../data/providers/firebase_provider.dart';
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