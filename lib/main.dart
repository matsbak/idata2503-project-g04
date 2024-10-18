import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:project/screens/tabs.dart';

final theme = ThemeData(
  colorScheme: ColorScheme.fromSeed(
    seedColor: const Color.fromARGB(255, 255, 224, 102),
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
