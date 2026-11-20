import 'package:flutter/material.dart';

class AppLogo extends StatelessWidget {
  final double width;
  final double height;

  const AppLogo({
    super.key,
    this.width = 120,
    this.height = 120,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Image.asset(
      isDark
          ? 'assets/images/logo_isDark.png'
          : 'assets/images/logo_islight.png',
      width: width,
      height: height,
      fit: BoxFit.contain,
    );
  }
}