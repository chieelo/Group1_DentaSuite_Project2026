import 'package:flutter/material.dart';
import 'screens/login_screen.dart';

void main() {
  runApp(const DentDeskApp());
}

class DentDeskApp extends StatelessWidget {
  const DentDeskApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'DentDesk',
      home: const LoginScreen(),
    );
  }
}