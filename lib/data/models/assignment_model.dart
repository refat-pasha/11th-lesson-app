class AssignmentModel {
  const AssignmentModel({
    required this.id,
    required this.title,
    required this.description,
    required this.courseId,
    required this.dueDate,
    required this.createdAt,
    required this.createdBy,
    this.maxScore = 100,
    this.submissionText,
    this.submittedAt,
    this.score,
    this.feedback,
  });

  final String id;
  final String title;
  final String description;
  final String courseId;
  final DateTime dueDate;
  final DateTime createdAt;
  final String createdBy;
  final int maxScore;
  final String? submissionText;
  final DateTime? submittedAt;
  final int? score;
  final String? feedback;

  factory AssignmentModel.fromMap(Map<String, dynamic>? map, String id) {
    if (map == null) {
      return AssignmentModel(
        id: id,
        title: '',
        description: '',
        courseId: '',
        dueDate: DateTime.now(),
        createdAt: DateTime.now(),
        createdBy: '',
      );
    }
    return AssignmentModel(
      id: id,
      title: map['title']?.toString() ?? '',
      description: map['description']?.toString() ?? '',
      courseId: map['courseId']?.toString() ?? '',
      dueDate:
          DateTime.tryParse(map['dueDate']?.toString() ?? '') ?? DateTime.now(),
      createdAt:
          DateTime.tryParse(map['createdAt']?.toString() ?? '') ?? DateTime.now(),
      createdBy: map['createdBy']?.toString() ?? '',
      maxScore: (map['maxScore'] as num?)?.toInt() ?? 100,
      submissionText: map['submissionText']?.toString(),
      submittedAt: map['submittedAt'] == null
          ? null
          : DateTime.tryParse(map['submittedAt'].toString()),
      score: (map['score'] as num?)?.toInt(),
      feedback: map['feedback']?.toString(),
    );
  }

  AssignmentModel copyWith({
    String? id,
    String? title,
    String? description,
    String? courseId,
    DateTime? dueDate,
    DateTime? createdAt,
    String? createdBy,
    int? maxScore,
    String? submissionText,
    DateTime? submittedAt,
    int? score,
    String? feedback,
  }) {
    return AssignmentModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      courseId: courseId ?? this.courseId,
      dueDate: dueDate ?? this.dueDate,
      createdAt: createdAt ?? this.createdAt,
      createdBy: createdBy ?? this.createdBy,
      maxScore: maxScore ?? this.maxScore,
      submissionText: submissionText ?? this.submissionText,
      submittedAt: submittedAt ?? this.submittedAt,
      score: score ?? this.score,
      feedback: feedback ?? this.feedback,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'courseId': courseId,
      'dueDate': dueDate.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'createdBy': createdBy,
      'maxScore': maxScore,
      'submissionText': submissionText,
      'submittedAt': submittedAt?.toIso8601String(),
      'score': score,
      'feedback': feedback,
    };
  }
}
