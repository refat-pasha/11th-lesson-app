// placeholder
// lib/modules/profile/views/settings_view.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app/theme/colors.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      appBar: AppBar(
        title: const Text("Settings"),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const SizedBox(height: 10),

          _settingsTile(
            icon: Icons.dark_mode,
            title: "Dark Mode",
            trailing: Switch(
              value: true,
              onChanged: (value) {},
            ),
          ),

          _settingsTile(
            icon: Icons.notifications,
            title: "Notifications",
            trailing: Switch(
              value: true,
              onChanged: (value) {},
            ),
          ),

          _settingsTile(
            icon: Icons.language,
            title: "Language",
            trailing: const Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Colors.white54,
            ),
            onTap: () {},
          ),

          const SizedBox(height: 20),

          _settingsTile(
            icon: Icons.info_outline,
            title: "About App",
            trailing: const Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Colors.white54,
            ),
            onTap: () {
              Get.dialog(
                AlertDialog(
                  title: const Text("11th Lesson"),
                  content: const Text(
                    "Version 1.0.0\n\nAn LMS platform for fast learning and collaboration.",
                  ),
                  actions: [
                    TextButton(
                      onPressed: Get.back,
                      child: const Text("Close"),
                    )
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _settingsTile({
    required IconData icon,
    required String title,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.cardDark,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Icon(icon, color: Colors.white),
        title: Text(
          title,
          style: const TextStyle(color: Colors.white),
        ),
        trailing: trailing,
        onTap: onTap,
      ),
    );
  }
}