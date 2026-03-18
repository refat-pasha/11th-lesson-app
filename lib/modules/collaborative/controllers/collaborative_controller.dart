import 'package:get/get.dart';

import '../../../core/controllers/lms_controller.dart';

class CollaborativeController extends GetxController {
  final lms = Get.find<LmsController>();

  Future<void> createGroup({
    required String name,
    required String subject,
    required String description,
  }) {
    return lms.createGroup(name: name, subject: subject, description: description);
  }

  Future<void> joinGroup(String groupId) => lms.joinGroup(groupId);
  Future<void> leaveGroup(String groupId) => lms.leaveGroup(groupId);
  Future<void> addGroupMessage(String groupId, String message) =>
      lms.addGroupMessage(groupId, message);
  Future<void> addGroupResource(String groupId, String resourceLabel) =>
      lms.addGroupResource(groupId, resourceLabel);
}
