import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/grade_controller.dart';
import '../models/course_model.dart';
import '../theme/theme_service.dart';
import '../widgets/semester_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GradeController controller = Get.find();
  final storage = GetStorage();

  final List<Course> _currentCourses = [];
  final nameController = TextEditingController();
  final creditController = TextEditingController();
  final gradeController = TextEditingController();

  bool isPerCreditMode = true;

  @override
  void initState() {
    super.initState();
    isPerCreditMode = storage.read('gradeMode') ?? true;
  }

  void _addCourse() {
    if (nameController.text.isEmpty ||
        creditController.text.isEmpty ||
        gradeController.text.isEmpty) {
      return;
    }

    final credit = int.parse(creditController.text);
    final gradeInput = double.parse(gradeController.text);

    final course = Course(
      name: nameController.text,
      creditHours: credit,
      gradePoint: isPerCreditMode ? gradeInput : (gradeInput / credit),
    );

    setState(() {
      _currentCourses.add(course);
      nameController.clear();
      creditController.clear();
      gradeController.clear();
    });
  }

  void _saveSemester() {
    if (_currentCourses.isNotEmpty) {
      controller.addSemester(List.from(_currentCourses));
      setState(() {
        _currentCourses.clear();
      });
    }
  }

  double getCurrentGPA() {
    double totalPoints = 0;
    int totalCredits = 0;

    for (var c in _currentCourses) {
      totalPoints += c.gradePoint * c.creditHours;
      totalCredits += c.creditHours;
    }

    return totalCredits == 0 ? 0.0 : (totalPoints / totalCredits);
  }

  void _showEditDialog(int semesterIndex, List<Course> originalCourses) {
    final List<Course> editableCourses = List<Course>.from(originalCourses);
    final nameController = TextEditingController();
    final creditController = TextEditingController();
    final gradeController = TextEditingController();
    bool localPerCreditMode = storage.read('gradeMode') ?? true;

    void addCourse() {
      if (nameController.text.isEmpty ||
          creditController.text.isEmpty ||
          gradeController.text.isEmpty) {
        return;
      }

      final credit = int.parse(creditController.text);
      final gradeInput = double.parse(gradeController.text);

      editableCourses.add(Course(
        name: nameController.text,
        creditHours: credit,
        gradePoint: localPerCreditMode ? gradeInput : (gradeInput / credit),
      ));

      nameController.clear();
      creditController.clear();
      gradeController.clear();
    }

    showDialog(
      context: context,
      builder: (_) {
        return StatefulBuilder(
          builder: (context, setState) => AlertDialog(
            title: const Text("Edit Semester"),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  SwitchListTile(
                    title: Text(
                      localPerCreditMode
                          ? "Mode: Per-Credit Grade (e.g. 4.0)"
                          : "Mode: Total Grade Points (e.g. 12.0)",
                      style: GoogleFonts.poppins(fontSize: 13),
                    ),
                    value: localPerCreditMode,
                    onChanged: (val) {
                      setState(() {
                        localPerCreditMode = val;
                        storage.write('gradeMode', val);
                      });
                    },
                  ),
                  ...editableCourses.map((c) => ListTile(
                        title: Text(c.name),
                        subtitle: Text(
                            "${c.creditHours} Cr | Grade: ${c.gradePoint}"),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            setState(() => editableCourses.remove(c));
                          },
                        ),
                      )),
                  const Divider(),
                  TextField(
                    controller: nameController,
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface),
                    decoration: InputDecoration(
                      labelText: 'Course Name',
                      labelStyle: TextStyle(
                          color: Theme.of(context).colorScheme.onSurface),
                    ),
                  ),
                  TextField(
                    controller: creditController,
                    keyboardType: TextInputType.number,
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface),
                    decoration: InputDecoration(
                      labelText: 'Credit Hours',
                      labelStyle: TextStyle(
                          color: Theme.of(context).colorScheme.onSurface),
                    ),
                  ),
                  TextField(
                    controller: gradeController,
                    keyboardType: TextInputType.number,
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface),
                    decoration: InputDecoration(
                      labelText: localPerCreditMode
                          ? 'Grade per Credit (e.g. 4.0)'
                          : 'Total Grade Points (e.g. 12.0)',
                      labelStyle: TextStyle(
                          color: Theme.of(context).colorScheme.onSurface),
                    ),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () {
                      setState(() => addCourse());
                    },
                    child: const Text("Add Course"),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Cancel"),
              ),
              ElevatedButton(
                onPressed: () {
                  controller.updateSemester(semesterIndex, editableCourses);
                  Navigator.pop(context);
                },
                child: const Text("Save"),
              )
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final onSurface = Theme.of(context).colorScheme.onSurface;
    final dividerColor = Theme.of(context).dividerColor;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'GradeWise',
          style: GoogleFonts.poppins(),
        ),
        actions: [
          IconButton(
            icon: Icon(Get.isDarkMode ? Icons.light_mode : Icons.dark_mode),
            onPressed: () => ThemeService().switchTheme(),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SwitchListTile(
              title: Text(
                isPerCreditMode
                    ? "Mode: Per-Credit Grade (e.g. 4.0)"
                    : "Mode: Total Grade Points (e.g. 12.0)",
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              value: isPerCreditMode,
              onChanged: (val) {
                setState(() {
                  isPerCreditMode = val;
                  storage.write('gradeMode', val);
                });
              },
            ),
            TextField(
              controller: nameController,
              style: TextStyle(color: onSurface),
              decoration: InputDecoration(
                labelText: 'Course Name',
                labelStyle: TextStyle(color: onSurface),
                enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: dividerColor)),
              ),
            ),
            TextField(
              controller: creditController,
              keyboardType: TextInputType.number,
              style: TextStyle(color: onSurface),
              decoration: InputDecoration(
                labelText: 'Credit Hours',
                labelStyle: TextStyle(color: onSurface),
                enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: dividerColor)),
              ),
            ),
            TextField(
              controller: gradeController,
              keyboardType: TextInputType.number,
              style: TextStyle(color: onSurface),
              decoration: InputDecoration(
                labelText: isPerCreditMode
                    ? 'Grade per Credit (e.g. 4.0)'
                    : 'Total Grade Points (e.g. 12.0)',
                labelStyle: TextStyle(color: onSurface),
                enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: dividerColor)),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _addCourse,
              child: const Text('Add Course'),
            ),
            const SizedBox(height: 20),
            if (_currentCourses.isNotEmpty) ...[
              Text("Current Semester",
                  style: GoogleFonts.poppins(
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: screenWidth * 0.045,
                      fontWeight: FontWeight.w600)),
              Column(
                children: _currentCourses
                    .map((course) => ListTile(
                          title: Text(course.name,
                              style: GoogleFonts.poppins(fontSize: 14)),
                          subtitle: Text(
                              "${course.creditHours} Cr | Grade: ${course.gradePoint}",
                              style: GoogleFonts.poppins(fontSize: 12)),
                        ))
                    .toList(),
              ),
              const SizedBox(height: 10),
              Text(
                "Current GPA Preview: ${getCurrentGPA().toStringAsFixed(2)}",
                style: GoogleFonts.poppins(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: screenWidth * 0.045),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: _saveSemester,
                child: const Text("Save Semester"),
              ),
            ],
            const Divider(height: 40),
            Text("Semesters",
                style: GoogleFonts.poppins(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontSize: screenWidth * 0.05,
                    fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Obx(() => Column(
                  children: controller.semesters
                      .asMap()
                      .entries
                      .map((entry) => SemesterCard(
                            semesterIndex: entry.key + 1,
                            courses: entry.value,
                            gpa: controller
                                .calculateGPA(List<Course>.from(entry.value))
                                .toStringAsFixed(2),
                            onDelete: () {
                              controller.semesters.removeAt(entry.key);
                              controller.saveData();
                            },
                            onEdit: () {
                              _showEditDialog(entry.key, entry.value);
                            },
                          ))
                      .toList(),
                )),
            const SizedBox(height: 20),
            Obx(() => Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  margin: const EdgeInsets.only(top: 8),
                  color: Theme.of(context).cardColor,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Cumulative GPA (CGPA): ",
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                        Text(
                          controller.cgpa.toStringAsFixed(2),
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
