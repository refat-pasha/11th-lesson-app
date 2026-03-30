// lib/modules/collaborative/bindings/collaborative_binding.dart

import 'package:get/get.dart';
import '../controllers/collaborative_controller.dart';

class CollaborativeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CollaborativeController>(() => CollaborativeController());
  }
}
