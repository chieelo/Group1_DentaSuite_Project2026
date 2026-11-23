
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/app_config.dart';

class PatientService {
  static const List<String> patientFields = [
    'p_id',
    'p_name',
    'p_age',
    'p_gender',
    'p_address',
    'p_contact',
    'p_birthday',
    'p_civilstatus',
    'p_email',
    'p_occupation',
    'p_dateregistered',
    'p_lastvisit',
    'p_nextvisit',
  ];

  static const List<String> medicalTextFields = [
    'medical_condition',
    'serious_illness_details',
    'hospitalization_details',
    'current_medications',
    'other_allergies',
  ];

  static const List<String> medicalBoolFields = [
    'is_in_good_health',
    'under_medical_treatment',
    'serious_illness_history',
    'hospitalized_before',
    'uses_tobacco',
    'allergy_local_anesthetic',
    'allergy_penicillin',
    'allergy_sulfa_drugs',
    'allergy_aspirin',
    'allergy_latex',
    'is_pregnant',
    'is_breastfeeding',
    'on_birth_control',
    'has_hypertension',
    'has_asthma',
    'has_diabetes',
    'has_std',
    'has_persistent_cough',
    'has_cancer',
    'has_heart_disease',
    'has_blood_disease',
    'has_lung_disease',
    'has_liver_disease',
  ];

  Future<List<Map<String, String>>> getPatients() async {
    final response = await http.get(
      Uri.parse(AppConfig.patientsUrl),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception(
        'Server error ${response.statusCode}: ${response.body}',
      );
    }

    final decoded = jsonDecode(response.body);

    if (decoded is! Map<String, dynamic>) {
      throw Exception('Invalid API response format.');
    }

    if (decoded['ok'] != true) {
      throw Exception(
        decoded['message']?.toString() ?? 'API request failed.',
      );
    }

    final patientsData = decoded['patients'];

    if (patientsData is! List) {
      throw Exception('The API response does not contain a patients list.');
    }

    return patientsData.map<Map<String, String>>((item) {
      if (item is! Map) {
        throw Exception('Invalid patient item.');
      }

      final patient = item['patient'] is Map
          ? Map<String, dynamic>.from(item['patient'])
          : <String, dynamic>{};

      final medical = item['medical'] is Map
          ? Map<String, dynamic>.from(item['medical'])
          : <String, dynamic>{};

      final result = <String, String>{};

      for (final field in patientFields) {
        result[field] = _string(patient[field]);
      }

      result['id'] = _string(patient['p_id']);
      result['name'] = _string(patient['p_name']);
      result['age'] = _string(patient['p_age']);
      result['gender'] = _string(patient['p_gender']);
      result['address'] = _string(patient['p_address']);
      result['phone'] = _string(patient['p_contact']);
      result['birthday'] = _string(patient['p_birthday']);
      result['civilstatus'] = _string(patient['p_civilstatus']);
      result['email'] = _string(patient['p_email']);
      result['occupation'] = _string(patient['p_occupation']);
      result['dateregistered'] = _string(patient['p_dateregistered']);
      result['lastvisit'] = _string(patient['p_lastvisit']);
      result['nextvisit'] = _string(patient['p_nextvisit']);

      for (final field in medicalTextFields) {
        result[field] = _string(medical[field]);
      }

      for (final field in medicalBoolFields) {
        result[field] = _string(medical[field]);
      }

      return result;
    }).toList();
  }

  String _string(dynamic value) {
    if (value == null) return '';

    if (value is bool) {
      return value ? 'Yes' : 'No';
    }

    if (value == 1 || value == '1') {
      return 'Yes';
    }

    if (value == 0 || value == '0') {
      return 'No';
    }

    return value.toString();
  }
}
