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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionHeader(title: 'Quick access'),
        const SizedBox(height: 8),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          childAspectRatio: 1.15,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          children: cards,
        ),
      ],
    );
  }
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

class _WeeklyActivity extends StatelessWidget {
  const _WeeklyActivity({required this.goalMinutes});

  final int goalMinutes;

  @override
  Widget build(BuildContext context) {
    const bars = [35, 60, 82, 45, 70, 28, 96];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeader(title: 'Weekly activity', action: '$goalMinutes min goal'),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColors.cardDark,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: List.generate(bars.length, (index) {
              final height = bars[index].toDouble();
              final today = index == bars.length - 1;
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 18,
                    height: height,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: today
                            ? [AppColors.accent, AppColors.primary]
                            : [Colors.white12, Colors.white24],
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    ['M', 'T', 'W', 'T', 'F', 'S', 'S'][index],
                    style: TextStyle(
                      color: today ? AppColors.accent : Colors.white54,
                      fontWeight: today ? FontWeight.w700 : FontWeight.w500,
                    ),
                  ),
                ],
              );
            }),
          ),
        ),
      ],
    );
  }
}

class _DeadlinesSection extends StatelessWidget {
  const _DeadlinesSection({required this.pending});

  final List<AssignmentModel> pending;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeader(
          title: 'Upcoming deadlines',
          action: pending.isEmpty ? 'All clear' : '${pending.length} pending',
        ),
        const SizedBox(height: 10),
        if (pending.isEmpty)
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.cardDark,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.border),
            ),
            child: const Text('No pending tasks right now',
                style: TextStyle(color: Colors.white60)),
          )
        else
          Column(
            children: pending.map<Widget>((assignment) {
              final late = Get.find<DashboardController>().lms.isLate(assignment);
              final daysLeft =
                  Get.find<DashboardController>().lms.daysUntilDue(assignment).clamp(-99, 99);
              final course = Get.find<DashboardController>()
                      .lms
                      .courseById(assignment.courseId)
                      ?.code ??
                  '';
              return Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.cardDark,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.border),
                ),
                child: Row(
                  children: [
                    Container(
                      height: 44,
                      width: 44,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: late
                            ? AppColors.error.withValues(alpha: 0.15)
                            : AppColors.warning.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(late ? '⚠️' : '⏱️', style: const TextStyle(fontSize: 18)),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            assignment.title,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '$course • Due ${DateFormat('MMM d').format(assignment.dueDate)}',
                            style: const TextStyle(color: Colors.white60, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          late ? 'Late' : 'Due in ${daysLeft}d',
                          style: TextStyle(
                            color: late ? AppColors.error : AppColors.warning,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        TextButton(
                          onPressed: () => Get.toNamed(Routes.ASSIGNMENT),
                          child: const Text('Open'),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
      ],
    );
  }
}

class _RecommendationSection extends StatelessWidget {
  const _RecommendationSection({required this.suggestions});

  final List<String> suggestions;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionHeader(title: 'Recommended'),
        const SizedBox(height: 10),
        ...suggestions.map(
          (text) => Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.cardDark,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              children: [
                const Icon(Icons.lightbulb_outline_rounded, color: AppColors.secondary),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    text,
                    style: const TextStyle(color: Colors.white70),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _NotificationPreview extends StatelessWidget {
  const _NotificationPreview({required this.notifications});

  final List<String> notifications;

  @override
  Widget build(BuildContext context) {
    if (notifications.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionHeader(title: 'Notifications'),
        const SizedBox(height: 10),
        ...notifications.take(3).map(
          (item) => Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.cardDark,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.border),
            ),
            child: Text(item, style: const TextStyle(color: Colors.white70)),
          ),
        ),
        TextButton(
          onPressed: () => Get.toNamed(Routes.PROFILE),
          child: const Text('View all'),
        ),
      ],
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title, this.action});

  final String title;
  final String? action;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: Theme.of(context)
              .textTheme
              .titleLarge
              ?.copyWith(color: Colors.white, fontWeight: FontWeight.w800),
        ),
        if (action != null)
          Text(
            action!,
            style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w700),
          ),
      ],
    );
  }
}

class _Tag extends StatelessWidget {
  const _Tag({required this.text, this.color = AppColors.primary});

  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(
        text,
        style: TextStyle(color: color, fontWeight: FontWeight.w700, fontSize: 12),
      ),
    );
  }
}

class _IconBadge extends StatelessWidget {
  const _IconBadge({required this.icon, this.count, this.onTap});

  final IconData icon;
  final int? count;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.cardDark,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.border),
            ),
            child: Icon(icon, color: Colors.white),
          ),
          if ((count ?? 0) > 0)
            Positioned(
              right: -4,
              top: -4,
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: const BoxDecoration(
                  color: AppColors.error,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  '${count!}',
                  style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w700),
                ),
              ),
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
            top: -120,
            left: -80,
            child: _orb(AppColors.primary.withValues(alpha: 0.18), 320),
          ),
          Positioned(
            bottom: -80,
            right: -120,
            child: _orb(AppColors.secondary.withValues(alpha: 0.14), 260),
          ),
          Positioned(
            top: 240,
            right: -60,
            child: _orb(AppColors.accent.withValues(alpha: 0.12), 220),
          ),
        ],
      ),
    );
  }

  Widget _orb(Color color, double size) {
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
