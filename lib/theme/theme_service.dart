import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ThemeService {
  final _box = GetStorage();
  final _key = 'isDarkMode';

  ThemeMode get theme =>
      _loadThemeFromBox() ? ThemeMode.dark : ThemeMode.light;

  bool _loadThemeFromBox() => _box.read(_key) ?? false;

  void switchTheme() {
    Get.changeThemeMode(_loadThemeFromBox() ? ThemeMode.light : ThemeMode.dark);
    _box.write(_key, !_loadThemeFromBox());
  }
}
