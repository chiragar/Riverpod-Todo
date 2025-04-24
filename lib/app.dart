import 'package:flutter/material.dart';
import 'package:riverpodtodo/core/theme/app_themes.dart';
import 'package:riverpodtodo/ui/screen/home_screen.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo with Riverpod',
      theme: AppThemes.light,
      themeMode: ThemeMode.light,
      home: const HomeScreen(),
    );
  }
}
