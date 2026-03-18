class GroupMessageModel {
  const GroupMessageModel({
    required this.author,
    required this.body,
    required this.sentAt,
  });

  final String author;
  final String body;
  final DateTime sentAt;

  factory GroupMessageModel.fromMap(Map<String, dynamic> map) {
    return GroupMessageModel(
      author: map['author']?.toString() ?? '',
      body: map['body']?.toString() ?? '',
      sentAt:
          DateTime.tryParse(map['sentAt']?.toString() ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'author': author,
      'body': body,
      'sentAt': sentAt.toIso8601String(),
    };
  }
}

class GroupModel {
  const GroupModel({
    required this.id,
    required this.name,
    required this.subject,
    required this.description,
    required this.createdBy,
    required this.members,
    required this.createdAt,
    this.resourceLinks = const [],
    this.messages = const [],
  });

  final String id;
  final String name;
  final String subject;
  final String description;
  final String createdBy;
  final List<String> members;
  final DateTime createdAt;
  final List<String> resourceLinks;
  final List<GroupMessageModel> messages;

  factory GroupModel.fromMap(Map<String, dynamic> map, String id) {
    return GroupModel(
      id: id.isEmpty ? map['id']?.toString() ?? '' : id,
      name: map['name']?.toString() ?? '',
      subject: map['subject']?.toString() ?? '',
      description: map['description']?.toString() ?? '',
      createdBy: map['createdBy']?.toString() ?? '',
      members: List<String>.from(map['members'] ?? []),
      createdAt:
          DateTime.tryParse(map['createdAt']?.toString() ?? '') ?? DateTime.now(),
      resourceLinks: List<String>.from(map['resourceLinks'] ?? const []),
      messages: (map['messages'] as List<dynamic>? ?? const [])
          .map((item) => GroupMessageModel.fromMap(
              Map<String, dynamic>.from(item as Map)))
          .toList(),
    );
  }

  GroupModel copyWith({
    String? id,
    String? name,
    String? subject,
    String? description,
    String? createdBy,
    List<String>? members,
    DateTime? createdAt,
    List<String>? resourceLinks,
    List<GroupMessageModel>? messages,
  }) {
    return GroupModel(
      id: id ?? this.id,
      name: name ?? this.name,
      subject: subject ?? this.subject,
      description: description ?? this.description,
      createdBy: createdBy ?? this.createdBy,
      members: members ?? this.members,
      createdAt: createdAt ?? this.createdAt,
      resourceLinks: resourceLinks ?? this.resourceLinks,
      messages: messages ?? this.messages,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'subject': subject,
      'description': description,
      'createdBy': createdBy,
      'members': members,
      'createdAt': createdAt.toIso8601String(),
      'resourceLinks': resourceLinks,
      'messages': messages.map((item) => item.toMap()).toList(),
    };
  }
}
