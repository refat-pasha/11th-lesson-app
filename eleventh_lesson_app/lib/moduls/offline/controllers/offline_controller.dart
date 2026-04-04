import 'package:get/get.dart';

import '../../../data/models/material_model.dart';
import '../../../data/providers/local_storage_provider.dart';
import '../../../core/constants/storage_keys.dart';

class OfflineController extends GetxController {
    final LocalStorageProvider _storage = LocalStorageProvider();

  final RxList<MaterialModel> offlineMaterials = <MaterialModel>[].obs;
  final RxBool isLoading = false.obs;