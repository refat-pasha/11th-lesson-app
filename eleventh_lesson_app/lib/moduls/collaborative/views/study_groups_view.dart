import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/theme/colors.dart';
import '../../../data/models/group_model.dart';
import '../controllers/collaborative_controller.dart';

class StudyGroupsView extends GetView<CollaborativeController> {
  const StudyGroupsView({super.key, this.showScaffold = true});

  final bool showScaffold;

  @override
  Widget build(BuildContext context) {
    final body = Obx(() {
      final groups = controller.lms.groups;
      return ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Study groups',
                style: Theme.of(context)
                    .textTheme
                    .displayMedium
                    ?.copyWith(color: Colors.white, fontSize: 26),
              ),
              TextButton.icon(
                onPressed: _showCreateDialog,
                icon: const Icon(Icons.add),
                label: const Text('New group'),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Collaborate, share resources, and discuss doubts with peers.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white70),
          ),
          const SizedBox(height: 14),
          ...groups.map((group) => _GroupCard(group: group)),
        ],
      );
    });

    if (!showScaffold) return body;
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      appBar: AppBar(title: const Text('Study Groups')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showCreateDialog,
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.add),
        label: const Text('Create'),
      ),
      body: body,
    );
  }

  void _showCreateDialog() {
    final nameController = TextEditingController();
    final subjectController = TextEditingController();
    final descriptionController = TextEditingController();
    Get.defaultDialog(
      title: 'Create study group',
      backgroundColor: AppColors.cardDark,
      titleStyle: const TextStyle(color: Colors.white),
      content: Column(
        children: [
          TextField(
            controller: nameController,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(labelText: 'Group name'),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: subjectController,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(labelText: 'Subject'),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: descriptionController,
            maxLines: 3,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(labelText: 'Description'),
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: () async {
              await controller.createGroup(
                name: nameController.text.trim(),
                subject: subjectController.text.trim(),
                description: descriptionController.text.trim(),
              );
              Get.back();
            },
            child: const Text('Create group'),
          ),
        ],
      ),
    );
  }
}

class _GroupCard extends StatelessWidget {
  const _GroupCard({required this.group});

  final GroupModel group;

  @override
  Widget build(BuildContext context) {
    final lms = Get.find<CollaborativeController>().lms;
    final joined = group.members.contains(lms.currentUser.value?.id);
    return InkWell(
      onTap: () => _openGroup(group),
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
            Row(
              children: [
                Container(
                  height: 44,
                  width: 44,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.16),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text('🤝', style: TextStyle(fontSize: 20)),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        group.name,
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(color: Colors.white, fontWeight: FontWeight.w800),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        group.subject,
                        style: const TextStyle(color: Colors.white60, fontSize: 12),
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () => joined
                      ? lms.leaveGroup(group.id)
                      : lms.joinGroup(group.id),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: joined ? Colors.white12 : AppColors.primary,
                  ),
                  child: Text(joined ? 'Leave' : 'Join'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(group.description,
                style: const TextStyle(color: Colors.white70, height: 1.4)),
            const SizedBox(height: 10),
            Row(
              children: [
                _Pill(text: '${group.members.length} members'),
                const SizedBox(width: 8),
                _Pill(text: '${group.resourceLinks.length} resources'),
                const SizedBox(width: 8),
                _Pill(text: '${group.messages.length} messages'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _openGroup(GroupModel group) {
    final messageController = TextEditingController();
    final resourceController = TextEditingController();
    Get.bottomSheet(
      StatefulBuilder(
        builder: (context, setModalState) {
          return Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              color: AppColors.cardDark,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: SafeArea(
              child: SingleChildScrollView(
                child: Obx(() {
                  final freshGroup = Get.find<CollaborativeController>()
                      .lms
                      .groups
                      .firstWhere((item) => item.id == group.id, orElse: () => group);
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            freshGroup.name,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          _Pill(text: '${freshGroup.members.length} members'),
                        ],
                      ),
                      const SizedBox(height: 10),
                      const Text('Resources',
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
                      const SizedBox(height: 8),
                      ...freshGroup.resourceLinks.map(
                        (resource) => Padding(
                          padding: const EdgeInsets.only(bottom: 6),
                          child: Text('• $resource',
                              style: const TextStyle(color: Colors.white70)),
                        ),
                      ),
                      TextField(
                        controller: resourceController,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(labelText: 'Add resource'),
                      ),
                      const SizedBox(height: 8),
                      TextButton(
                        onPressed: () async {
                          await Get.find<CollaborativeController>().addGroupResource(
                            freshGroup.id,
                            resourceController.text.trim(),
                          );
                          resourceController.clear();
                          setModalState(() {});
                        },
                        child: const Text('Share resource'),
                      ),
                      const SizedBox(height: 12),
                      const Text('Discussion',
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
                      const SizedBox(height: 8),
                      ...freshGroup.messages.map(
                        (message) => Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColors.glass,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Text(
                            '${message.author}: ${message.body}',
                            style: const TextStyle(color: Colors.white70),
                          ),
                        ),
                      ),
                      TextField(
                        controller: messageController,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(labelText: 'Write a message'),
                      ),
                      const SizedBox(height: 8),
                      ElevatedButton(
                        onPressed: () async {
                          await Get.find<CollaborativeController>().addGroupMessage(
                            freshGroup.id,
                            messageController.text.trim(),
                          );
                          messageController.clear();
                          setModalState(() {});
                        },
                        child: const Text('Post message'),
                      ),
                    ],
                  );
                }),
              ),
            ),
          );
        },
      ),
      isScrollControlled: true,
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.glass,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: AppColors.border),
      ),
      child: Text(text, style: const TextStyle(color: Colors.white70, fontSize: 12)),
    );
  }
}
