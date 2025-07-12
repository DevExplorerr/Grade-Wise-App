import 'package:flutter/material.dart';
import '../models/course_model.dart';

class SemesterCard extends StatelessWidget {
  final int semesterIndex;
  final List<Course> courses;
  final String gpa;
  final VoidCallback onDelete;
  final VoidCallback onEdit;

  const SemesterCard({
    super.key,
    required this.semesterIndex,
    required this.courses,
    required this.gpa,
    required this.onDelete,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final textColor = Theme.of(context).colorScheme.onSurface;

    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(screenWidth * 0.05),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Semester $semesterIndex",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: screenWidth * 0.045,
                    color: textColor,
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                        icon: const Icon(Icons.edit, color: Colors.grey),
                        onPressed: onEdit),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: onDelete,
                    ),
                  ],
                )
              ],
            ),

            const Divider(),

            ...courses.map(
              (c) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: Text(
                  "${c.name} - ${c.creditHours} Cr | Grade: ${c.gradePoint}",
                  style: TextStyle(
                    fontSize: screenWidth * 0.038,
                    color: textColor,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 10),

            // GPA Display
            Text(
              "GPA: $gpa",
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: screenWidth * 0.05,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
