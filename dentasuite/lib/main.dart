import 'package:flutter/material.dart';
import 'screens/login_screen.dart';

void main() {
<<<<<<< HEAD
  runApp(const DentDeskApp());
}

class DentDeskApp extends StatelessWidget {
  const DentDeskApp({super.key});
=======
  runApp(const DentaSuite());
}

class DentaSuite extends StatelessWidget {
  const DentaSuite({super.key});
>>>>>>> c8a408efece41f0691a5cac3be1eb1e700013f91

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
<<<<<<< HEAD
      title: 'DentDesk',
=======
      title: 'DentaSuite',
>>>>>>> c8a408efece41f0691a5cac3be1eb1e700013f91
      home: const LoginScreen(),
    );
  }
}