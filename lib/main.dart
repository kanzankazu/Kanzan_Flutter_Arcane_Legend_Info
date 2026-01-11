import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Arcane Legend Jewel Calculator',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        primarySwatch: Colors.blue,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue.shade900,
          primary: Colors.blue.shade900,
        ),
        cardTheme: const CardThemeData(
          elevation: 2,
          margin: EdgeInsets.all(8),
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.blue.shade900,
          foregroundColor: Colors.white,
        ),
      ),
      home: const SplashScreen(),
    );
  }
}
