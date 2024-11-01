import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:project/screens/tabs.dart';

final theme = ThemeData(
  colorScheme: ColorScheme.fromSeed(
    seedColor: const Color.fromARGB(255, 88, 42, 114),
    brightness: Brightness.dark,
  ),
  textTheme: GoogleFonts.ptSansCaptionTextTheme(),
);

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: theme,
      home: const TabsScreen(),
    );
  }
}
