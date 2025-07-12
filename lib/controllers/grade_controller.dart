import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../models/course_model.dart';

class GradeController extends GetxController {
  final _storage = GetStorage();
  final semesters = <List<Course>>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadData();
  }

  void addSemester(List<Course> courses) {
    semesters.add(courses);
    saveData();
  }

  double calculateGPA(List<Course> courses) {
    double totalPoints = 0;
    int totalCredits = 0;

    for (var c in courses) {
      totalPoints += c.gradePoint * c.creditHours;
      totalCredits += c.creditHours;
    }

    return totalCredits == 0 ? 0 : (totalPoints / totalCredits);
  }

  double get cgpa {
    double totalPoints = 0;
    int totalCredits = 0;

    for (var semester in semesters) {
      for (var c in semester) {
        totalPoints += c.gradePoint * c.creditHours;
        totalCredits += c.creditHours;
      }
    }

    return totalCredits == 0 ? 0 : (totalPoints / totalCredits);
  }

  void saveData() {
    final rawData = semesters
        .map((sem) => sem
            .map((c) => {
                  'name': c.name,
                  'credit': c.creditHours,
                  'grade': c.gradePoint,
                })
            .toList())
        .toList();
    _storage.write('semesters', rawData);
  }

  void updateSemester(int index, List<Course> newCourses) {
  if (index >= 0 && index < semesters.length) {
    semesters[index] = newCourses;
    saveData();
  }
}

  void loadData() {
    final rawData = _storage.read('semesters');
    if (rawData != null && rawData is List) {
      final loaded = <List<Course>>[];

      for (var sem in rawData) {
        if (sem is List) {
          final semesterCourses = <Course>[];

          for (var c in sem) {
            if (c is Map) {
              semesterCourses.add(Course(
                name: c['name']?.toString() ?? '',
                creditHours: int.tryParse(c['credit'].toString()) ?? 0,
                gradePoint: double.tryParse(c['grade'].toString()) ?? 0.0,
              ));
            }
          }

          loaded.add(semesterCourses);
        }
      }

      semesters.assignAll(loaded);
    }
  }
}
