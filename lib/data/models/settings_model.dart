class SettingsModel {
  const SettingsModel({
    this.deadlineReminders = true,
    this.autoDownload = false,
    this.streakAlerts = true,
    this.darkMode = true,
    this.language = 'English',
    this.dailyGoalMinutes = 60,
    this.storageUsedMb = 120,
    this.storageLimitMb = 350,
  });

  final bool deadlineReminders;
  final bool autoDownload;
  final bool streakAlerts;
  final bool darkMode;
  final String language;
  final int dailyGoalMinutes;
  final int storageUsedMb;
  final int storageLimitMb;

  SettingsModel copyWith({
    bool? deadlineReminders,
    bool? autoDownload,
    bool? streakAlerts,
    bool? darkMode,
    String? language,
    int? dailyGoalMinutes,
    int? storageUsedMb,
    int? storageLimitMb,
  }) {
    return SettingsModel(
      deadlineReminders: deadlineReminders ?? this.deadlineReminders,
      autoDownload: autoDownload ?? this.autoDownload,
      streakAlerts: streakAlerts ?? this.streakAlerts,
      darkMode: darkMode ?? this.darkMode,
      language: language ?? this.language,
      dailyGoalMinutes: dailyGoalMinutes ?? this.dailyGoalMinutes,
      storageUsedMb: storageUsedMb ?? this.storageUsedMb,
      storageLimitMb: storageLimitMb ?? this.storageLimitMb,
    );
  }

  factory SettingsModel.fromMap(Map<String, dynamic>? map) {
    if (map == null) return const SettingsModel();
    return SettingsModel(
      deadlineReminders: map['deadlineReminders'] as bool? ?? true,
      autoDownload: map['autoDownload'] as bool? ?? false,
      streakAlerts: map['streakAlerts'] as bool? ?? true,
      darkMode: map['darkMode'] as bool? ?? true,
      language: map['language']?.toString() ?? 'English',
      dailyGoalMinutes: (map['dailyGoalMinutes'] as num?)?.toInt() ?? 60,
      storageUsedMb: (map['storageUsedMb'] as num?)?.toInt() ?? 120,
      storageLimitMb: (map['storageLimitMb'] as num?)?.toInt() ?? 350,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'deadlineReminders': deadlineReminders,
      'autoDownload': autoDownload,
      'streakAlerts': streakAlerts,
      'darkMode': darkMode,
      'language': language,
      'dailyGoalMinutes': dailyGoalMinutes,
      'storageUsedMb': storageUsedMb,
      'storageLimitMb': storageLimitMb,
    };
  }
}
