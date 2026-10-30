
import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const LinguaLearnApp());
}

class LinguaLearnApp extends StatelessWidget {
  const LinguaLearnApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Language Learning App',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6558F5),
        ),
        scaffoldBackgroundColor: const Color(0xFFF5F6FC),
      ),
      home: const HomeScreen(),
    );
  }
}
