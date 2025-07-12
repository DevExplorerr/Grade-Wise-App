import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final lightTheme = ThemeData(
  brightness: Brightness.light,
  scaffoldBackgroundColor: const Color(0xFFF9F3EF),
  primaryColor: const Color(0xFF456882),
  colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF456882)),
  textTheme: GoogleFonts.poppinsTextTheme(), 
);

final darkTheme = ThemeData(
  brightness: Brightness.dark,
  scaffoldBackgroundColor: const Color(0xFF1B3C53),
  primaryColor: const Color(0xFF456882),
  colorScheme: ColorScheme.dark(primary: const Color(0xFFD2C1B6)),
  textTheme: GoogleFonts.poppinsTextTheme(),
);