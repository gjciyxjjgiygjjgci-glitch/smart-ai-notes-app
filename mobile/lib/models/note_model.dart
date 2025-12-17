class Note {
  final String id;
  final String userId;
  final String title;
  final String transcript;
  final Map<String, String> summaries;
  final List<String> subjectTags;
  final DateTime createdAt;
  final DateTime updatedAt;

  Note({
    required this.id,
    required this.userId,
    required this.title,
    required this.transcript,
    required this.summaries,
    required this.subjectTags,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Note.fromJson(Map<String, dynamic> json) {
    return Note(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      title: json['title'] ?? '',
      transcript: json['transcript'] ?? '',
      summaries: Map<String, String>.from(json['summaries'] ?? {}),
      subjectTags: List<String>.from(json['subjectTags'] ?? []),
      createdAt: json['createdAt'] != null 
          ? DateTime.parse(json['createdAt']) 
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null 
          ? DateTime.parse(json['updatedAt']) 
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'title': title,
      'transcript': transcript,
      'summaries': summaries,
      'subjectTags': subjectTags,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  Note copyWith({
    String? id,
    String? userId,
    String? title,
    String? transcript,
    Map<String, String>? summaries,
    List<String>? subjectTags,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Note(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      transcript: transcript ?? this.transcript,
      summaries: summaries ?? this.summaries,
      subjectTags: subjectTags ?? this.subjectTags,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
