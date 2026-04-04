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
  Future<void> saveMaterialOffline(MaterialModel material) async {
    try {
      offlineMaterials.add(material);

      final data = offlineMaterials.map((m) {
        final map = m.toMap();
        map['id'] = m.id;
        return map;
      }).toList();

      await _storage.write(StorageKeys.offlineMaterials, data);
    } catch (e) {
      Get.snackbar("Save Failed", e.toString());
    }
  }