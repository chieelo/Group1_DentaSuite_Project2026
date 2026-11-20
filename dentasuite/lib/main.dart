
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'widgets/shared_widgets.dart';

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
    final p = AppPalette(isDark);
    final brightness = isDark ? Brightness.dark : Brightness.light;
    final base = ThemeData(
      brightness: brightness,
      useMaterial3: true,
    );

    final scheme = ColorScheme.fromSeed(
      seedColor: teal,
      brightness: brightness,
    ).copyWith(
      primary: p.accent,
      onPrimary: p.onAccent,
      secondary: isDark ? mint : teal,
      onSecondary: isDark ? navy : Colors.white,
      secondaryContainer: p.accentSoft,
      onSecondaryContainer: p.textMain,
      surface: p.surface,
      onSurface: p.textMain,
      onSurfaceVariant: p.textSub,
      surfaceContainer: p.surface,
      surfaceContainerHighest: p.surfaceAlt,
      outline: p.textSub,
      outlineVariant: p.border,
      surfaceTint: Colors.transparent,
      error: isDark
          ? const Color(0xFFFF8A80)
          : const Color(0xFFD32F2F),
    );

    final textTheme = base.textTheme.apply(
  fontFamily: GoogleFonts.poppins().fontFamily,
  bodyColor: p.textMain,
  displayColor: p.textMain,
);

    OutlineInputBorder inputBorder(
      Color color, [
      double width = 1,
    ]) {
      return OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: color,
          width: width,
        ),
      );
    }

    final buttonShape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    );

    final buttonText = GoogleFonts.poppins(
      fontSize: 13,
      fontWeight: FontWeight.w600,
    );

    return base.copyWith(
      colorScheme: scheme,
      scaffoldBackgroundColor: p.bg,
      textTheme: textTheme,
      cardColor: p.surface,
      dividerColor: p.border,
      canvasColor: p.surface,

      appBarTheme: AppBarTheme(
        backgroundColor: p.bg,
        foregroundColor: p.textMain,
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        centerTitle: false,
        iconTheme: IconThemeData(
          color: p.textMain,
        ),
        titleTextStyle: GoogleFonts.poppins(
          fontSize: 17,
          fontWeight: FontWeight.w600,
          color: p.textMain,
        ),
      ),

      cardTheme: CardThemeData(
        color: p.surface,
        elevation: 0,
        margin: EdgeInsets.zero,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: p.border),
        ),
      ),

      dividerTheme: DividerThemeData(
        color: p.border,
        thickness: 1,
        space: 1,
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: p.surfaceAlt,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 14,
        ),
        hintStyle: GoogleFonts.poppins(
          fontSize: 12,
          color: p.textSub,
        ),
        labelStyle: GoogleFonts.poppins(
          fontSize: 12,
          color: p.textSub,
        ),
        errorStyle: GoogleFonts.poppins(fontSize: 10),
        prefixIconColor: p.textSub,
        suffixIconColor: p.textSub,
        border: inputBorder(p.border),
        enabledBorder: inputBorder(p.border),
        focusedBorder: inputBorder(p.accent, 1.6),
        errorBorder: inputBorder(scheme.error),
        focusedErrorBorder: inputBorder(scheme.error, 1.6),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: p.accent,
          foregroundColor: p.onAccent,
          elevation: 0,
          shape: buttonShape,
          textStyle: buttonText,
          padding: const EdgeInsets.symmetric(
            horizontal: 18,
            vertical: 13,
          ),
        ),
      ),

      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: p.accent,
          foregroundColor: p.onAccent,
          shape: buttonShape,
          textStyle: buttonText,
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: p.textMain,
          side: BorderSide(
            color: p.border,
            width: 1.4,
          ),
          shape: buttonShape,
          textStyle: buttonText,
          padding: const EdgeInsets.symmetric(
            horizontal: 18,
            vertical: 13,
          ),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: p.accent,
          textStyle: buttonText,
        ),
      ),

      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: p.surface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        height: 68,
        indicatorColor: p.accentSoft,
        indicatorShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);

          return GoogleFonts.poppins(
            fontSize: 11,
            fontWeight: selected
                ? FontWeight.w600
                : FontWeight.w500,
            color: selected ? p.textMain : p.textSub,
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);

          return IconThemeData(
            size: 24,
            color: selected ? p.accent : p.textSub,
          );
        }),
      ),

      tabBarTheme: TabBarThemeData(
        labelColor: p.textMain,
        unselectedLabelColor: p.textSub,
        indicatorColor: p.accent,
        indicatorSize: TabBarIndicatorSize.label,
        dividerColor: p.border,
        labelStyle: GoogleFonts.poppins(
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: GoogleFonts.poppins(
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),

      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          return states.contains(WidgetState.selected)
              ? p.accent
              : Colors.transparent;
        }),
        checkColor: WidgetStatePropertyAll(p.onAccent),
        side: BorderSide(
          color: p.textSub,
          width: 1.5,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
      ),

      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: isDark ? p.surfaceAlt : navy,
        contentTextStyle: GoogleFonts.poppins(
          fontSize: 12,
          color: isDark ? p.textMain : Colors.white,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),

      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: p.surface,
        surfaceTintColor: Colors.transparent,
        showDragHandle: true,
        dragHandleColor: p.border,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(24),
          ),
        ),
      ),

      dialogTheme: DialogThemeData(
        backgroundColor: p.surface,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
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
