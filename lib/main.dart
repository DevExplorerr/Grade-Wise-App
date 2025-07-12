import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:grade_wise/theme/theme.dart';
import 'controllers/grade_controller.dart';
import 'screens/home_screen.dart';
import 'theme/theme_service.dart';

void main() async {
  await GetStorage.init();
  Get.put(GradeController()); // Initialize controller

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'GradeWise',
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: ThemeService().theme,
      home: const HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
