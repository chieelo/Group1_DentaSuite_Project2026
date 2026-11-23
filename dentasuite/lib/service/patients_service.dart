import 'dart:convert';

import 'package:http/http.dart' as http;

import '../config/app_config.dart';

class PatientsService {
  static const _headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  /// GET /patients
  /// API response currently observed:
  /// { "ok": true, "patients": [ { "patient": {...}, "medical": {...} } ] }
  Future<List<Map<String, String>>> fetchPatients() async {
    final response = await http.get(
      Uri.parse(AppConfig.patientsUrl),
      headers: _headers,
    );

    final decoded = _decodeResponse(response);

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception(
        decoded['message']?.toString() ??
            'Unable to load patients (${response.statusCode}).',
      );
    }

    final rows = decoded['patients'];
    if (rows is! List) {
      throw Exception('Unexpected GET /patients response: patients list missing.');
    }

    return rows
        .whereType<Map>()
        .map((row) => _toAppPatient(Map<String, dynamic>.from(row)))
        .toList();
  }

  /// POST /patients. The caller must provide the exact request body
  /// expected by the backend (confirm its schema with the API developer).
  Future<Map<String, dynamic>> createPatient(
    Map<String, dynamic> requestBody,
  ) async {
    final response = await http.post(
      Uri.parse(AppConfig.patientsUrl),
      headers: _headers,
      body: jsonEncode(requestBody),
    );
    final decoded = _decodeResponse(response);
    _ensureSuccess(response, decoded, 'create patient');
    return decoded;
  }

  /// PATCH /patients/{id}. Supply only fields accepted by the backend.
  Future<Map<String, dynamic>> updatePatient(
    String id,
    Map<String, dynamic> requestBody,
  ) async {
    final response = await http.patch(
      Uri.parse(AppConfig.patientUrl(Uri.encodeComponent(id))),
      headers: _headers,
      body: jsonEncode(requestBody),
    );
    final decoded = _decodeResponse(response);
    _ensureSuccess(response, decoded, 'update patient');
    return decoded;
  }

  /// DELETE /patients/{id}
  Future<void> deletePatient(String id) async {
    final response = await http.delete(
      Uri.parse(AppConfig.patientUrl(Uri.encodeComponent(id))),
      headers: _headers,
    );
    final decoded = _decodeResponse(response);
    _ensureSuccess(response, decoded, 'delete patient');
  }

  Map<String, dynamic> _decodeResponse(http.Response response) {
    if (response.body.trim().isEmpty) return <String, dynamic>{};
    try {
      final decoded = jsonDecode(response.body);
      if (decoded is Map<String, dynamic>) return decoded;
      throw Exception('The server returned an unexpected response.');
    } on FormatException {
      throw Exception('The server returned invalid JSON.');
    }
  }

  void _ensureSuccess(
    http.Response response,
    Map<String, dynamic> decoded,
    String action,
  ) {
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception(
        decoded['message']?.toString() ??
            'Unable to $action (${response.statusCode}).',
      );
    }
  }

  Map<String, String> _toAppPatient(Map<String, dynamic> row) {
    final patient = row['patient'] is Map
        ? Map<String, dynamic>.from(row['patient'] as Map)
        : row;
    final medical = row['medical'] is Map
        ? Map<String, dynamic>.from(row['medical'] as Map)
        : <String, dynamic>{};

    String value(dynamic input) => input?.toString() ?? '';

    // Keep the existing UI's field names so PatientDetailsScreen
    // and the patient cards do not need a redesign.
    return {
      'id': value(patient['p_id']),
      'name': value(patient['p_name']),
      'phone': value(patient['p_contact']),
      'gender': value(patient['p_gender']),
      'email': value(patient['p_email']),
      'address': value(patient['p_address']),
      'birthday': value(patient['p_birthday']),
      'civilStatus': value(patient['p_civilstatus']),
      'occupation': value(patient['p_occupation']),
      'registeredAt': value(patient['p_dateregistered']),
      // The current GET payload does not include last appointment date.
      // Medical fields are retained as JSON for the details screen.
      'medicalData': jsonEncode(medical),
    };
  }
}
