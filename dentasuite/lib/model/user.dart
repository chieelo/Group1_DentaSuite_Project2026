class AppUser {
  final String id;
  final String username;
  final String email;
  final String firstName;
  final String lastName;
  final String contactNumber;
  final int userLevel;

  const AppUser({
    required this.id,
    required this.username,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.contactNumber,
    required this.userLevel,
  });

  factory AppUser.fromJson(Map<String, dynamic> json) {
    return AppUser(
      id: json['a_id']?.toString() ?? '',
      username: json['a_username']?.toString() ?? '',
      email: json['a_email']?.toString() ?? '',
      firstName: json['a_firstname']?.toString() ?? '',
      lastName: json['a_lastname']?.toString() ?? '',
      contactNumber: json['a_contactnumber']?.toString() ?? '',
      userLevel: int.parse(json['a_userlvl'].toString()),
    );
  }

  String get fullName => '$firstName $lastName';

  String get role {
    switch (userLevel) {
      case 0:
        return 'ADMINISTRATOR';
      case 1:
        return 'DENTIST';
      case 2:
        return 'ASSISTANT';
      default:
        return 'UNKNOWN';
    }
  }

  bool get isAdmin => userLevel == 0;
  bool get isDentist => userLevel == 1;
  bool get isAssistant => userLevel == 2;
}