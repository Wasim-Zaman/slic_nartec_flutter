import 'package:flutter/material.dart';
import 'package:slic/core/theme.dart';
import 'package:slic/view/screens/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SLIC',
      theme: AppTheme.theme,
      // ThemeData(
      //   colorScheme: ColorScheme.fromSeed(seedColor: ColorPallete.primary),
      //   useMaterial3: true,
      // ),
      home: const HomeScreen(),
    );
  }
}
