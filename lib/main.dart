import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'screens/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Official Arcane Legends inspired palette
    const Color primaryGold = Color(0xFFB8860B); // Dark Goldenrod
    const Color deepIndigo = Color(0xFF1A237E); // Deep background depth
    const Color surfaceGrey = Color(0xFF121212); // Dark surface
    const Color errorRed = Color(0xFF8B0000); // Dark Red

    return MaterialApp(
      title: 'Arcane Legend Jewel Calculator',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark, // Using dark mode for game feel
        scaffoldBackgroundColor: const Color(0xFF0A0A0A),
        colorScheme: ColorScheme.fromSeed(
          seedColor: primaryGold,
          primary: primaryGold,
          secondary: deepIndigo,
          surface: surfaceGrey,
          error: errorRed,
          brightness: Brightness.dark,
        ),
        textTheme: GoogleFonts.almendraTextTheme(
          ThemeData.dark().textTheme,
        ).copyWith(
          displayLarge: GoogleFonts.medievalSharp(
            color: primaryGold,
            fontWeight: FontWeight.bold,
          ),
          titleLarge: GoogleFonts.medievalSharp(
            color: primaryGold,
            fontWeight: FontWeight.bold,
          ),
        ),
        cardTheme: CardThemeData(
          elevation: 8,
          color: surfaceGrey,
          margin: const EdgeInsets.all(8),
          shape: RoundedRectangleBorder(
            side: BorderSide(color: primaryGold.withOpacity(0.3), width: 1),
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: const Color(0xFF0A0A0A),
          foregroundColor: primaryGold,
          centerTitle: true,
          titleTextStyle: GoogleFonts.medievalSharp(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: primaryGold,
          ),
          elevation: 0,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryGold,
            foregroundColor: Colors.black,
            textStyle: GoogleFonts.medievalSharp(
              fontWeight: FontWeight.bold,
              letterSpacing: 1.1,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ),
      home: const SplashScreen(),
    );
  }
}
