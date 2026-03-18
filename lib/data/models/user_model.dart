class UserModel {
  final String id;
  final String name;
  final String email;
  final String role;
  final String? avatarUrl;
  final List<String> enrolledCourses;
  final DateTime createdAt;
  final int xp;
  final int streak;
  final List<String> achievements;
  final String? university;
  final String? department;
  final String? semester;
  final String? program;
  final String? batch;
  final List<String> subjects;
  final int totalCourse;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.avatarUrl,
    required this.enrolledCourses,
    required this.createdAt,
    required this.xp,
    required this.streak,
    required this.achievements,
    this.university,
    this.department,
    this.semester,
    this.program,
    this.batch,
    required this.subjects,
    required this.totalCourse,
  });

  factory UserModel.fromMap(Map<String, dynamic> map, String id) {
    return UserModel(
      id: id,
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      role: map['role'] ?? 'student',
      avatarUrl: map['avatarUrl'],
      enrolledCourses: List<String>.from(map['enrolledCourses'] ?? []),
      createdAt: DateTime.tryParse(map['createdAt']?.toString() ?? '') ??
          DateTime.now(),
      xp: map['xp'] ?? 0,
      streak: map['streak'] ?? 0,
      achievements: List<String>.from(map['achievements'] ?? []),
      university: map['university'],
      department: map['department'],
      semester: map['semester'],
      program: map['program'],
      batch: map['batch'],
      subjects: List<String>.from(map['subjects'] ?? []),
      totalCourse: map['totalCourse'] ?? 0,
    );
  }

  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? role,
    String? avatarUrl,
    List<String>? enrolledCourses,
    DateTime? createdAt,
    int? xp,
    int? streak,
    List<String>? achievements,
    String? university,
    String? department,
    String? semester,
    String? program,
    String? batch,
    List<String>? subjects,
    int? totalCourse,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      role: role ?? this.role,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      enrolledCourses: enrolledCourses ?? this.enrolledCourses,
      createdAt: createdAt ?? this.createdAt,
      xp: xp ?? this.xp,
      streak: streak ?? this.streak,
      achievements: achievements ?? this.achievements,
      university: university ?? this.university,
      department: department ?? this.department,
      semester: semester ?? this.semester,
      program: program ?? this.program,
      batch: batch ?? this.batch,
      subjects: subjects ?? this.subjects,
      totalCourse: totalCourse ?? this.totalCourse,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'role': role,
      'avatarUrl': avatarUrl,
      'enrolledCourses': enrolledCourses,
      'createdAt': createdAt.toIso8601String(),
      'xp': xp,
      'streak': streak,
      'achievements': achievements,
      'university': university,
      'department': department,
      'semester': semester,
      'program': program,
      'batch': batch,
      'subjects': subjects,
      'totalCourse': totalCourse,
    };
  }
}
