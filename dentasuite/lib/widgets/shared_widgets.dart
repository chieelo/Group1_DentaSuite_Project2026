import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const Color mint = Color(0xFFC2FFE1);
const Color navy = Color(0xFF0D203B);
const Color teal = Color(0xFF0E9F8E);
const Color appWhite = Color(0xFFFFFFFF);


const Color background = appWhite;
const Color blue = navy;
const String appFont = 'Poppins';

const LinearGradient heroGradient = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [Color(0xFF0D203B), Color(0xFF116A74)],
);


class AppPalette {
  const AppPalette(this.isDark);

  final bool isDark;


  Color get bg =>
      isDark ? const Color(0xFF08111F) : const Color(0xFFF3F7FB);


  Color get surface =>
      isDark ? const Color(0xFF132339) : Colors.white;

  Color get surfaceAlt =>
      isDark ? const Color(0xFF1B2F4B) : const Color(0xFFEAF1F8);


  Color get border =>
      isDark ? const Color(0xFF27405F) : const Color(0xFFDDE6F0);

  Color get textMain =>
      isDark ? const Color(0xFFEAF2FB) : navy;


  Color get textSub =>
      isDark ? const Color(0xFF9FB3C8) : const Color(0xFF5B6B80);

 
  Color get accent => isDark ? mint : navy;


  Color get accentSoft =>
      isDark ? mint.withValues(alpha: 0.14) : const Color(0xFFDDF7EC);


  Color get onAccent => isDark ? navy : Colors.white;
}

extension AppThemeContext on BuildContext {
  AppPalette get pal =>
      AppPalette(Theme.of(this).brightness == Brightness.dark);
}


TextStyle ts(
  BuildContext context,
  double size, {
  FontWeight weight = FontWeight.w400,
  Color? color,
  bool sub = false,
  double? letterSpacing,
}) {
  final p = context.pal;
  return GoogleFonts.poppins(
    fontSize: size,
    fontWeight: weight,
    letterSpacing: letterSpacing,
    color: color ?? (sub ? p.textSub : p.textMain),
  );
}


Color readableOn(BuildContext context, Color c) {
  if (context.pal.isDark) return c;
  final hsl = HSLColor.fromColor(c);
  return hsl
      .withLightness((hsl.lightness * 0.62).clamp(0.0, 1.0))
      .toColor();
}

String initialsOf(String name) {
  final parts = name
      .trim()
      .split(RegExp(r'\s+'))
      .where((e) => e.isNotEmpty)
      .toList();
  if (parts.isEmpty) return '?';
  if (parts.length == 1) return parts.first[0].toUpperCase();
  return (parts.first[0] + parts.last[0]).toUpperCase();
}

Color genderColor(String gender) {
  switch (gender) {
    case 'Female':
      return const Color(0xFFEC4899);
    case 'Male':
      return const Color(0xFF3B82F6);
    default:
      return const Color(0xFF8B5CF6);
  }
}


Widget appCard({
  required Widget child,
  EdgeInsetsGeometry padding = const EdgeInsets.all(16),
  EdgeInsetsGeometry? margin,
  VoidCallback? onTap,
  double? width = double.infinity,
}) {
  return Builder(
    builder: (context) {
      final p = context.pal;

      return Container(
        width: width,
        margin: margin,
        decoration: BoxDecoration(
          color: p.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: p.border),
          boxShadow: p.isDark
              ? null
              : [
                  BoxShadow(
                    color: navy.withValues(alpha: 0.05),
                    blurRadius: 14,
                    offset: const Offset(0, 4),
                  ),
                ],
        ),
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: onTap,
            child: Padding(padding: padding, child: child),
          ),
        ),
      );
    },
  );
}


Widget iconBubble(
  IconData icon,
  Color color, {
  double size = 42,
  double iconSize = 21,
}) {
  return Container(
    width: size,
    height: size,
    decoration: BoxDecoration(
      color: color.withValues(alpha: 0.15),
      borderRadius: BorderRadius.circular(12),
    ),
    child: Icon(icon, color: color, size: iconSize),
  );
}


Widget statusChip(
  BuildContext context,
  String label,
  Color color, {
  IconData? icon,
}) {
  final textColor = readableOn(context, color);

  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
    decoration: BoxDecoration(
      color: color.withValues(alpha: 0.15),
      borderRadius: BorderRadius.circular(20),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (icon != null) ...[
          Icon(icon, size: 12, color: textColor),
          const SizedBox(width: 4),
        ],
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 10,
            fontWeight: FontWeight.w600,
            color: textColor,
          ),
        ),
      ],
    ),
  );
}

Widget gradientAvatar(String name, {double size = 46}) {
  return Container(
    width: size,
    height: size,
    alignment: Alignment.center,
    decoration: const BoxDecoration(
      gradient: heroGradient,
      shape: BoxShape.circle,
    ),
    child: Text(
      initialsOf(name),
      style: GoogleFonts.poppins(
        color: Colors.white,
        fontWeight: FontWeight.w700,
        fontSize: size * 0.36,
      ),
    ),
  );
}

Widget sectionTitle(String title, {String? subtitle}) {
  return Builder(
    builder: (context) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: ts(context, 17, weight: FontWeight.w700),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 2),
            Text(subtitle, style: ts(context, 12, sub: true)),
          ],
        ],
      );
    },
  );
}

Widget statCard({
  required String title,
  required String value,
  required IconData icon,
  required Color color,
}) {
  return Builder(
    builder: (context) {
      return appCard(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            iconBubble(icon, color, size: 38, iconSize: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: ts(context, 23, weight: FontWeight.w700),
                ),
                Text(title, style: ts(context, 11, sub: true)),
              ],
            ),
          ],
        ),
      );
    },
  );
}

Widget emptyMessage(String message) {
  return Builder(
    builder: (context) {
      final p = context.pal;

      return Center(
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 84,
                height: 84,
                decoration: BoxDecoration(
                  color: p.accentSoft,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.folder_open_rounded,
                  size: 38,
                  color: p.accent,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                message,
                textAlign: TextAlign.center,
                style: ts(context, 13, sub: true),
              ),
            ],
          ),
        ),
      );
    },
  );
}