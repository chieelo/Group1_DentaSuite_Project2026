
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController usernameController =
      TextEditingController();

  final TextEditingController passwordController =
      TextEditingController();

  bool showPassword = false;

  static const Color navy = Color(0xFF0D203B);
  static const Color mint = Color(0xFFC2FFE1);
  static const Color gray = Color(0xFF85898D);

  static const double designWidth = 928;
  static const double designHeight = 1648;

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  InputDecoration _buildFieldDecoration({
    required bool hasText,
  }) {
    if (hasText) {
      return const InputDecoration(
        filled: false,
        contentPadding: EdgeInsets.only(bottom: 8),
        border: UnderlineInputBorder(
          borderSide: BorderSide(
            color: navy,
            width: 2,
          ),
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: navy,
            width: 2,
          ),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: navy,
            width: 2,
          ),
        ),
      );
    }

    return InputDecoration(
      filled: true,
      fillColor: Colors.white.withOpacity(0.8),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 14,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(
          color: Color(0xFFCACDD0),
          width: 2,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(
          color: Color(0xFFCACDD0),
          width: 2,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(
          color: navy,
          width: 2,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/login_light_background.png',
              fit: BoxFit.cover,
            ),
          ),

          Positioned.fill(
            child: Center(
              child: FittedBox(
                fit: BoxFit.contain,
                child: SizedBox(
                  width: designWidth,
                  height: designHeight,
                  child: _buildLoginDesign(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoginDesign() {
    return Stack(
      children: [
        Positioned(
          top: 285,
          left: 205,
          width: 550,
          height: 350,
          child: Image.asset(
            Theme.of(context).brightness == Brightness.dark
                ? 'assets/images/logo_isDark.png'
                : 'assets/images/logo_islight.png',
            fit: BoxFit.contain,
          ),
        ),

        Positioned(
          top: 690,
          left: 0,
          right: 0,
          child: const Text(
            'Sign in to DentaSuite',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 57,
              fontWeight: FontWeight.w700,
              color: navy,
            ),
          ),
        ),

        Positioned(
          top: 780,
          left: 0,
          right: 0,
          child: const Text(
            'Enter your details below.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 35,
              color: gray,
            ),
          ),
        ),

        Positioned(
          top: 905,
          left: 123,
          width: 684,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildLabel('USERNAME:'),

              const SizedBox(height: 16),

              TextField(
                controller: usernameController,
                style: const TextStyle(
                  fontSize: 35,
                  color: navy,
                ),
                onChanged: (value) {
                  setState(() {});
                },
                decoration: _buildFieldDecoration(
                  hasText: usernameController.text.isNotEmpty,
                ),
              ),

              const SizedBox(height: 42),

              _buildLabel('PASSWORD:'),

              const SizedBox(height: 15),

              SizedBox(
                height: 72,
                child: TextField(
                  controller: passwordController,
                  obscureText: !showPassword,
                  style: const TextStyle(
                    fontSize: 30,
                    color: navy,
                  ),
                  onChanged: (value) {
                    setState(() {});
                  },
                  decoration: _buildFieldDecoration(
                    hasText: passwordController.text.isNotEmpty,
                  ),
                ),
              ),

              SizedBox(
                height: 65,
                child: Row(
                  children: [
                    SizedBox(
                      width: 38,
                      height: 48,
                      child: Checkbox(
                        value: showPassword,
                        activeColor: navy,
                        side: const BorderSide(
                          color: Color(0xFF999DA0),
                          width: 2,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        onChanged: (value) {
                          setState(() {
                            showPassword = value ?? false;
                          });
                        },
                      ),
                    ),

                    const SizedBox(width: 10),

                    const Text(
                      'Show Password',
                      style: TextStyle(
                        fontSize: 27,
                        color: gray,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 40),

              Center(
                child: SizedBox(
                  width: 434,
                  height: 92,
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(
                        context,
                        '/home',
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      backgroundColor: navy,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.all(5),
                      side: const BorderSide(
                        color: mint,
                        width: 3,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(13),
                      ),
                    ),
                    child: Container(
                      width: double.infinity,
                      height: double.infinity,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.white,
                          width: 1.5,
                        ),
                        borderRadius: BorderRadius.circular(9),
                      ),
                      child: const Text(
                        'LOG IN',
                        style: TextStyle(
                          fontSize: 34,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 36,
        fontWeight: FontWeight.w700,
        color: navy,
      ),
    );
  }
}