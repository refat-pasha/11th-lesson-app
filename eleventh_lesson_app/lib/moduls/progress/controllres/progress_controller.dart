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