import 'package:email_otp/email_otp.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:aasignment_1/views/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  EmailOTP.config(
    appName: 'MyMemberLink',
    otpType: OTPType.numeric,
    emailTheme: EmailTheme.v6,
    otpLength: 4,
  );
  runApp(const MainApp());
  
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Member Link',
      theme: ThemeData(
        scaffoldBackgroundColor: const Color.fromARGB(255, 252, 252, 252), 
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.orange, // Default Flutter orange
          brightness: Brightness.light,
        ).copyWith(
          primary: Colors.orange, // Default Flutter orange
          onPrimary: Colors.white,
          primaryContainer: const Color(0xFFFFCC80), // Lighter shade of orange
          secondary: const Color(0xFFFFA726), // Complementary orange as secondary
          onSecondary: Colors.white,
          surface: Colors.white, // Surface remains white
          onSurface: Colors.black87,
          error: Colors.redAccent,
          onError: Colors.white,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.orange, // Default Flutter orange for AppBar
          foregroundColor: Colors.white, // White text and icons
          iconTheme: IconThemeData(color: Colors.white), // White icons
          titleTextStyle: TextStyle(
            color: Colors.white, // White title text
            fontSize: 20.0, // Optional: Customize the font size
            fontWeight: FontWeight.bold,
          ),
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Color.fromARGB(255, 255, 16, 0), // FAB in red
          foregroundColor: Colors.white, // Ensures text/icon is white
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.orange, // Default Flutter orange
          brightness: Brightness.dark,
        ).copyWith(
          primary: const Color(0xFFFFB74D), // Lighter shade of orange for dark mode
          onPrimary: Colors.black87,
          primaryContainer: const Color(0xFFE65100), // Darker orange container
          secondary: const Color(0xFFFFA726), // Complementary orange
          onSecondary: Colors.black87,
          surface: const Color(0xFF303030), // Dark grey for surface in dark mode
          onSurface: Colors.white,
          error: Colors.redAccent,
          onError: Colors.black87,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.orange, // Default Flutter orange for AppBar
          foregroundColor: Colors.white, // White text and icons
          iconTheme: IconThemeData(color: Colors.white), // White icons
          titleTextStyle: TextStyle(
            color: Colors.white, // White title text
            fontSize: 20.0, // Optional: Customize the font size
            fontWeight: FontWeight.bold,
          ),
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Color.fromARGB(255, 255, 16, 0), // FAB in red
          foregroundColor: Colors.white, // Ensures text/icon is white
        ),
      ),
      home: const SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
