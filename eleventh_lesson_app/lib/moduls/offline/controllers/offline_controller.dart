import 'package:get/get.dart';

import '../../../data/models/material_model.dart';
import '../../../data/providers/local_storage_provider.dart';
import '../../../core/constants/storage_keys.dart';

class OfflineController extends GetxController {
    final LocalStorageProvider _storage = LocalStorageProvider();

  final RxList<MaterialModel> offlineMaterials = <MaterialModel>[].obs;
  final RxBool isLoading = false.obs;

    @override
  void onInit() {
    loadOfflineMaterials();
    super.onInit();
  }

    void loadOfflineMaterials() {
    try {
      isLoading.value = true;

      final storedData = _storage.read<List>(StorageKeys.offlineMaterials);

      if (storedData != null) {
        final materials = storedData.map((item) {
          return MaterialModel.fromMap(
            Map<String, dynamic>.from(item),
            item['id'] ?? '',
          );
        }).toList();

        offlineMaterials.assignAll(materials);
      }
    } catch (e) {
      Get.snackbar("Offline Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }
