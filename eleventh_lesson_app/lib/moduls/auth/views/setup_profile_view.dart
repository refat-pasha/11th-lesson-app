import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../app/theme/colors.dart';
import '../controllers/auth_controller.dart';

class SetupProfileView extends GetView<AuthController> {
  const SetupProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: SafeArea(
        child: Stack(
          children: [
            const _Ambient(),
            Obx(() {
              final step = controller.setupStep.value;
              return Column(
                children: [
                  _Header(step: step),
                  Expanded(
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 250),
                      child: _StepShell(
                        key: ValueKey(step),
                        child: switch (step) {
                          0 => _RoleStep(controller: controller),
                          1 => _AcademicStep(controller: controller),
                          _ => _PreferenceStep(controller: controller),
                        },
                      ),
                    ),
                  ),
                  _FooterButtons(
                    step: step,
                    onBack: controller.previousStep,
                    onNext: () => _handleNext(step),
                    isLoading: controller.isLoading,
                  ),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }

  void _handleNext(int step) {
    if (step == 0) {
      controller.nextStep();
      return;
    }
    if (step == 1) {
      if (controller.universityController.text.trim().isEmpty ||
          controller.departmentController.text.trim().isEmpty ||
          controller.semesterController.text.trim().isEmpty) {
        Get.snackbar('Add details', 'Please fill university, department, and semester.');
        return;
      }
      controller.nextStep();
      return;
    }
    controller.completeProfile();
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.step});

  final int step;

  @override
  Widget build(BuildContext context) {
    final steps = ['Role', 'Academic', 'Preferences'];
    final pct = ((step + 1) / steps.length).clamp(0.0, 1.0);

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Setup ${step + 1} of ${steps.length}',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white70),
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                steps[step],
                style: Theme.of(context)
                    .textTheme
                    .displayMedium
                    ?.copyWith(fontSize: 24, color: Colors.white),
              ),
              Text(
                DateFormat('EEE, dd MMM').format(DateTime.now()),
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white54),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: LinearProgressIndicator(
              value: pct,
              minHeight: 8,
              backgroundColor: Colors.white12,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}

class _StepShell extends StatelessWidget {
  const _StepShell({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: child,
    );
  }
}

class _RoleStep extends StatelessWidget {
  const _RoleStep({required this.controller});

  final AuthController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'I am a…',
          style: Theme.of(context).textTheme.displayMedium?.copyWith(color: Colors.white),
        ),
        const SizedBox(height: 6),
        Text(
          'Choose your role to personalize dashboard, permissions, and quick actions.',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white70),
        ),
        const SizedBox(height: 18),
        Obx(() {
          return Column(
            children: [
              _RoleCard(
                title: 'Student',
                subtitle: 'Access courses, quizzes, notes, and track progress.',
                icon: '🎓',
                selected: controller.selectedRole.value == 'student',
                onTap: () => controller.selectedRole.value = 'student',
                accent: AppColors.primary,
              ),
              const SizedBox(height: 10),
              _RoleCard(
                title: 'Teacher',
                subtitle: 'Create content, publish materials, grade assignments.',
                icon: '🧑‍🏫',
                selected: controller.selectedRole.value == 'teacher',
                onTap: () => controller.selectedRole.value = 'teacher',
                accent: AppColors.secondary,
              ),
              const SizedBox(height: 10),
              _RoleCard(
                title: 'Admin',
                subtitle: 'Manage platform settings, permissions, and analytics.',
                icon: '🛡️',
                selected: controller.selectedRole.value == 'admin',
                onTap: () => controller.selectedRole.value = 'admin',
                accent: AppColors.warning,
              ),
            ],
          );
        }),
      ],
    );
  }
}

class _RoleCard extends StatelessWidget {
  const _RoleCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.selected,
    required this.onTap,
    required this.accent,
  });

  final String title;
  final String subtitle;
  final String icon;
  final bool selected;
  final VoidCallback onTap;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: selected ? accent.withValues(alpha: 0.16) : AppColors.cardDark,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: selected ? accent : AppColors.border),
        ),
        child: Row(
          children: [
            Container(
              height: 48,
              width: 48,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: accent.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Text(icon, style: const TextStyle(fontSize: 22)),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(color: Colors.white, fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white70),
                  ),
                ],
              ),
            ),
            Icon(
              selected ? Icons.check_circle_rounded : Icons.radio_button_unchecked,
              color: selected ? accent : Colors.white30,
            ),
          ],
        ),
      ),
    );
  }
}

class _AcademicStep extends StatelessWidget {
  const _AcademicStep({required this.controller});

  final AuthController controller;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Text(
          'Academic details',
          style: Theme.of(context).textTheme.displayMedium?.copyWith(color: Colors.white),
        ),
        const SizedBox(height: 6),
        Text(
          'These fields tailor assignments, publications, and recommendations.',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white70),
        ),
        const SizedBox(height: 16),
        _Field(label: 'University / Institution', controller: controller.universityController),
        _Field(label: 'Department / Faculty', controller: controller.departmentController),
        _Field(label: 'Program', controller: controller.programController),
        Row(
          children: [
            Expanded(
              child: _Field(label: 'Semester', controller: controller.semesterController),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _Field(label: 'Section / Batch', controller: controller.sectionController),
            ),
          ],
        ),
        _Field(
          label: 'Subjects / Courses (comma separated)',
          controller: controller.subjectsController,
          maxLines: 2,
        ),
      ],
    );
  }
}

class _PreferenceStep extends StatelessWidget {
  const _PreferenceStep({required this.controller});

  final AuthController controller;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Text(
          'Preferences',
          style: Theme.of(context).textTheme.displayMedium?.copyWith(color: Colors.white),
        ),
        const SizedBox(height: 6),
        Text(
          'Set reminders, offline sync, language, and study goal.',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white70),
        ),
        const SizedBox(height: 12),
        _PrefTile(
          title: 'Deadline reminders',
          subtitle: 'Notify before assignments and quizzes are due',
          value: controller.deadlineReminders,
          accent: AppColors.primary,
        ),
        _PrefTile(
          title: 'Auto-download materials',
          subtitle: 'Save new content for offline reading',
          value: controller.autoDownload,
          accent: AppColors.secondary,
        ),
        _PrefTile(
          title: 'Streak nudges',
          subtitle: 'Daily reminders to keep learning streak alive',
          value: controller.streakAlerts,
          accent: AppColors.warning,
        ),
        _PrefTile(
          title: 'Dark mode',
          subtitle: 'Use dark interface that matches the prototype',
          value: controller.darkMode,
          accent: AppColors.accent,
        ),
        const SizedBox(height: 12),
        Obx(() {
          return DropdownButtonFormField<String>(
            // ignore: deprecated_member_use
            value: controller.language.value,
            dropdownColor: AppColors.cardDark,
            items: const [
              DropdownMenuItem(value: 'English', child: Text('English')),
              DropdownMenuItem(value: 'Bangla', child: Text('Bangla')),
              DropdownMenuItem(value: 'Hindi', child: Text('Hindi')),
              DropdownMenuItem(value: 'Arabic', child: Text('Arabic')),
            ],
            onChanged: (value) => controller.language.value = value ?? 'English',
            decoration: const InputDecoration(
              labelText: 'Preferred language',
            ),
          );
        }),
        const SizedBox(height: 12),
        Obx(() {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Daily study goal',
                    style:
                        Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.white),
                  ),
                  Text(
                    '${controller.dailyGoalMinutes.value} mins',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white70),
                  ),
                ],
              ),
              Slider(
                value: controller.dailyGoalMinutes.value.toDouble(),
                min: 30,
                max: 240,
                divisions: 7,
                activeColor: AppColors.primary,
                label: '${controller.dailyGoalMinutes.value} mins',
                onChanged: (v) => controller.dailyGoalMinutes.value = v.round(),
              ),
            ],
          );
        }),
      ],
    );
  }
}

class _Field extends StatelessWidget {
  const _Field({
    required this.label,
    required this.controller,
    this.maxLines = 1,
  });

  final String label;
  final TextEditingController controller;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(labelText: label),
      ),
    );
  }
}

class _PrefTile extends StatelessWidget {
  const _PrefTile({
    required this.title,
    required this.subtitle,
    required this.value,
    required this.accent,
  });

  final String title;
  final String subtitle;
  final RxBool value;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
            return Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.cardDark,
                border: Border.all(color: AppColors.border),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Container(
                    height: 44,
                    width: 44,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: accent.withValues(alpha: 0.18),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.tune_rounded, color: Colors.white),
                  ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(color: Colors.white, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 2),
                  Text(subtitle,
                      style:
                          Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.white70)),
                ],
              ),
            ),
            Switch(
              value: value.value,
              onChanged: (v) => value.value = v,
            ),
          ],
        ),
      );
    });
  }
}

class _FooterButtons extends StatelessWidget {
  const _FooterButtons({
    required this.step,
    required this.onBack,
    required this.onNext,
    required this.isLoading,
  });

  final int step;
  final VoidCallback onBack;
  final VoidCallback onNext;
  final RxBool isLoading;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 6, 20, 18),
      child: Row(
        children: [
          if (step > 0)
            Expanded(
              child: OutlinedButton(
                onPressed: onBack,
                child: const Text('Back'),
              ),
            ),
          if (step > 0) const SizedBox(width: 10),
          Expanded(
            flex: 2,
            child: Obx(() {
              final isLast = step == 2;
              return ElevatedButton(
                onPressed: isLoading.value ? null : onNext,
                child: isLoading.value
                    ? const SizedBox(
                        height: 18,
                        width: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(isLast ? "Finish" : "Continue"),
              );
            }),
          ),
        ],
      ),
    );
  }
}

class _Ambient extends StatelessWidget {
  const _Ambient();

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Stack(
        children: [
          Positioned(
            top: -80,
            left: -120,
            child: _orb(color: AppColors.primary.withValues(alpha: 0.25), size: 320),
          ),
          Positioned(
            bottom: -60,
            right: -100,
            child: _orb(color: AppColors.secondary.withValues(alpha: 0.16), size: 260),
          ),
          Positioned(
            top: 200,
            right: -60,
            child: _orb(color: AppColors.accent.withValues(alpha: 0.18), size: 220),
          ),
        ],
      ),
    );
  }

  Widget _orb({required Color color, required double size}) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
        boxShadow: [
          BoxShadow(
            color: color,
            blurRadius: 140,
            spreadRadius: 60,
          ),
        ],
      ),
    );
  }
}
