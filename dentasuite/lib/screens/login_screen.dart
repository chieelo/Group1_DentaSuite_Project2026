
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

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
  bool isLoading = false;

  static const Color navy = Color(0xFF0D203B);
  static const Color mint = Color(0xFFC2FFE1);
  static const Color gray = Color(0xFF85898D);

  static const double designWidth = 928;
  static const double designHeight = 1648;

  static const String loginUrl =
      'https://3c64tbzmtd.execute-api.ap-southeast-2.amazonaws.com/dev/login';

  bool get isDark =>
      Theme.of(context).brightness == Brightness.dark;

  Color get mainText =>
      isDark ? const Color(0xFFEAF2FB) : navy;

  Color get secondaryText =>
      isDark ? const Color(0xFF9FB3C8) : gray;

  Color get fieldBackground =>
      isDark ? const Color(0xFF1B2F4B) : Colors.white;

  Color get fieldBorder =>
      isDark ? const Color(0xFF49617E) : const Color(0xFFCACDD0);

  Color get buttonBackground =>
      isDark ? mint : navy;

  Color get buttonForeground =>
      isDark ? navy : Colors.white;

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    final username = usernameController.text.trim();
    final password = passwordController.text;

    if (username.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter your username and password.'),
        ),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final requestBody = {
        'a_username': username,
        'a_password': password,
      };

      final response = await http.post(
        Uri.parse(loginUrl),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode(requestBody),
      );

      // debugPrint('========== LOGIN RESPONSE ==========');
      // debugPrint('Status: ${response.statusCode}');
      // debugPrint('Response: ${response.body}');

      if (!mounted) return;

      Map<String, dynamic> responseData = {};

      try {
        final decoded = jsonDecode(response.body);

        if (decoded is Map<String, dynamic>) {
          responseData = decoded;
        }
      } catch (_) {
        debugPrint('Response is not valid JSON.');
      }

      if (response.statusCode == 200) {
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              responseData['message']?.toString() ??
                  'Login failed. Status: ${response.statusCode}',
            ),
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;

      debugPrint('Login Error: $e');

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Unable to connect to the server. Please try again.',
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  InputDecoration _buildFieldDecoration() {
    return InputDecoration(
      filled: true,
      fillColor: fieldBackground,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 14,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(
          color: fieldBorder,
          width: 2,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(
          color: fieldBorder,
          width: 2,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(
          color: isDark ? mint : navy,
          width: 2,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: isDark
          ? const Color(0xFF08111F)
          : Colors.white,
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              isDark
                  ? 'assets/images/login_dark_background.png'
                  : 'assets/images/login_light_background.png',
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
            isDark
                ? 'assets/images/logo_isDark.png'
                : 'assets/images/logo_islight.png',
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
            style: TextStyle(
              fontSize: 57,
              fontWeight: FontWeight.w700,
              color: mainText,
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
            style: TextStyle(
              fontSize: 35,
              color: secondaryText,
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
                cursorColor: isDark ? mint : navy,
                style: TextStyle(
                  fontSize: 35,
                  color: mainText,
                ),
                onChanged: (value) {
                  setState(() {});
                },
                decoration: _buildFieldDecoration(),
              ),

              const SizedBox(height: 42),

              _buildLabel('PASSWORD:'),

              const SizedBox(height: 15),

              SizedBox(
                height: 72,
                child: TextField(
                  controller: passwordController,
                  obscureText: !showPassword,
                  cursorColor: isDark ? mint : navy,
                  style: TextStyle(
                    fontSize: 30,
                    color: mainText,
                  ),
                  onChanged: (value) {
                    setState(() {});
                  },
                  decoration: _buildFieldDecoration(),
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
                        activeColor: isDark ? mint : navy,
                        checkColor: navy,
                        side: BorderSide(
                          color: isDark
                              ? const Color(0xFF9FB3C8)
                              : const Color(0xFF999DA0),
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
                      style: TextStyle(
                        fontSize: 27,
                        color: secondaryText,
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
                    onPressed: isLoading ? null : _login,
                    style: OutlinedButton.styleFrom(
                      backgroundColor: buttonBackground,
                      foregroundColor: buttonForeground,
                      disabledBackgroundColor: isDark
                          ? const Color(0xFF36516B)
                          : const Color(0xFF64748B),
                      disabledForegroundColor: Colors.white,
                      padding: const EdgeInsets.all(5),
                      side: BorderSide(
                        color: isDark ? navy : mint,
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
                          color: isDark
                              ? navy.withValues(alpha: 0.5)
                              : Colors.white,
                          width: 1.5,
                        ),
                        borderRadius: BorderRadius.circular(9),
                      ),
                      child: isLoading
                          ? SizedBox(
                              width: 32,
                              height: 32,
                              child: CircularProgressIndicator(
                                color: buttonForeground,
                                strokeWidth: 3,
                              ),
                            )
                          : Text(
                              'LOG IN',
                              style: TextStyle(
                                fontSize: 34,
                                fontWeight: FontWeight.w700,
                                color: buttonForeground,
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
      style: TextStyle(
        fontSize: 36,
        fontWeight: FontWeight.w700,
        color: mainText,
      ),
    );
  }
}
