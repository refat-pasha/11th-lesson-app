 
        DropdownButtonFormField<String>(
          dropdownColor: AppColors.cardDark,
          value: controller.selectedCourse.value,
          decoration: inputDecoration("Course", ""),
          items: controller.courseNames
              .map((e) => DropdownMenuItem(value: e, child: Text(e)))
              .toList(),
          onChanged: (value) => controller.selectedCourse.value = value!,
        ),

        const SizedBox(height: 20),

        ElevatedButton(
          onPressed: controller.uploadMaterial,
          child: const Text("Publish Material"),
        ),
      ],
    );
  }

  /// ================= STUDENT UI (UPDATED 🔥) =================
  Widget _buildStudentUI() {
    final downloadService = DownloadService();
    final box = GetStorage();

    final RxDouble progress = 0.0.obs;
    final RxBool isDownloading = false.obs;
    final RxMap<String, String> localPaths = <String, String>{}.obs;

    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('materials')
          .orderBy('createdAt', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final materials = snapshot.data!.docs;

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: materials.length,
          itemBuilder: (context, index) {
            final data = materials[index];
            final id = data.id;

            /// 🔥 LOAD SAVED PATH
            final saved = box.read(id);
            if (saved != null) {
              localPaths[id] = saved;
            }

            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.cardDark,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  /// TITLE
                  Text(
                    data['title'] ?? "No Title",
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 6),

                  /// DESCRIPTION
                  Text(
                    data['description'] ?? "",
                    style: const TextStyle(color: Colors.white70),
                  ),

                  const SizedBox(height: 10),

                  /// BUTTONS
                  Obx(() => Column(
                        children: [

                          /// DOWNLOAD
                          if (!localPaths.containsKey(id))
                            ElevatedButton(
                              onPressed: () async {
                                isDownloading.value = true;

                                final path =
                                    await downloadService.downloadFile(
                                  url: data['fileUrl'],
                                  fileName: "${data['title']}.pdf",
                                  onProgress: (p) {
                                    progress.value = p;
                                  },
                                );

                                isDownloading.value = false;

                                if (path != null) {
                                  localPaths[id] = path;
                                  box.write(id, path);

                                  Get.snackbar("Success",
                                      "Downloaded for offline use");
                                }
                              },
                              child: const Text("Download"),
                            ),

                          /// PROGRESS
                          if (isDownloading.value)
                            Column(
                              children: [
                                LinearProgressIndicator(
                                    value: progress.value),
                                Text(
                                  "${(progress.value * 100).toInt()}%",
                                  style: const TextStyle(
                                      color: Colors.white70),
                                ),
                              ],
                            ),

                          /// OPEN OFFLINE
                          if (localPaths.containsKey(id))
                            ElevatedButton(
                              onPressed: () {
                                FileService.openFile(localPaths[id]!);
                              },
                              child: const Text("Open Offline"),
                            ),
                        ],
                      )),
                ],
              ),
            );
          },
        );
      },
    );
  }

  /// ================= INPUT STYLE =================
  InputDecoration inputDecoration(String label, String hint) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      filled: true,
      fillColor: AppColors.cardDark,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }
}