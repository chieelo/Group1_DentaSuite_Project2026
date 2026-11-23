class AppConfig {
  static const String baseUrl =
      'https://3c64tbzmtd.execute-api.ap-southeast-2.amazonaws.com/dev';

  static const String loginUrl = '$baseUrl/login';

  static const String patientsUrl = '$baseUrl/patients';

  static String patientUrl(String id) => '$patientsUrl/$id';

  static const String usersUrl = '$baseUrl/users';

  static const String updateAccountUrl = '$baseUrl/accounts/own';

  static const String changePasswordUrl = '$baseUrl/change_password';
}
  