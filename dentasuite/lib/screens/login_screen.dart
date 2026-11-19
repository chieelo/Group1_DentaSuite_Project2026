import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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

  static const Color navy = Color(0xFF202D4E);
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
      // Underline appearance when user enters information
      return const InputDecoration(
        filled: false,
        contentPadding: EdgeInsets.only(bottom: 8),
        border: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Color(0xFF174B88),
            width: 2,
          ),
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Color(0xFF174B88),
            width: 2,
          ),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Color(0xFF174B88),
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
              'assets/login_light_background.png',
              fit: BoxFit.cover,
            ),
          ),

          Positioned.fill(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Center(
                  child: FittedBox(
                    fit: BoxFit.contain,
                    child: SizedBox(
                      width: designWidth,
                      height: designHeight,
                      child: _buildLoginDesign(),
                    ),
                  ),
                );
              },
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
            'assets/dentasuite_logo.png',
            fit: BoxFit.contain,
          ),
        ),

        Positioned(
          top: 690,
          left: 0,
          right: 0,
          child: Text(
            'Sign in to DentaSuite',
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
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
          child: Text(
            'Enter your details below.',
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
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
                style: GoogleFonts.poppins(
                  fontSize: 35,
                  color: gray,
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
                  style: GoogleFonts.poppins(
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
                    Text(
                      'Show Password',
                      style: GoogleFonts.poppins(
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
                      // Connect authentication here.
                    },
                    style: OutlinedButton.styleFrom(
                      backgroundColor: navy,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.all(5),
                      side: const BorderSide(
                        color: Color(0xFF174B88),
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
                      child: Text(
                        'LOG IN',
                        style: GoogleFonts.poppins(
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
      style: GoogleFonts.poppins(
        fontSize: 36,
        fontWeight: FontWeight.w700,
        color: navy,
      ),
    );
  }
}
