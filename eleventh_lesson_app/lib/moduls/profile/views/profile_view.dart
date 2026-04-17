import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/profile_controller.dart';
import '../../../app/theme/colors.dart';
import '../../../app/routes/app_routes.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: SafeArea(
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          final user = controller.user.value;

          if (user == null) {
            return const Center(
              child: Text("No profile found",
                  style: TextStyle(color: Colors.white70)),
            );
          }

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [

              /// ================= HEADER =================
              Row(
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: Colors.blueAccent,
                    child: Text(
                      user.name.isNotEmpty
                          ? user.name[0].toUpperCase()
                          : "U",
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 6),

                      Row(
                        children: [
                          _tag(user.role.toUpperCase()),
                          const SizedBox(width: 6),
                          _tag(user.department ?? "CSE"),
                          const SizedBox(width: 6),
                          _tag("DIU"),
                        ],
                      )
                    ],
                  )
                ],
              ),

              const SizedBox(height: 20),

              /// ================= STATS =================
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _statCard(
                    user.enrolledCourses.length.toString(),
                    "COURSES",
                  ),
                  _statCard(user.streak.toString(), "STREAK"),
                  _statCard("${user.xp}", "XP"),
                ],
              ),

              const SizedBox(height: 20),

              /// ================= ACADEMIC DETAILS =================
              _sectionTitle("Academic Details"),

              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.cardDark,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    _row("University", user.university ?? "-"),
                    _row("Department", user.department ?? "-"),
                    _row("Semester", user.semester ?? "-"),
                    _row(
                      "Subjects",
                      user.subjects.isEmpty
                          ? "-"
                          : user.subjects.join(" • "),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              /// ================= SETTINGS =================
              _sectionTitle("Settings"),

              _menuTile(
                icon: Icons.settings,
                title: "Account Settings",
                subtitle: "Security, preferences",
                onTap: () => Get.toNamed(Routes.accountSettings),
              ),

              _menuTile(
                icon: Icons.school,
                title: "Academic Profile",
                subtitle: "University, department, subjects",
                onTap: () => Get.toNamed(Routes.academicProfile),
              ),

              _menuTile(
                icon: Icons.dark_mode,
                title: "Appearance",
                subtitle: "Theme & display",
                onTap: () => Get.toNamed(Routes.appearance),
              ),

              const SizedBox(height: 30),

              /// ================= LOGOUT =================
              ElevatedButton(
                onPressed: controller.logout,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text("Sign Out"),
              ),

              const SizedBox(height: 20),
            ],
          );
        }),
      ),
    );
  }

  /// ================= UI HELPERS =================

  Widget _tag(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.blueAccent.withOpacity(0.2),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.blueAccent,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _statCard(String value, String label) {
    return Container(
      width: 100,
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.cardDark,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: const TextStyle(color: Colors.white70, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _row(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(color: Colors.white70)),
          Text(value, style: const TextStyle(color: Colors.white)),
        ],
      ),
    );
  }

  Widget _sectionTitle(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _menuTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.cardDark,
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        onTap: onTap,
        leading: Icon(icon, color: Colors.white),
        title: Text(title, style: const TextStyle(color: Colors.white)),
        subtitle:
            Text(subtitle, style: const TextStyle(color: Colors.white70)),
        trailing: const Icon(Icons.arrow_forward_ios,
            size: 16, color: Colors.white54),
      ),
    );
  }
}