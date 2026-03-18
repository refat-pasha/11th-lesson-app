import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/routes/app_routes.dart';
import '../../../app/theme/colors.dart';
import '../../../core/utils/validators.dart';
import '../controllers/auth_controller.dart';

class LoginView extends GetView<AuthController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: SafeArea(
        child: Form(
          key: controller.loginFormKey,
          child: ListView(
            padding: const EdgeInsets.all(24),
            children: [
              const SizedBox(height: 24),
              const Text(
                'Welcome Back',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Access your personalized dashboard, assignments, publication feed, offline reading, quiz analytics, and study groups.',
                style: TextStyle(color: Colors.white70, height: 1.4),
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: AppColors.glass,
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(color: AppColors.border),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Demo Accounts',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Student: student@11thlesson.app / student123',
                      style: TextStyle(color: Colors.white70),
                    ),
                    Text(
                      'Teacher: teacher@11thlesson.app / teacher123',
                      style: TextStyle(color: Colors.white70),
                    ),
                    Text(
                      'Admin: admin@11thlesson.app / admin123',
                      style: TextStyle(color: Colors.white70),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              TextFormField(
                controller: controller.emailController,
                validator: Validators.email,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'Email',
                  labelStyle: TextStyle(color: Colors.white70),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: controller.passwordController,
                validator: Validators.password,
                obscureText: true,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'Password',
                  labelStyle: TextStyle(color: Colors.white70),
                ),
              ),
              const SizedBox(height: 24),
              Obx(() {
                return ElevatedButton(
                  onPressed: controller.isLoading.value ? null : controller.login,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: controller.isLoading.value
                      ? const SizedBox(
                          height: 18,
                          width: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Login'),
                );
              }),
              const SizedBox(height: 12),
              OutlinedButton(
                onPressed: () {
                  controller.emailController.text = 'student@11thlesson.app';
                  controller.passwordController.text = 'student123';
                },
                child: const Text('Fill Student Demo'),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () => controller.loginWithDemo(
                  email: 'student@11thlesson.app',
                  password: 'student123',
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.secondary,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('Enter Student Demo'),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => controller.loginWithDemo(
                        email: 'teacher@11thlesson.app',
                        password: 'teacher123',
                      ),
                      child: const Text('Teacher Demo'),
                    ),
                  ),
                  Expanded(
                    child: TextButton(
                      onPressed: () => controller.loginWithDemo(
                        email: 'admin@11thlesson.app',
                        password: 'admin123',
                      ),
                      child: const Text('Admin Demo'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Center(
                child: TextButton(
                  onPressed: () => Get.toNamed(Routes.REGISTER),
                  child: const Text(
                    'Create a new account',
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
