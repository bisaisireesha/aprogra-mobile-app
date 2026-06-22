class TeacherModel {
  final String id;
  final String name;
  final String subject;
  final String qualification;
  final String experience;
  final String avatarUrl;

  TeacherModel({
    required this.id,
    required this.name,
    required this.subject,
    required this.qualification,
    required this.experience,
    required this.avatarUrl,
  });

  factory TeacherModel.fromJson(Map<String, dynamic> json) {
    return TeacherModel(
      id: json['id'] as String,
      name: json['name'] as String,
      subject: json['subject'] as String,
      qualification: json['qualification'] as String,
      experience: json['experience'] as String,
      avatarUrl: json['avatarUrl'] as String? ?? '',
    );
  }
}
