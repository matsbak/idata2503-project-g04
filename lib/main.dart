import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:project/widgets/project.dart';

final theme = ThemeData(
  colorScheme: ColorScheme.fromSeed(
    seedColor: const Color.fromARGB(255, 255, 186, 84),
  ),
  textTheme: GoogleFonts.ptSansCaptionTextTheme(),
);

void main() {
  runApp(const Project());
}
