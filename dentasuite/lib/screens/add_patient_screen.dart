import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

import '../widgets/shared_widgets.dart';

class AddPatientScreen extends StatefulWidget {
  const AddPatientScreen({super.key});

  @override
  State<AddPatientScreen> createState() => _AddPatientScreenState();
}

class _AddPatientScreenState extends State<AddPatientScreen> {
  static const String patientsEndpoint =
      'https://3c64tbzmtd.execute-api.ap-southeast-2.amazonaws.com/dev/patients';

  bool isSaving = false;

  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final addressController = TextEditingController();
  final contactController = TextEditingController();
  final emailController = TextEditingController();
  final occupationController = TextEditingController();
  final treatmentController = TextEditingController();
  final hospitalizationController = TextEditingController();
  final illnessController = TextEditingController();
  final medicationController = TextEditingController();
  final otherAllergyController = TextEditingController();

  String? gender;
  String? civilStatus;
  DateTime? birthdate;
  bool? goodHealth;
  bool? underTreatment;
  bool? hospitalized;
  bool? seriousIllness;
  bool? takingMedication;
  bool? usesTobacco;

  final List<String> allergies = [
    'Aspirin',
    'Local Anesthetic (e.g. Lidocaine)',
    'Latex',
    'Penicillin - Antibiotic',
    'Sulfa-Drugs',
    'Others',
  ];

  final List<String> illnesses = [
    'Hypertension',
    'Asthma',
    'Diabetes',
    'STD',
    'Persistent Cough',
    'Cancer',
    'Heart Disease',
    'Blood Disease',
    'Lung Disease',
    'Liver Disease',
  ];

  final List<String> selectedAllergies = [];
  final List<String> selectedIllnesses = [];

  bool breastfeeding = false;
  bool pregnant = false;
  bool birthControl = false;

  @override
  void dispose() {
    nameController.dispose();
    addressController.dispose();
    contactController.dispose();
    emailController.dispose();
    occupationController.dispose();
    treatmentController.dispose();
    hospitalizationController.dispose();
    illnessController.dispose();
    medicationController.dispose();
    otherAllergyController.dispose();

    super.dispose();
  }

  String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Full name is required.';
    }

    if (value.trim().length < 2) {
      return 'Name must contain at least 2 characters.';
    }

    if (!RegExp(r"^[a-zA-Z\s.'-]+$").hasMatch(value.trim())) {
      return 'Please enter a valid name.';
    }

    return null;
  }

  String? validateContact(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Contact number is required.';
    }

    if (!RegExp(r'^(09\d{9}|\+639\d{9})$').hasMatch(value.trim())) {
      return 'Enter a valid PH mobile number.';
    }

    return null;
  }

  String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null;
    }

    if (!RegExp(r'^[\w.+-]+@[\w-]+\.[a-zA-Z]{2,}$').hasMatch(value.trim())) {
      return 'Please enter a valid email address.';
    }

    return null;
  }

  String? validateRequired(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'This field is required.';
    }

    return null;
  }

  Future<void> selectBirthdate() async {
    final today = DateUtils.dateOnly(DateTime.now());
    final selected = await showDatePicker(
      context: context,
      initialDate: birthdate ?? DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: today,
    );

    if (selected != null) {
      setState(() {
        birthdate = selected;
      });
    }
  }

  String formatDate(DateTime? date) {
    if (date == null) return 'Select date';

    return '${date.month.toString().padLeft(2, '0')}/'
        '${date.day.toString().padLeft(2, '0')}/'
        '${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    final p = context.pal;
    return Scaffold(
      backgroundColor: p.bg,
      appBar: AppBar(
        backgroundColor: p.isDark ? p.surface : navy,
        foregroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          'New Patient Record',
          style: GoogleFonts.poppins(
            fontSize: 17,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _sectionHeader(Icons.person, 'PATIENT INFORMATION'),
              _sectionCard([
                _textField(
                  'Full Name',
                  nameController,
                  validator: validateName,
                ),
                _genderSelection(),
                _textField('Address', addressController),
                _textField(
                  'Contact No.',
                  contactController,
                  keyboardType: TextInputType.phone,
                  validator: validateContact,
                ),
                _dateField('Birthdate', birthdate, selectBirthdate),
                _dropdown(
                  'Civil Status',
                  civilStatus,
                  ['Single', 'Married', 'Widowed', 'Separated', 'Divorced'],
                  (value) {
                    setState(() => civilStatus = value);
                  },
                ),
                _textField(
                  'Email Address',
                  emailController,
                  keyboardType: TextInputType.emailAddress,
                  validator: validateEmail,
                ),
                _textField('Occupation', occupationController),
              ]),
              const SizedBox(height: 20),
              _sectionHeader(Icons.medical_services, 'MEDICAL RECORD'),
              _sectionCard([
                Text(
                  'Please answer the following questions honestly.',
                  style: GoogleFonts.poppins(
                    fontSize: 11,
                    color: p.textSub,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                const SizedBox(height: 15),
                _yesNoQuestion('Are you in good health?', goodHealth, (value) {
                  setState(() => goodHealth = value);
                }),
                _yesNoQuestion(
                  'Are you under medical treatment now?',
                  underTreatment,
                  (value) {
                    setState(() => underTreatment = value);
                  },
                ),
                if (underTreatment == true)
                  _textField(
                    'What is the condition being treated?',
                    treatmentController,
                    validator: validateRequired,
                  ),
                _yesNoQuestion(
                  'Have you ever been hospitalized?',
                  hospitalized,
                  (value) {
                    setState(() => hospitalized = value);
                  },
                ),
                if (hospitalized == true)
                  _textField(
                    'Please specify hospitalization details',
                    hospitalizationController,
                    validator: validateRequired,
                  ),
                _yesNoQuestion(
                  'Have you ever had serious illness or surgical operations?',
                  seriousIllness,
                  (value) {
                    setState(() => seriousIllness = value);
                  },
                ),
                if (seriousIllness == true)
                  _textField(
                    'What illness or operation?',
                    illnessController,
                    validator: validateRequired,
                  ),
                _yesNoQuestion(
                  'Are you taking any prescription or non-prescription medication?',
                  takingMedication,
                  (value) {
                    setState(() => takingMedication = value);
                  },
                ),
                if (takingMedication == true)
                  _textField(
                    'Please specify medication',
                    medicationController,
                    validator: validateRequired,
                  ),
                _yesNoQuestion('Do you use tobacco products?', usesTobacco, (
                  value,
                ) {
                  setState(() => usesTobacco = value);
                }),
                const Divider(height: 30),
                _subheading('Are you allergic to any of the following?'),
                const SizedBox(height: 8),
                _checkboxList(allergies, selectedAllergies),
                if (selectedAllergies.contains('Others'))
                  _textField(
                    'Please specify other allergies',
                    otherAllergyController,
                    validator: validateRequired,
                  ),
                if (gender == 'Female' || gender == 'Other') ...[
                  const Divider(height: 30),
                  _subheading('For Women:'),
                  _checkbox('Breastfeeding', breastfeeding, (value) {
                    setState(() {
                      breastfeeding = value!;
                    });
                  }),
                  _checkbox('Pregnant', pregnant, (value) {
                    setState(() {
                      pregnant = value!;
                    });
                  }),
                  _checkbox('On birth control pills', birthControl, (value) {
                    setState(() {
                      birthControl = value!;
                    });
                  }),
                ],
                const Divider(height: 30),
                _subheading('Past/Present Illness'),
                _text('Please check if present:', sub: true, size: 11),
                const SizedBox(height: 8),
                _checkboxList(illnesses, selectedIllnesses),
              ]),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: isSaving ? null : clearForm,
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 13),
                      ),
                      child: Text(
                        'Clear',
                        style: GoogleFonts.poppins(fontSize: 12),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: isSaving ? null : savePatient,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 13),
                      ),
                      child: isSaving
                          ? const SizedBox(
                              height: 16,
                              width: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : Text(
                              'Save Patient',
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  void clearForm() {
    FocusScope.of(context).unfocus();
    _formKey.currentState?.reset();

    nameController.clear();
    addressController.clear();
    contactController.clear();
    emailController.clear();
    occupationController.clear();
    treatmentController.clear();
    hospitalizationController.clear();
    illnessController.clear();
    medicationController.clear();
    otherAllergyController.clear();

    setState(() {
      gender = null;
      civilStatus = null;
      birthdate = null;
      goodHealth = null;
      underTreatment = null;
      hospitalized = null;
      seriousIllness = null;
      takingMedication = null;
      usesTobacco = null;
      selectedAllergies.clear();
      selectedIllnesses.clear();
      breastfeeding = false;
      pregnant = false;
      birthControl = false;
    });
  }

  Future<void> savePatient() async {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (gender == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please select a gender.')));
      return;
    }

    if (birthdate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select the patient birthdate.')),
      );
      return;
    }

    if (birthdate!.isAfter(DateUtils.dateOnly(DateTime.now()))) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Birthdate cannot be a future date.')),
      );
      return;
    }

    if (goodHealth == null ||
        underTreatment == null ||
        hospitalized == null ||
        seriousIllness == null ||
        takingMedication == null ||
        usesTobacco == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please answer all medical questions.')),
      );
      return;
    }

    final body = <String, dynamic>{
      'p_name': nameController.text.trim(),
      'p_gender': gender,
      'p_address': addressController.text.trim(),
      'p_contact': contactController.text.trim(),
      'p_birthday':
          '${birthdate!.year.toString().padLeft(4, '0')}-'
          '${birthdate!.month.toString().padLeft(2, '0')}-'
          '${birthdate!.day.toString().padLeft(2, '0')}',
      'p_civilstatus': civilStatus ?? '',
      'p_email': emailController.text.trim(),
      'p_occupation': occupationController.text.trim(),

      'medical_condition': underTreatment == true
          ? treatmentController.text.trim()
          : '',
      'serious_illness_details': seriousIllness == true
          ? illnessController.text.trim()
          : '',
      'hospitalization_details': hospitalized == true
          ? hospitalizationController.text.trim()
          : '',
      'current_medications': takingMedication == true
          ? medicationController.text.trim()
          : '',
      'other_allergies': selectedAllergies.contains('Others')
          ? otherAllergyController.text.trim()
          : '',

      'is_in_good_health': goodHealth,
      'under_medical_treatment': underTreatment,
      'serious_illness_history': seriousIllness,
      'hospitalized_before': hospitalized,
      'uses_tobacco': usesTobacco,

      'allergy_local_anesthetic': selectedAllergies.contains(
        'Local Anesthetic (e.g. Lidocaine)',
      ),
      'allergy_penicillin': selectedAllergies.contains(
        'Penicillin - Antibiotic',
      ),
      'allergy_sulfa_drugs': selectedAllergies.contains('Sulfa-Drugs'),
      'allergy_aspirin': selectedAllergies.contains('Aspirin'),
      'allergy_latex': selectedAllergies.contains('Latex'),

      'is_pregnant': gender == 'Male' ? false : pregnant,
      'is_breastfeeding': gender == 'Male' ? false : breastfeeding,
      'on_birth_control': gender == 'Male' ? false : birthControl,

      'has_hypertension': selectedIllnesses.contains('Hypertension'),
      'has_asthma': selectedIllnesses.contains('Asthma'),
      'has_diabetes': selectedIllnesses.contains('Diabetes'),
      'has_std': selectedIllnesses.contains('STD'),
      'has_persistent_cough': selectedIllnesses.contains('Persistent Cough'),
      'has_cancer': selectedIllnesses.contains('Cancer'),
      'has_heart_disease': selectedIllnesses.contains('Heart Disease'),
      'has_blood_disease': selectedIllnesses.contains('Blood Disease'),
      'has_lung_disease': selectedIllnesses.contains('Lung Disease'),
      'has_liver_disease': selectedIllnesses.contains('Liver Disease'),
    };

    setState(() {
      isSaving = true;
    });

    try {
      final response = await http.post(
        Uri.parse(patientsEndpoint),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode(body),
      );

      if (!mounted) return;

      if (response.statusCode >= 200 && response.statusCode < 300) {
        String patientId = '';

        try {
          final decoded = jsonDecode(response.body);
          if (decoded is Map<String, dynamic>) {
            final patient = decoded['patient'];
            final data = decoded['data'];

            final id =
                decoded['p_id'] ??
                (patient is Map ? patient['p_id'] : null) ??
                (data is Map ? data['p_id'] : null);

            if (id != null) {
              patientId = id.toString();
            }
          }
        } catch (_) {}

        Navigator.pop(context, {
          'name': nameController.text.trim(),
          'id': patientId,
          'phone': contactController.text.trim(),
          'gender': gender!,
          'address': addressController.text.trim(),
          'email': emailController.text.trim(),
        });
      } else {
        String errorMessage = 'Unable to save patient. Please try again.';

        try {
          final decoded = jsonDecode(response.body);
          if (decoded is Map<String, dynamic>) {
            errorMessage =
                (decoded['message'] ?? decoded['error'] ?? errorMessage)
                    .toString();
          }
        } catch (_) {}

        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(errorMessage)));
      }
    } catch (error) {
      if (!mounted) return;

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Connection error: $error')));
    } finally {
      if (mounted) {
        setState(() {
          isSaving = false;
        });
      }
    }
  }

  Widget _sectionHeader(IconData icon, String title) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 13),
      decoration: BoxDecoration(
        gradient: heroGradient,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.white, size: 21),
          const SizedBox(width: 10),
          Text(
            title,
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionCard(List<Widget> children) {
    return appCard(
      margin: const EdgeInsets.only(top: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: children,
      ),
    );
  }

  Widget _genderSelection() {
    final p = context.pal;

    return FormField<String>(
      validator: (value) {
        if (gender == null) {
          return 'Please select a gender.';
        }
        return null;
      },

      builder: (field) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 13),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _subheading('Gender'),
              Row(
                children: ['Male', 'Female', 'Other'].map((option) {
                  return Expanded(
                    child: RadioListTile<String>(
                      value: option,
                      groupValue: gender,
                      onChanged: (value) {
                        setState(() {
                          gender = value;
                        });

                        field.didChange(value);
                      },
                      contentPadding: EdgeInsets.zero,
                      dense: true,
                      activeColor: p.accent,
                      title: _text(option, size: 11),
                    ),
                  );
                }).toList(),
              ),

              if (field.hasError)
                Padding(
                  padding: const EdgeInsets.only(left: 12),
                  child: Text(
                    field.errorText!,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                      fontSize: 11,
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _textField(
    String label,
    TextEditingController controller, {
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    final p = context.pal;
    return Padding(
      padding: const EdgeInsets.only(bottom: 13),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _subheading(label),
          const SizedBox(height: 6),
          TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            validator: validator,
            cursorColor: p.accent,
            style: ts(context, 12),
            decoration: InputDecoration(
              hintText: 'Enter $label',
              hintStyle: ts(context, 11, sub: true),
            ),
          ),
        ],
      ),
    );
  }

  Widget _dropdown(
    String label,
    String? value,
    List<String> options,
    ValueChanged<String?> onChanged,
  ) {
    final p = context.pal;

    return Padding(
      padding: const EdgeInsets.only(bottom: 13),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _subheading(label),
          const SizedBox(height: 6),
          DropdownButtonFormField<String>(
            initialValue: value,
            isExpanded: true,
            dropdownColor: p.surface,
            style: ts(context, 12),
            icon: Icon(Icons.arrow_drop_down_rounded, color: p.textSub),
            hint: Text('Select $label', style: ts(context, 11, sub: true)),
            items: options.map((option) {
              return DropdownMenuItem(
                value: option,
                child: Text(option, style: ts(context, 12)),
              );
            }).toList(),
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  Widget _dateField(String label, DateTime? date, VoidCallback onTap) {
    final p = context.pal;
    return Padding(
      padding: const EdgeInsets.only(bottom: 13),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _subheading(label),
          const SizedBox(height: 6),
          InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
              decoration: BoxDecoration(
                color: p.surfaceAlt,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: p.border),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      formatDate(date),
                      style: ts(context, 12, sub: date == null),
                    ),
                  ),
                  Icon(Icons.calendar_month, size: 17, color: p.textSub),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _yesNoQuestion(
    String question,
    bool? value,
    ValueChanged<bool?> onChanged,
  ) {
    final p = context.pal;
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _subheading(question),
          Row(
            children: [
              Expanded(
                child: RadioListTile<bool>(
                  value: true,
                  groupValue: value,
                  onChanged: onChanged,
                  contentPadding: EdgeInsets.zero,
                  dense: true,
                  activeColor: p.accent,
                  title: _text('Yes', size: 11),
                ),
              ),

              Expanded(
                child: RadioListTile<bool>(
                  value: false,
                  groupValue: value,
                  onChanged: onChanged,
                  contentPadding: EdgeInsets.zero,
                  dense: true,
                  activeColor: p.accent,
                  title: _text('No', size: 11),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _checkboxList(List<String> options, List<String> selected) {
    return Wrap(
      spacing: 12,
      runSpacing: 2,
      children: options.map((option) {
        return SizedBox(
          width: 210,

          child: _checkbox(option, selected.contains(option), (checked) {
            setState(() {
              if (checked == true) {
                selected.add(option);
              } else {
                selected.remove(option);
              }
            });
          }),
        );
      }).toList(),
    );
  }

  Widget _checkbox(String label, bool value, ValueChanged<bool?> onChanged) {
    final p = context.pal;

    return CheckboxListTile(
      value: value,
      onChanged: onChanged,
      contentPadding: EdgeInsets.zero,
      dense: true,
      activeColor: p.accent,
      checkColor: p.onAccent,
      controlAffinity: ListTileControlAffinity.leading,
      title: _text(label, size: 11),
    );
  }

  Widget _subheading(String label) {
    return _text(label, size: 11, weight: FontWeight.w600);
  }

  Widget _text(
    String value, {
    double size = 12,
    bool sub = false,
    FontWeight weight = FontWeight.w400,
  }) {
    return Text(
      value,
      style: ts(context, size, weight: weight, sub: sub),
    );
  }
}
