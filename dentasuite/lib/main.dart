import 'package:flutter/material.dart';
import 'screens/login_screen.dart';

void main() {
  runApp(const DentaSuite());
}

class DentaSuite extends StatelessWidget {
  const DentaSuite({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'DentaSuite',
      home: const LoginScreen(),
    );
  }
}