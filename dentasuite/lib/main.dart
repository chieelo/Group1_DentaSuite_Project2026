import 'package:flutter/material.dart';

import 'screens/login_screen.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const DentaSuiteApp());
}

class DentaSuiteApp extends StatefulWidget {
  const DentaSuiteApp({super.key});

  @override
  State<DentaSuiteApp> createState() => _DentaSuiteAppState();
}

class _DentaSuiteAppState extends State<DentaSuiteApp> {
  ThemeMode _themeMode = ThemeMode.light;

  void _changeTheme(bool isDark) {
    setState(() {
      _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    });
  }

  ThemeData _buildTheme(bool isDark) {
    const navy = Color(0xFF0D203B);
    const mint = Color(0xFFC2FFE1);
    const darkSurface = Color(0xFF172B46);

    final brightness =
        isDark ? Brightness.dark : Brightness.light;

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,

      colorScheme: ColorScheme.fromSeed(
        seedColor: mint,
        brightness: brightness,
        primary: isDark ? mint : navy,
        secondary: mint,
        surface: isDark ? darkSurface : Colors.white,
      ),

      scaffoldBackgroundColor:
          isDark ? navy : Colors.white,

      cardColor:
          isDark ? darkSurface : Colors.white,

      dividerColor:
          isDark ? Colors.white24 : const Color(0xFFE8EBF0),

      appBarTheme: AppBarTheme(
        backgroundColor:
            isDark ? navy : Colors.white,
        foregroundColor:
            isDark ? Colors.white : navy,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
      ),

      textTheme: isDark
          ? ThemeData.dark().textTheme
          : ThemeData.light().textTheme,
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'DentaSuite',

      theme: _buildTheme(false),
      darkTheme: _buildTheme(true),
      themeMode: _themeMode,

      initialRoute: '/',

      routes: {
        '/': (context) => const LoginScreen(),

        '/home': (context) => DentaSuiteHomeScreen(
              isDarkMode: _themeMode == ThemeMode.dark,
              onThemeChanged: _changeTheme,
            ),
      },
    );
  }
}
