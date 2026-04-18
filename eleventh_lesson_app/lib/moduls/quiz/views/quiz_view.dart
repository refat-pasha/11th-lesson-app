import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../app/routes/app_routes.dart';
import '../../../app/theme/colors.dart';
import '../../../data/models/assignment_model.dart';
import '../../../data/models/course_model.dart';
import '../controllers/dashboard_controller.dart';

class DashboardView extends GetView<DashboardController> {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: SafeArea(
        child: Stack(
          children: [
            const _Ambient(),
            RefreshIndicator(
              onRefresh: controller.refreshDashboard,
              child: Obx(() {
                final user = controller.lms.currentUser.value;
                final pending = controller.lms.pendingAssignments;
                final suggestions = controller.lms.suggestions;
                final courses = controller.lms.courses;
                final notifCount = controller.lms.notifications.length;

                return CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
                        child: _Header(
                          name: user?.name ?? 'Learner',
                          role: user?.role ?? 'student',
                          department: user?.department ?? '',
                          semester: user?.semester ?? '',
                          university: user?.university ?? '',
                          notifCount: notifCount,
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: _ProgressHero(
                          overall: controller.lms.overallProgress,
                          courses: courses,
                          getProgress: controller.lms.progressForCourse,
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(16, 14, 16, 4),
                        child: _StatsRow(
                          streak: user?.streak ?? 0,
                          xp: user?.xp ?? 0,
                          badges: user?.achievements.length ?? 0,
                          groups: controller.lms.activeGroupCount,
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: _QuickAccess(
                          isTeacher: controller.lms.isTeacher || controller.lms.isAdmin,
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
                        child: _ContinueLearning(
                          courses: courses,
                          getProgress: controller.lms.progressForCourse,
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(16, 10, 16, 4),
                        child: _WeeklyActivity(goalMinutes: controller.lms.prefs.dailyGoalMinutes),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
                        child: _DeadlinesSection(pending: pending),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(16, 12, 16, 6),
                        child: _RecommendationSection(suggestions: suggestions),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
                        child: _NotificationPreview(
                          notifications: controller.lms.notifications,
                        ),
                      ),
                    ),
                  ],
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({
    required this.name,
    required this.role,
    required this.department,
    required this.semester,
    required this.university,
    required this.notifCount,
  });

  final String name;
  final String role;
  final String department;
  final String semester;
  final String university;
  final int notifCount;

  @override
  Widget build(BuildContext context) {
    final date = DateFormat('EEE, dd MMM yyyy').format(DateTime.now());
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                date,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.white60),
              ),
              const SizedBox(height: 4),
              Text(
                'Good day, $name 👋',
                style: Theme.of(context)
                    .textTheme
                    .displayMedium
                    ?.copyWith(fontSize: 24, color: Colors.white),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 6,
                children: [
                  _Tag(text: '🎓 ${role.capitalizeFirst ?? role}'),
                  if (department.isNotEmpty) _Tag(text: department),
                  if (semester.isNotEmpty) _Tag(text: semester),
                  if (university.isNotEmpty) _Tag(text: university, color: AppColors.secondary),
                ],
              ),
            ],
          ),
        ),
        Column(
          children: [
            _IconBadge(
              icon: Icons.notifications_none_rounded,
              count: notifCount,
              onTap: () => Get.toNamed(Routes.PROFILE),
            ),
            const SizedBox(height: 8),
            _IconBadge(
              icon: Icons.person_outline_rounded,
              onTap: () => Get.toNamed(Routes.PROFILE),
            ),
          ],
        ),
      ],
    );
  }
}

class _ProgressHero extends StatelessWidget {
  const _ProgressHero({
    required this.overall,
    required this.courses,
    required this.getProgress,
  });

  final double overall;
  final List<CourseModel> courses;
  final double Function(String) getProgress;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.cardDark,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          SizedBox(
            height: 86,
            width: 86,
            child: Stack(
              alignment: Alignment.center,
              children: [
                CircularProgressIndicator(
                  value: overall,
                  strokeWidth: 8,
                  backgroundColor: Colors.white12,
                  valueColor: const AlwaysStoppedAnimation(AppColors.primary),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${(overall * 100).round()}%',
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall
                          ?.copyWith(color: Colors.white, fontWeight: FontWeight.w800),
                    ),
                    Text('done', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.white54)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Semester progress',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.white),
                ),
                const SizedBox(height: 4),
                Text(
                  'Keep your streak and finish pending tasks',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white60),
                ),
                const SizedBox(height: 10),
                ...courses.take(2).map((c) {
                  final progress = getProgress(c.id);
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(c.code, style: const TextStyle(color: Colors.white70, fontSize: 12)),
                            Text('${(progress * 100).round()}%',
                                style: const TextStyle(color: Colors.white70, fontSize: 12)),
                          ],
                        ),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: LinearProgressIndicator(
                            value: progress,
                            minHeight: 6,
                            color: AppColors.secondary,
                            backgroundColor: Colors.white12,
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatsRow extends StatelessWidget {
  const _StatsRow({
    required this.streak,
    required this.xp,
    required this.badges,
    required this.groups,
  });

  final int streak;
  final int xp;
  final int badges;
  final int groups;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _StatTile(label: 'Streak', value: '$streak', icon: '🔥', color: AppColors.warning),
        const SizedBox(width: 10),
        _StatTile(label: 'XP', value: '$xp', icon: '⚡', color: AppColors.primary),
        const SizedBox(width: 10),
        _StatTile(label: 'Badges', value: '$badges', icon: '🏅', color: AppColors.secondary),
        const SizedBox(width: 10),
        _StatTile(label: 'Groups', value: '$groups', icon: '🤝', color: AppColors.accent),
      ],
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  final String label;
  final String value;
  final String icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
        decoration: BoxDecoration(
          color: AppColors.cardDark,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          children: [
            Text(icon, style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 6),
            Text(
              value,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.w800,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 2),
            Text(label, style: const TextStyle(color: Colors.white60, fontSize: 12)),
          ],
        ),
      ),
    );
  }
}

class _QuickAccess extends StatelessWidget {
  const _QuickAccess({required this.isTeacher});

  final bool isTeacher;

  @override
  Widget build(BuildContext context) {
    final cards = [
      _QuickCard(
        icon: '🎯',
        title: 'Demo Quiz',
        subtitle: 'Practice with instant feedback',
        onTap: () => Get.toNamed(Routes.QUIZ),
      ),
      _QuickCard(
        icon: '📥',
        title: 'Offline Files',
        subtitle: '7 saved • manage',
        onTap: () => Get.toNamed(Routes.OFFLINE),
      ),
      _QuickCard(
        icon: '📋',
        title: 'Assignments',
        subtitle: 'Check deadlines',
        onTap: () => Get.toNamed(Routes.ASSIGNMENT),
      ),
      _QuickCard(
        icon: '🤝',
        title: 'Study Groups',
        subtitle: 'Join & chat',
        onTap: () => Get.toNamed(Routes.COLLABORATIVE),
      ),
    ];
    if (isTeacher) {
      cards.insert(
        1,
        _QuickCard(
          icon: '📝',
          title: 'Create Assignment',
          subtitle: 'Publish tasks',
          onTap: () => Get.toNamed(Routes.ASSIGNMENT),
        ),
      );
      cards.insert(
        2,
        _QuickCard(
          icon: '📤',
          title: 'Publish',
          subtitle: 'Upload materials',
          onTap: () => Get.toNamed(Routes.PUBLICATION),
        ),
      );
    }


class _QuickCard extends StatelessWidget {
  const _QuickCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final String icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Ink(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.cardDark,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(icon, style: const TextStyle(fontSize: 20)),
            const Spacer(),
            Text(
              title,
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(color: Colors.white, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.white60),
            ),
          ],
        ),
      ),
    );
  }
}

class _ContinueLearning extends StatelessWidget {
  const _ContinueLearning({
    required this.courses,
    required this.getProgress,
  });

  final List<CourseModel> courses;
  final double Function(String) getProgress;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionHeader(title: 'Continue learning', action: 'All courses'),
        const SizedBox(height: 10),
        SizedBox(
          height: 190,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.only(right: 4),
            itemCount: courses.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final course = courses[index];
              final progress = getProgress(course.id);
              return SizedBox(
                width: 210,
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppColors.cardDark,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _Tag(text: course.code),
                      const SizedBox(height: 6),
                      Text(
                        course.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(color: Colors.white, fontWeight: FontWeight.w700),
                      ),
                      const Spacer(),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: LinearProgressIndicator(
                          value: progress,
                          minHeight: 6,
                          color: AppColors.primary,
                          backgroundColor: Colors.white12,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('${(progress * 100).round()}%',
                              style: const TextStyle(color: Colors.white70, fontSize: 12)),
                          TextButton(
                            onPressed: () => Get.toNamed(Routes.PROGRESS),
                            child: const Text('Resume'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
