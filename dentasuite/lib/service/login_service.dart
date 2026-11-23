import 'dart:convert';
<<<<<<< HEAD
=======
import 'package:dentasuite/config/app_config.dart';
>>>>>>> 868b1a19a975af7bb35714dbaebad48f23b9b066
import 'package:dentasuite/model/user.dart';
import 'package:http/http.dart' as http;

class LoginService {
<<<<<<< HEAD
  static const String loginUrl =
      'https://3c64tbzmtd.execute-api.ap-southeast-2.amazonaws.com/dev/login';

=======
>>>>>>> 868b1a19a975af7bb35714dbaebad48f23b9b066
  Future<AppUser> loginRequest({
    required String username,
    required String password,
  }) async {
    final response = await http.post(
<<<<<<< HEAD
      Uri.parse(loginUrl),
=======
      Uri.parse(AppConfig.loginUrl),
>>>>>>> 868b1a19a975af7bb35714dbaebad48f23b9b066
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode({
        'a_username': username.trim(),
        'a_password': password,
      }),
    );

    Map<String, dynamic> responseData = {};

    try {
      final decoded = jsonDecode(response.body);

      if (decoded is Map<String, dynamic>) {
        responseData = decoded;
      }
    } catch (_) {
      throw Exception('Invalid response from server.');
    }

    if (response.statusCode != 200) {
      throw Exception(
        responseData['message']?.toString() ??
            'Login failed. Status: ${response.statusCode}',
      );
    }

    final userData = responseData['user'] ??
        responseData['data'] ??
        responseData;

    if (userData is! Map<String, dynamic> ||
        userData['a_id'] == null ||
        userData['a_userlvl'] == null) {
      throw Exception(
        'Login succeeded, but the server did not return valid user information.',
      );
    }

    final loginUser = AppUser.fromJson(userData);

    if (loginUser.userLevel < 0 ||
        loginUser.userLevel > 2) {
      throw Exception(
        'Your account has an invalid user role.',
      );
    }

    return loginUser;
  }
<<<<<<< HEAD
}
=======
}
>>>>>>> 868b1a19a975af7bb35714dbaebad48f23b9b066
