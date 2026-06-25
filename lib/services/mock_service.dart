import '../data/models/student_model.dart';
import '../data/models/teacher_model.dart';
import '../data/mock_data/students_mock.dart';
import '../data/mock_data/teachers_mock.dart';
import '../data/mock_data/dashboard_mock.dart';

class MockService {
  Future<List<StudentModel>> getStudents() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return StudentsMockData.studentsList.map((s) => StudentModel(
      id: s['initials'] ?? '',
      name: s['name'] ?? '',
      grade: s['class'] ?? '',
      section: 'A',
      rollNo: s['roll'] ?? '',
      avatarUrl: '',
    )).toList();
  }

  Future<List<TeacherModel>> getTeachers() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return mockTeachers;
  }

  Future<Map<String, dynamic>> getDashboardData() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return mockDashboardData;
  }
}

final mockService = MockService();
