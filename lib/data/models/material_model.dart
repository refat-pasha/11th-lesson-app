class MaterialModel {
  const MaterialModel({
    required this.id,
    required this.title,
    required this.description,
    required this.courseId,
    required this.uploadedBy,
    required this.fileUrl,
    required this.fileType,
    required this.isPublic,
    required this.createdAt,
    required this.category,
    required this.fileName,
    required this.tags,
    required this.visibility,
    this.isOffline = false,
    this.downloadCount = 0,
    this.sizeMb = 4,
  });

  final String id;
  final String title;
  final String description;
  final String courseId;
  final String uploadedBy;
  final String fileUrl;
  final String fileType;
  final bool isPublic;
  final DateTime createdAt;
  final String category;
  final String fileName;
  final List<String> tags;
  final String visibility;
  final bool isOffline;
  final int downloadCount;
  final int sizeMb;

  factory MaterialModel.fromMap(Map<String, dynamic> map, String id) {
    return MaterialModel(
      id: id,
      title: map['title']?.toString() ?? '',
      description: map['description']?.toString() ?? '',
      courseId: map['courseId']?.toString() ?? '',
      uploadedBy: map['uploadedBy']?.toString() ?? '',
      fileUrl: map['fileUrl']?.toString() ?? '',
      fileType: map['fileType']?.toString() ?? 'pdf',
      isPublic: map['isPublic'] as bool? ?? true,
      createdAt:
          DateTime.tryParse(map['createdAt']?.toString() ?? '') ?? DateTime.now(),
      category: map['category']?.toString() ?? 'Notes',
      fileName: map['fileName']?.toString() ?? '',
      tags: List<String>.from(map['tags'] ?? const []),
      visibility: map['visibility']?.toString() ?? 'My Courses',
      isOffline: map['isOffline'] as bool? ?? false,
      downloadCount: (map['downloadCount'] as num?)?.toInt() ?? 0,
      sizeMb: (map['sizeMb'] as num?)?.toInt() ?? 4,
    );
  }

  MaterialModel copyWith({
    String? id,
    String? title,
    String? description,
    String? courseId,
    String? uploadedBy,
    String? fileUrl,
    String? fileType,
    bool? isPublic,
    DateTime? createdAt,
    String? category,
    String? fileName,
    List<String>? tags,
    String? visibility,
    bool? isOffline,
    int? downloadCount,
    int? sizeMb,
  }) {
    return MaterialModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      courseId: courseId ?? this.courseId,
      uploadedBy: uploadedBy ?? this.uploadedBy,
      fileUrl: fileUrl ?? this.fileUrl,
      fileType: fileType ?? this.fileType,
      isPublic: isPublic ?? this.isPublic,
      createdAt: createdAt ?? this.createdAt,
      category: category ?? this.category,
      fileName: fileName ?? this.fileName,
      tags: tags ?? this.tags,
      visibility: visibility ?? this.visibility,
      isOffline: isOffline ?? this.isOffline,
      downloadCount: downloadCount ?? this.downloadCount,
      sizeMb: sizeMb ?? this.sizeMb,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'courseId': courseId,
      'uploadedBy': uploadedBy,
      'fileUrl': fileUrl,
      'fileType': fileType,
      'isPublic': isPublic,
      'createdAt': createdAt.toIso8601String(),
      'category': category,
      'fileName': fileName,
      'tags': tags,
      'visibility': visibility,
      'isOffline': isOffline,
      'downloadCount': downloadCount,
      'sizeMb': sizeMb,
    };
  }
}
