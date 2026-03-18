import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../constants/demo_data.dart';
import '../constants/storage_keys.dart';
import '../../data/models/account_model.dart';
import '../../data/models/assignment_model.dart';
import '../../data/models/course_model.dart';
import '../../data/models/group_model.dart';
import '../../data/models/material_model.dart';
import '../../data/models/question_model.dart';
import '../../data/models/quiz_model.dart';
import '../../data/models/user_model.dart';
import '../../data/providers/local_storage_provider.dart';
import '../../data/models/settings_model.dart';

class LmsController extends GetxController {
  LmsController(this._storage);

  final LocalStorageProvider _storage;

  final accounts = <AccountModel>[].obs;
  final users = <UserModel>[].obs;
  final courses = <CourseModel>[].obs;
  final assignments = <AssignmentModel>[].obs;
  final materials = <MaterialModel>[].obs;
  final groups = <GroupModel>[].obs;
  final questions = <QuestionModel>[].obs;
  final notifications = <String>[].obs;
  final settings = const SettingsModel().obs;

  final currentUser = Rxn<UserModel>();
  final quiz = Rxn<QuizModel>();
  final isReady = false.obs;

  @override
  void onInit() {
    super.onInit();
    _load();
  }

  bool get isLoggedIn => _storage.read<bool>(StorageKeys.isLoggedIn) ?? false;
  bool get isStudent => currentUser.value?.role == 'student';
  bool get isTeacher => currentUser.value?.role == 'teacher';
  bool get isAdmin => currentUser.value?.role == 'admin';
  SettingsModel get prefs => settings.value;
  bool get isDarkMode => settings.value.darkMode;

  List<AssignmentModel> get pendingAssignments => assignments
      .where((item) => item.submissionText == null || item.submissionText!.isEmpty)
      .toList()
    ..sort((a, b) => a.dueDate.compareTo(b.dueDate));

  List<MaterialModel> get offlineMaterials =>
      materials.where((item) => item.isOffline).toList();

  List<String> get suggestions {
    final pending = pendingAssignments.take(2).map((item) => item.title).toList();
    final weakCourse = courses
        .map((course) => MapEntry(course, progressForCourse(course.id)))
        .toList();
    weakCourse.sort((a, b) => a.value.compareTo(b.value));
    final list = <String>[
      if (pending.isNotEmpty) 'Complete ${pending.first} before the deadline.',
      if (weakCourse.isNotEmpty)
        'Revise ${weakCourse.first.key.code} because it has the lowest completion trend.',
      if (offlineMaterials.isNotEmpty)
        'Use offline reading for ${offlineMaterials.first.title} during commute time.',
      'Join a study group discussion to increase your collaboration score.',
    ];
    return list.take(3).toList();
  }

  double progressForCourse(String courseId) {
    final courseAssignments =
        assignments.where((item) => item.courseId == courseId).toList();
    if (courseAssignments.isEmpty) {
      return DemoData.courseProgress[courseId] ?? 0.5;
    }
    final submitted = courseAssignments
        .where((item) => item.submissionText != null && item.submissionText!.isNotEmpty)
        .length;
    final base = submitted / courseAssignments.length;
    final bonus = materials.where((item) => item.courseId == courseId && item.isOffline).length *
        0.05;
    return (base + bonus).clamp(0.0, 1.0);
  }

  double get overallProgress {
    if (courses.isEmpty) return 0;
    final total = courses.fold<double>(
      0,
      (sum, course) => sum + progressForCourse(course.id),
    );
    return total / courses.length;
  }

  int get savedMaterialCount => offlineMaterials.length;
  int get storageRemaining => ((settings.value.storageLimitMb - settings.value.storageUsedMb)
          .clamp(0, settings.value.storageLimitMb))
      .toInt();
  int get activeGroupCount => groups.where((group) {
        final userId = currentUser.value?.id ?? '';
        return group.members.contains(userId);
      }).length;

  bool isLate(AssignmentModel assignment) {
    final submitted = (assignment.submissionText ?? '').isNotEmpty;
    return DateTime.now().isAfter(assignment.dueDate) && !submitted;
  }

  String assignmentStatus(AssignmentModel assignment) {
    if ((assignment.submissionText ?? '').isNotEmpty) {
      if (assignment.score != null) return 'graded';
      return 'submitted';
    }
    return isLate(assignment) ? 'late' : 'pending';
  }

  int daysUntilDue(AssignmentModel assignment) {
    return assignment.dueDate.difference(DateTime.now()).inDays;
  }

  Future<void> _load() async {
    await _seedIfNeeded();
    accounts.assignAll(_readList(StorageKeys.accounts, AccountModel.fromMap));
    users.assignAll(_readListWithId(StorageKeys.users, UserModel.fromMap));
    courses.assignAll(_readListWithId(StorageKeys.courses, CourseModel.fromMap));
    assignments.assignAll(
      _readListWithId(StorageKeys.assignments, AssignmentModel.fromMap),
    );
    materials.assignAll(_readListWithId(StorageKeys.materials, MaterialModel.fromMap));
    groups.assignAll(_readListWithId(StorageKeys.groups, GroupModel.fromMap));
    questions.assignAll(_readListWithId(StorageKeys.questions, QuestionModel.fromMap));
    notifications.assignAll(
      List<String>.from(_storage.read<List>(StorageKeys.notifications) ?? const []),
    );
    final settingsMap = _storage.read<Map>(StorageKeys.settings);
    settings.value =
        SettingsModel.fromMap(settingsMap == null ? null : Map<String, dynamic>.from(settingsMap));
    Get.changeThemeMode(settings.value.darkMode ? ThemeMode.dark : ThemeMode.light);
    final quizMap = _storage.read<Map>(StorageKeys.quiz);
    if (quizMap != null) {
      quiz.value = QuizModel.fromMap(Map<String, dynamic>.from(quizMap), 'quiz-1');
    }

    final currentUserId = _storage.read<String>(StorageKeys.currentUserId);
    if (currentUserId != null && currentUserId.isNotEmpty) {
      currentUser.value = users.firstWhereOrNull((item) => item.id == currentUserId);
    }
    isReady.value = true;
  }

  Future<void> _seedIfNeeded() async {
    if (_storage.hasKey(StorageKeys.users)) return;
    await _storage.write(
      StorageKeys.accounts,
      DemoData.accounts.map((item) => item.toMap()).toList(),
    );
    await _storage.write(
      StorageKeys.users,
      DemoData.users.map((item) => {'id': item.id, ...item.toMap()}).toList(),
    );
    await _storage.write(
      StorageKeys.courses,
      DemoData.courses.map((item) => {'id': item.id, ...item.toMap()}).toList(),
    );
    await _storage.write(
      StorageKeys.assignments,
      DemoData.assignments.map((item) => {'id': item.id, ...item.toMap()}).toList(),
    );
    await _storage.write(
      StorageKeys.materials,
      DemoData.materials.map((item) => {'id': item.id, ...item.toMap()}).toList(),
    );
    await _storage.write(
      StorageKeys.groups,
      DemoData.groups.map((item) => {'id': item.id, ...item.toMap()}).toList(),
    );
    await _storage.write(
      StorageKeys.questions,
      DemoData.questions.map((item) => {'id': item.id, ...item.toMap()}).toList(),
    );
    await _storage.write(StorageKeys.quiz, DemoData.quiz.toMap());
    await _storage.write(StorageKeys.offlineMaterials, ['mat-1']);
    await _storage.write(StorageKeys.notifications, DemoData.notifications);
    await _storage.write(StorageKeys.settings, DemoData.settings.toMap());
    await _storage.write(StorageKeys.isLoggedIn, false);
  }

  List<T> _readList<T>(
    String key,
    T Function(Map<String, dynamic> map) factory,
  ) {
    final raw = _storage.read<List>(key) ?? const [];
    return raw
        .map((item) => factory(Map<String, dynamic>.from(item as Map)))
        .toList();
  }

  List<T> _readListWithId<T>(
    String key,
    T Function(Map<String, dynamic> map, String id) factory,
  ) {
    final raw = _storage.read<List>(key) ?? const [];
    return raw.map((item) {
      final map = Map<String, dynamic>.from(item as Map);
      return factory(map, map['id']?.toString() ?? '');
    }).toList();
  }

  Future<void> login(String email, String password) async {
    final account = accounts.firstWhereOrNull(
      (item) => item.email.toLowerCase() == email.toLowerCase().trim(),
    );
    if (account == null || account.password != password) {
      throw Exception('Invalid email or password.');
    }
    currentUser.value = users.firstWhereOrNull((item) => item.id == account.userId);
    await _storage.write(StorageKeys.currentUserId, account.userId);
    await _storage.write(StorageKeys.isLoggedIn, true);
  }

  Future<void> register({
    required String name,
    required String email,
    required String password,
  }) async {
    final normalizedEmail = email.trim().toLowerCase();
    final exists = accounts.any((item) => item.email.toLowerCase() == normalizedEmail);
    if (exists) {
      throw Exception('An account with this email already exists.');
    }
    final userId = 'user-${DateTime.now().millisecondsSinceEpoch}';
    final user = UserModel(
      id: userId,
      name: name.trim(),
      email: normalizedEmail,
      role: 'student',
      enrolledCourses: courses.take(3).map((item) => item.id).toList(),
      createdAt: DateTime.now(),
      xp: 0,
      streak: 0,
      achievements: const ['New Learner'],
      university: 'DIU',
      department: 'CSE',
      semester: '11th',
      program: 'B.Sc in CSE',
      batch: '63_J',
      subjects: courses.take(3).map((item) => item.title).toList(),
      totalCourse: 3,
    );
    final account = AccountModel(
      userId: userId,
      email: normalizedEmail,
      password: password,
      role: 'student',
    );
    users.add(user);
    accounts.add(account);
    currentUser.value = user;
    await _persistUsers();
    await _persistAccounts();
    await _storage.write(StorageKeys.currentUserId, userId);
    await _storage.write(StorageKeys.isLoggedIn, true);
  }

  Future<void> completeProfile({
    required String role,
    required String university,
    required String department,
    required String semester,
    List<String>? subjects,
    String? program,
    String? batch,
  }) async {
    final user = currentUser.value;
    if (user == null) return;
    final updated = user.copyWith(
      role: role,
      university: university,
      department: department,
      semester: semester,
      program: program ?? user.program,
      batch: batch ?? user.batch,
      subjects: subjects ?? user.subjects,
      totalCourse: subjects?.length ?? user.enrolledCourses.length,
    );
    _replaceUser(updated);
    final accountIndex = accounts.indexWhere((item) => item.userId == updated.id);
    if (accountIndex != -1) {
      accounts[accountIndex] = AccountModel(
        userId: accounts[accountIndex].userId,
        email: accounts[accountIndex].email,
        password: accounts[accountIndex].password,
        role: role,
      );
    }
    await _persistUsers();
    await _persistAccounts();
  }

  Future<void> updateProfile(UserModel updated) async {
    _replaceUser(updated);
    await _persistUsers();
  }

  Future<void> updateSettings(SettingsModel updated) async {
    settings.value = updated;
    await _persistSettings();
  }

  Future<void> updatePreference({
    bool? deadlineReminders,
    bool? autoDownload,
    bool? streakAlerts,
    bool? darkMode,
    String? language,
    int? dailyGoalMinutes,
  }) async {
    settings.value = settings.value.copyWith(
      deadlineReminders: deadlineReminders,
      autoDownload: autoDownload,
      streakAlerts: streakAlerts,
      darkMode: darkMode,
      language: language,
      dailyGoalMinutes: dailyGoalMinutes,
    );
    if (darkMode != null) {
      Get.changeThemeMode(darkMode ? ThemeMode.dark : ThemeMode.light);
    }
    await _persistSettings();
  }

  Future<void> logout() async {
    currentUser.value = null;
    await _storage.write(StorageKeys.currentUserId, '');
    await _storage.write(StorageKeys.isLoggedIn, false);
  }

  Future<void> createAssignment({
    required String title,
    required String description,
    required String courseId,
    required DateTime dueDate,
    required int maxScore,
  }) async {
    final user = currentUser.value;
    if (user == null) return;
    assignments.insert(
      0,
      AssignmentModel(
        id: 'asg-${DateTime.now().millisecondsSinceEpoch}',
        title: title,
        description: description,
        courseId: courseId,
        dueDate: dueDate,
        createdAt: DateTime.now(),
        createdBy: user.id,
        maxScore: maxScore,
      ),
    );
    notifications.insert(0, 'New assignment published: $title.');
    await _persistAssignments();
    await _persistNotifications();
  }

  Future<void> submitAssignment(String id, String submissionText) async {
    final index = assignments.indexWhere((item) => item.id == id);
    if (index == -1) return;
    assignments[index] = assignments[index].copyWith(
      submissionText: submissionText,
      submittedAt: DateTime.now(),
    );
    notifications.insert(0, 'Assignment submitted: ${assignments[index].title}.');
    final user = currentUser.value;
    if (user != null) {
      _replaceUser(user.copyWith(xp: user.xp + 45, streak: user.streak + 1));
    }
    await _persistAssignments();
    await _persistUsers();
    await _persistNotifications();
  }

  Future<void> gradeAssignment(String id, int score, String feedback) async {
    final index = assignments.indexWhere((item) => item.id == id);
    if (index == -1) return;
    assignments[index] = assignments[index].copyWith(score: score, feedback: feedback);
    notifications.insert(
      0,
      'Your assignment "${assignments[index].title}" was graded: $score/${assignments[index].maxScore}.',
    );
    await _persistAssignments();
    await _persistNotifications();
  }

  Future<void> deleteAssignment(String id) async {
    assignments.removeWhere((item) => item.id == id);
    await _persistAssignments();
  }

  Future<void> publishMaterial({
    required String title,
    required String description,
    required String courseId,
    required String category,
    required String visibility,
    required String fileName,
    required String fileType,
    required List<String> tags,
  }) async {
    final user = currentUser.value;
    if (user == null) return;
    final sizeMb = _estimateFileSize(fileType);
    var saveOffline = settings.value.autoDownload;
    var updatedSettings = settings.value;
    if (saveOffline) {
      final projected = updatedSettings.storageUsedMb + sizeMb;
      if (projected <= updatedSettings.storageLimitMb) {
        updatedSettings = updatedSettings.copyWith(storageUsedMb: projected);
      } else {
        saveOffline = false;
      }
    }

    materials.insert(
      0,
      MaterialModel(
        id: 'mat-${DateTime.now().millisecondsSinceEpoch}',
        title: title,
        description: description,
        courseId: courseId,
        uploadedBy: user.id,
        fileUrl: 'local://$fileName',
        fileType: fileType,
        isPublic: visibility == 'Public',
        createdAt: DateTime.now(),
        category: category,
        fileName: fileName,
        tags: tags,
        visibility: visibility,
        isOffline: saveOffline,
        sizeMb: sizeMb,
      ),
    );
    notifications.insert(0, 'New material published: $title.');
    settings.value = updatedSettings;
    await _persistMaterials();
    await _persistNotifications();
    await _persistSettings();
  }

  Future<void> toggleOffline(String materialId) async {
    final index = materials.indexWhere((item) => item.id == materialId);
    if (index == -1) return;
    final current = materials[index];
    final willSave = !current.isOffline;

    var updatedSettings = settings.value;
    if (willSave) {
      final projected = updatedSettings.storageUsedMb + current.sizeMb;
      if (projected > updatedSettings.storageLimitMb) {
        notifications.insert(
          0,
          'Offline storage is full. Remove files to save "${current.title}".',
        );
        await _persistNotifications();
        return;
      }
      updatedSettings = updatedSettings.copyWith(storageUsedMb: projected);
    } else {
      final reduced = (updatedSettings.storageUsedMb - current.sizeMb)
          .clamp(0, updatedSettings.storageLimitMb)
          .toInt();
      updatedSettings = updatedSettings.copyWith(storageUsedMb: reduced);
    }

    materials[index] = current.copyWith(
      isOffline: willSave,
      downloadCount: current.downloadCount + (willSave ? 1 : 0),
    );
    settings.value = updatedSettings;
    await _persistMaterials();
    await _persistSettings();
  }

  Future<void> createGroup({
    required String name,
    required String subject,
    required String description,
  }) async {
    final user = currentUser.value;
    if (user == null) return;
    groups.insert(
      0,
      GroupModel(
        id: 'grp-${DateTime.now().millisecondsSinceEpoch}',
        name: name,
        subject: subject,
        description: description,
        createdBy: user.id,
        members: [user.id],
        createdAt: DateTime.now(),
        messages: [
          GroupMessageModel(
            author: user.name,
            body: 'Welcome to the group. Start by sharing your revision plan.',
            sentAt: DateTime.now(),
          ),
        ],
      ),
    );
    await _persistGroups();
  }

  Future<void> joinGroup(String groupId) async {
    final user = currentUser.value;
    if (user == null) return;
    final index = groups.indexWhere((item) => item.id == groupId);
    if (index == -1) return;
    final group = groups[index];
    if (group.members.contains(user.id)) return;
    groups[index] = group.copyWith(members: [...group.members, user.id]);
    await _persistGroups();
  }

  Future<void> leaveGroup(String groupId) async {
    final user = currentUser.value;
    if (user == null) return;
    final index = groups.indexWhere((item) => item.id == groupId);
    if (index == -1) return;
    final group = groups[index];
    groups[index] =
        group.copyWith(members: group.members.where((item) => item != user.id).toList());
    await _persistGroups();
  }

  Future<void> addGroupMessage(String groupId, String message) async {
    final user = currentUser.value;
    if (user == null) return;
    final index = groups.indexWhere((item) => item.id == groupId);
    if (index == -1) return;
    final group = groups[index];
    groups[index] = group.copyWith(
      messages: [
        ...group.messages,
        GroupMessageModel(author: user.name, body: message, sentAt: DateTime.now()),
      ],
    );
    await _persistGroups();
  }

  Future<void> addGroupResource(String groupId, String resourceLabel) async {
    final index = groups.indexWhere((item) => item.id == groupId);
    if (index == -1) return;
    final group = groups[index];
    groups[index] = group.copyWith(
      resourceLinks: [...group.resourceLinks, resourceLabel],
    );
    await _persistGroups();
  }

  Future<int> submitQuiz(Map<int, int> answers) async {
    var score = 0;
    for (var i = 0; i < questions.length; i++) {
      if (questions[i].correctIndex == answers[i]) {
        score++;
      }
    }
    final user = currentUser.value;
    if (user != null) {
      _replaceUser(
        user.copyWith(
          xp: user.xp + (score * 25),
          streak: user.streak + 1,
          achievements: {
            ...user.achievements,
            if (score == questions.length) 'Perfect Quiz',
          }.toList(),
        ),
      );
    }
    notifications.insert(0, 'Quiz completed with score $score/${questions.length}.');
    await _persistUsers();
    await _persistNotifications();
    return score;
  }

  CourseModel? courseById(String id) => courses.firstWhereOrNull((item) => item.id == id);

  int _estimateFileSize(String fileType) {
    final type = fileType.toLowerCase();
    if (type.contains('mp4') || type.contains('video')) return 85;
    if (type.contains('ppt')) return 6;
    if (type.contains('zip')) return 12;
    return 4;
  }

  void _replaceUser(UserModel updated) {
    final index = users.indexWhere((item) => item.id == updated.id);
    if (index != -1) {
      users[index] = updated;
    }
    currentUser.value = updated;
  }

  Future<void> _persistUsers() async {
    await _storage.write(
      StorageKeys.users,
      users.map((item) => {'id': item.id, ...item.toMap()}).toList(),
    );
  }

  Future<void> _persistAccounts() async {
    await _storage.write(
      StorageKeys.accounts,
      accounts.map((item) => item.toMap()).toList(),
    );
  }

  Future<void> _persistAssignments() async {
    await _storage.write(
      StorageKeys.assignments,
      assignments.map((item) => {'id': item.id, ...item.toMap()}).toList(),
    );
  }

  Future<void> _persistMaterials() async {
    await _storage.write(
      StorageKeys.materials,
      materials.map((item) => {'id': item.id, ...item.toMap()}).toList(),
    );
  }

  Future<void> _persistGroups() async {
    await _storage.write(
      StorageKeys.groups,
      groups.map((item) => {'id': item.id, ...item.toMap()}).toList(),
    );
  }

  Future<void> _persistNotifications() async {
    await _storage.write(StorageKeys.notifications, notifications.toList());
  }

  Future<void> _persistSettings() async {
    await _storage.write(StorageKeys.settings, settings.value.toMap());
  }
}
