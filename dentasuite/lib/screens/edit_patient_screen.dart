import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../service/patient_service.dart';
import '../widgets/shared_widgets.dart';

class EditPatientScreen extends StatefulWidget {
  final Map<String, String> patient;

  const EditPatientScreen({super.key, required this.patient});

  @override
  State<EditPatientScreen> createState() => _EditPatientScreenState();
}

class _EditPatientScreenState extends State<EditPatientScreen> {
  final _formKey = GlobalKey<FormState>();
  final PatientService _patientService = PatientService();

  late final TextEditingController nameController;
  late final TextEditingController addressController;
  late final TextEditingController contactController;
  late final TextEditingController emailController;
  late final TextEditingController occupationController;

  late final TextEditingController treatmentController;
  late final TextEditingController illnessController;
  late final TextEditingController hospitalizationController;
  late final TextEditingController medicationController;
  late final TextEditingController otherAllergyController;

  late String? gender;
  late String? civilStatus;

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

  final List<String> selectedAllergies = [];
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

  final List<String> selectedIllnesses = [];

  bool breastfeeding = false;
  bool pregnant = false;
  bool birthControl = false;

  bool _isSaving = false;

  static const List<String> civilStatuses = [
    'Single',
    'Married',
    'Widowed',
    'Separated',
    'Divorced',
  ];

  @override
  void initState() {
    super.initState();

    final patient = widget.patient;

    nameController = TextEditingController(text: _getValue('name', 'p_name'));

    addressController = TextEditingController(
      text: _getValue('address', 'p_address'),
    );

    contactController = TextEditingController(
      text: _getValue('phone', 'p_contact'),
    );

    emailController = TextEditingController(
      text: _getValue('email', 'p_email'),
    );

    occupationController = TextEditingController(
      text: _getValue('occupation', 'p_occupation'),
    );

    gender = _getValue('gender', 'p_gender');

    final savedCivilStatus = _getValue('civilstatus', 'p_civilstatus');

    civilStatus = savedCivilStatus.isEmpty ? null : savedCivilStatus;

    final birthday = _getValue('birthday', 'p_birthday');

    if (birthday.isNotEmpty) {
      birthdate = DateTime.tryParse(birthday);
    }

    treatmentController = TextEditingController(
      text: patient['medical_condition'] ?? '',
    );

    illnessController = TextEditingController(
      text: patient['serious_illness_details'] ?? '',
    );

    hospitalizationController = TextEditingController(
      text: patient['hospitalization_details'] ?? '',
    );

    medicationController = TextEditingController(
      text: patient['current_medications'] ?? '',
    );

    otherAllergyController = TextEditingController(
      text: patient['other_allergies'] ?? '',
    );

    goodHealth = _readBool('is_in_good_health');

    underTreatment = _readBool('under_medical_treatment');

    hospitalized = _readBool('hospitalized_before');

    seriousIllness = _readBool('serious_illness_history');

    usesTobacco = _readBool('uses_tobacco');

    takingMedication = (patient['current_medications'] ?? '').trim().isNotEmpty;

    _loadAllergies();

    _loadIllnesses();

    breastfeeding = _readBool('is_breastfeeding') ?? false;
    pregnant = _readBool('is_pregnant') ?? false;
    birthControl = _readBool('on_birth_control') ?? false;
  }

  String _getValue(String displayKey, String databaseKey) {
    return (widget.patient[displayKey] ?? widget.patient[databaseKey] ?? '')
        .trim();
  }

  bool? _readBool(String key) {
    final value = widget.patient[key]?.trim().toLowerCase();

    if (value == null || value.isEmpty) return null;

    if (value == 'yes' || value == 'true' || value == '1') {
      return true;
    }

    if (value == 'no' || value == 'false' || value == '0') {
      return false;
    }

    return null;
  }

  bool _isChecked(String key) {
    return _readBool(key) ?? false;
  }

  void _loadAllergies() {
    if (_isChecked('allergy_aspirin')) {
      selectedAllergies.add('Aspirin');
    }

    if (_isChecked('allergy_local_anesthetic')) {
      selectedAllergies.add('Local Anesthetic (e.g. Lidocaine)');
    }

    if (_isChecked('allergy_latex')) {
      selectedAllergies.add('Latex');
    }

    if (_isChecked('allergy_penicillin')) {
      selectedAllergies.add('Penicillin - Antibiotic');
    }

    if (_isChecked('allergy_sulfa_drugs')) {
      selectedAllergies.add('Sulfa-Drugs');
    }

    if ((widget.patient['other_allergies'] ?? '').trim().isNotEmpty) {
      selectedAllergies.add('Others');
    }
  }

  void _loadIllnesses() {
    const illnessMap = {
      'Hypertension': 'has_hypertension',
      'Asthma': 'has_asthma',
      'Diabetes': 'has_diabetes',
      'STD': 'has_std',
      'Persistent Cough': 'has_persistent_cough',
      'Cancer': 'has_cancer',
      'Heart Disease': 'has_heart_disease',
      'Blood Disease': 'has_blood_disease',
      'Lung Disease': 'has_lung_disease',
      'Liver Disease': 'has_liver_disease',
    };

    illnessMap.forEach((label, key) {
      if (_isChecked(key)) {
        selectedIllnesses.add(label);
      }
    });
  }

  @override
  void dispose() {
    nameController.dispose();
    addressController.dispose();
    contactController.dispose();
    emailController.dispose();
    occupationController.dispose();

    treatmentController.dispose();
    illnessController.dispose();
    hospitalizationController.dispose();
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

  String formatDate(DateTime? date) {
    if (date == null) return 'Not provided';

    return '${date.year}-'
        '${date.month.toString().padLeft(2, '0')}-'
        '${date.day.toString().padLeft(2, '0')}';
  }

  Future<void> _confirmAndSave() async {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) {
      return;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            'Confirm Changes',
            style: GoogleFonts.poppins(
              fontSize: 17,
              fontWeight: FontWeight.w700,
            ),
          ),
          content: Text(
            'Are you sure you want to save these changes?',
            style: GoogleFonts.poppins(fontSize: 13),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext, false);
              },
              child: Text(
                'No',
                style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(dialogContext, true);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: teal,
                foregroundColor: Colors.white,
              ),
              child: Text(
                'Yes',
                style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        );
      },
    );

    if (confirmed == true && mounted) {
      await _saveChanges();
    }
  }

  Future<void> _saveChanges() async {
    final patientId = (widget.patient['id'] ?? widget.patient['p_id'] ?? '')
        .trim();

    if (patientId.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Patient ID is missing.')));
      return;
    }

    setState(() {
      _isSaving = true;
    });

    final requestBody = <String, dynamic>{
      'p_name': nameController.text.trim(),
      'p_address': addressController.text.trim(),
      'p_contact': contactController.text.trim(),
      'p_civilstatus': civilStatus,
      'p_email': emailController.text.trim(),
      'p_occupation': occupationController.text.trim(),
      'medical_condition': treatmentController.text.trim(),
      'serious_illness_details': illnessController.text.trim(),
      'hospitalization_details': hospitalizationController.text.trim(),
      'current_medications': medicationController.text.trim(),
      'other_allergies': otherAllergyController.text.trim(),
      'is_in_good_health': goodHealth ?? false,
      'under_medical_treatment': underTreatment ?? false,
      'hospitalized_before': hospitalized ?? false,
      'serious_illness_history': seriousIllness ?? false,
      'uses_tobacco': usesTobacco ?? false,
      'allergy_aspirin': selectedAllergies.contains('Aspirin'),

      'allergy_local_anesthetic': selectedAllergies.contains(
        'Local Anesthetic (e.g. Lidocaine)',
      ),

      'allergy_latex': selectedAllergies.contains('Latex'),

      'allergy_penicillin': selectedAllergies.contains(
        'Penicillin - Antibiotic',
      ),

      'allergy_sulfa_drugs': selectedAllergies.contains('Sulfa-Drugs'),
      'is_breastfeeding': breastfeeding,
      'is_pregnant': pregnant,
      'on_birth_control': birthControl,
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

    try {
      await _patientService.updatePatient(patientId, requestBody);

      final updatedPatient = Map<String, String>.from(widget.patient);

      updatedPatient['name'] = nameController.text.trim();
      updatedPatient['p_name'] = nameController.text.trim();

      updatedPatient['address'] = addressController.text.trim();
      updatedPatient['p_address'] = addressController.text.trim();

      updatedPatient['phone'] = contactController.text.trim();
      updatedPatient['p_contact'] = contactController.text.trim();

      updatedPatient['civilstatus'] = civilStatus ?? '';
      updatedPatient['p_civilstatus'] = civilStatus ?? '';

      updatedPatient['email'] = emailController.text.trim();
      updatedPatient['p_email'] = emailController.text.trim();

      updatedPatient['occupation'] = occupationController.text.trim();
      updatedPatient['p_occupation'] = occupationController.text.trim();

      requestBody.forEach((key, value) {
        updatedPatient[key] = value is bool
            ? (value ? 'Yes' : 'No')
            : value.toString();
      });

      if (!mounted) return;

      Navigator.pop(context, updatedPatient);
    } catch (error) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Unable to save changes: $error'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
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
          'Edit Patient Record',
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

                _readOnlyField('Gender', gender ?? 'Not provided'),

                _textField('Address', addressController),

                _textField(
                  'Contact No.',
                  contactController,
                  keyboardType: TextInputType.phone,
                  validator: validateContact,
                ),

                _readOnlyField('Birthdate', formatDate(birthdate)),

                _dropdown('Civil Status', civilStatus, civilStatuses, (value) {
                  setState(() {
                    civilStatus = value;
                  });
                }),

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

                _subheading('General Health'),

                const SizedBox(height: 8),

                _yesNoQuestion('Are you in good health?', goodHealth, (value) {
                  setState(() {
                    goodHealth = value;
                  });
                }),

                _yesNoQuestion(
                  'Are you under medical treatment now?',
                  underTreatment,
                  (value) {
                    setState(() {
                      underTreatment = value;
                    });
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
                    setState(() {
                      hospitalized = value;
                    });
                  },
                ),

                if (hospitalized == true)
                  _textField(
                    'Hospitalization Details',
                    hospitalizationController,
                  ),

                _yesNoQuestion(
                  'Have you ever had serious illness or surgical operations?',
                  seriousIllness,
                  (value) {
                    setState(() {
                      seriousIllness = value;
                    });
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
                    setState(() {
                      takingMedication = value;

                      if (value == false) {
                        medicationController.clear();
                      }
                    });
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
                  setState(() {
                    usesTobacco = value;
                  });
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
                      breastfeeding = value ?? false;
                    });
                  }),

                  _checkbox('Pregnant', pregnant, (value) {
                    setState(() {
                      pregnant = value ?? false;
                    });
                  }),

                  _checkbox('On birth control pills', birthControl, (value) {
                    setState(() {
                      birthControl = value ?? false;
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
                      onPressed: _isSaving
                          ? null
                          : () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 13),
                      ),
                      child: Text(
                        'Cancel',
                        style: GoogleFonts.poppins(fontSize: 12),
                      ),
                    ),
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child: ElevatedButton(
                      onPressed: _isSaving ? null : _confirmAndSave,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: teal,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 13),
                      ),
                      child: _isSaving
                          ? const SizedBox(
                              height: 17,
                              width: 17,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : Text(
                              'Save Changes',
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

  Widget _readOnlyField(String label, String value) {
    final p = context.pal;

    return Padding(
      padding: const EdgeInsets.only(bottom: 13),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _subheading(label),

          const SizedBox(height: 6),

          TextFormField(
            initialValue: value,
            readOnly: true,
            style: ts(context, 12, sub: true),
            decoration: InputDecoration(
              filled: true,
              fillColor: p.surfaceAlt,
              suffixIcon: Icon(Icons.lock_outline, size: 17, color: p.textSub),
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
    final availableOptions =
        value != null && value.isNotEmpty && !options.contains(value)
        ? [...options, value]
        : options;

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
            items: availableOptions.map((option) {
              return DropdownMenuItem<String>(
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
                if (!selected.contains(option)) {
                  selected.add(option);
                }
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
