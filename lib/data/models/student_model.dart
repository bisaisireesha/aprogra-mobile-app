class StudentModel {
  final String id;
  final String name;
  final String grade;
  final String section;
  final String rollNo;
  final String avatarUrl;

  StudentModel({
    required this.id,
    required this.name,
    required this.grade,
    required this.section,
    required this.rollNo,
    required this.avatarUrl,
  });

  factory StudentModel.fromJson(Map<String, dynamic> json) {
    return StudentModel(
      id: json['id'] as String,
      name: json['name'] as String,
      grade: json['grade'] as String,
      section: json['section'] as String,
      rollNo: json['rollNo'] as String,
      avatarUrl: json['avatarUrl'] as String? ?? '',
    );
  }
}
