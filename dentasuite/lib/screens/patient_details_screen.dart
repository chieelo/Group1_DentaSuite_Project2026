import 'package:dentasuite/screens/tooth_chart_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'edit_patient_screen.dart';

class PatientDetailsScreen extends StatefulWidget {
  final Map<String, String> patient;

  const PatientDetailsScreen({super.key, required this.patient});

  @override
  State<PatientDetailsScreen> createState() => _PatientDetailsScreenState();
}

class _PatientDetailsScreenState extends State<PatientDetailsScreen> {
  late Map<String, String> patient;

  @override
  void initState() {
    super.initState();

    patient = Map<String, String>.from(widget.patient);
  }

  String _value(String key) {
    final value = patient[key]?.trim() ?? '';
    return value.isEmpty ? 'Not provided' : value;
  }

  bool _isYes(String key) {
    final value = patient[key]?.trim().toLowerCase() ?? '';
    return value == 'yes' || value == '1' || value == 'true';
  }

  Future<void> _editPatient() async {
    final updatedPatient = await Navigator.push<Map<String, String>>(
      context,
      MaterialPageRoute(builder: (_) => EditPatientScreen(patient: patient)),
    );

    if (!mounted || updatedPatient == null) return;

    setState(() {
      patient = updatedPatient;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Patient information updated successfully.'),
        backgroundColor: Colors.green,
      ),
    );
  }

  Widget _detailsContent({
    required BuildContext context,
    required Widget child,
  }) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: child,
    );
  }

  Widget _info(
    BuildContext context,
    String label,
    String value, {
    IconData? icon,
  }) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 13),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: colors.outlineVariant.withOpacity(0.5)),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 19, color: colors.primary),
            const SizedBox(width: 12),
          ],
          Expanded(
            flex: 4,
            child: Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: colors.onSurfaceVariant,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: 6,
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: colors.onSurface,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 22, bottom: 8),
      child: Text(
        title,
        style: GoogleFonts.poppins(
          fontSize: 14,
          fontWeight: FontWeight.w700,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }

  Widget _basicInformationHeader(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.only(top: 22, bottom: 12),
      child: Row(
        children: [
          Expanded(
            child: Text(
              'Basic Information',
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: colors.primary,
              ),
            ),
          ),

          ElevatedButton.icon(
            onPressed: _editPatient,
            icon: const Icon(Icons.edit_rounded, size: 18, color: Colors.white),
            label: Text(
              'Edit Patient',
              style: GoogleFonts.poppins(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF126D75),
              foregroundColor: Colors.white,
              elevation: 2,
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 13),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _medicalSection(
    BuildContext context,
    String title,
    List<MapEntry<String, String>> items,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle(context, title),
        ...items.map((item) => _info(context, item.key, _value(item.value))),
      ],
    );
  }

  Widget _yesNoIndicator(BuildContext context, String label, String key) {
    final answer = _value(key);
    final isYes = _isYes(key);
    final isProvided = answer != 'Not provided';
    final colors = Theme.of(context).colorScheme;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: colors.surfaceContainerHighest.withOpacity(0.45),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: colors.onSurface,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
            decoration: BoxDecoration(
              color: !isProvided
                  ? colors.surfaceContainerHighest
                  : isYes
                  ? Colors.red.withOpacity(0.12)
                  : Colors.green.withOpacity(0.12),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              answer,
              style: GoogleFonts.poppins(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: !isProvided
                    ? colors.onSurfaceVariant
                    : isYes
                    ? Colors.red
                    : Colors.green,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _personalInfo(BuildContext context) {
    return _detailsContent(
      context: context,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _basicInformationHeader(context),
          _info(context, 'Patient ID', _value('p_id')),
          _info(context, 'Full Name', _value('name')),
          _info(context, 'Age', _value('age')),
          _info(context, 'Gender', _value('gender')),
          _info(context, 'Birthday', _value('birthday')),
          _info(context, 'Civil Status', _value('civilstatus')),

          _sectionTitle(context, 'Contact Information'),
          _info(context, 'Contact Number', _value('phone')),
          _info(context, 'Email Address', _value('email')),
          _info(context, 'Address', _value('address')),

          _sectionTitle(context, 'Other Information'),
          _info(context, 'Occupation', _value('occupation')),
          _info(context, 'Date Registered', _value('dateregistered')),
          _info(context, 'Last Visit', _value('lastvisit')),
          _info(context, 'Next Visit', _value('nextvisit')),
        ],
      ),
    );
  }

  Widget _medicalHistory(BuildContext context) {
    return _detailsContent(
      context: context,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Medical History',
            style: GoogleFonts.poppins(
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            'Patient-provided health information and medical conditions.',
            style: GoogleFonts.poppins(
              fontSize: 11,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),

          _sectionTitle(context, 'General Health'),

          _yesNoIndicator(
            context,
            'Is the patient in good health?',
            'is_in_good_health',
          ),
          _yesNoIndicator(
            context,
            'Currently under medical treatment?',
            'under_medical_treatment',
          ),
          _info(context, 'Medical Condition', _value('medical_condition')),
          _yesNoIndicator(
            context,
            'History of serious illness?',
            'serious_illness_history',
          ),
          _info(
            context,
            'Serious Illness Details',
            _value('serious_illness_details'),
          ),
          _yesNoIndicator(
            context,
            'Hospitalized before?',
            'hospitalized_before',
          ),
          _info(
            context,
            'Hospitalization Details',
            _value('hospitalization_details'),
          ),
          _info(context, 'Current Medications', _value('current_medications')),
          _yesNoIndicator(context, 'Uses tobacco?', 'uses_tobacco'),

          _sectionTitle(context, 'Allergies'),

          _yesNoIndicator(
            context,
            'Local Anesthetic',
            'allergy_local_anesthetic',
          ),
          _yesNoIndicator(context, 'Penicillin', 'allergy_penicillin'),
          _yesNoIndicator(context, 'Sulfa Drugs', 'allergy_sulfa_drugs'),
          _yesNoIndicator(context, 'Aspirin', 'allergy_aspirin'),
          _yesNoIndicator(context, 'Latex', 'allergy_latex'),
          _info(context, 'Other Allergies', _value('other_allergies')),

          _sectionTitle(context, 'Women\'s Health'),

          _yesNoIndicator(context, 'Currently pregnant?', 'is_pregnant'),
          _yesNoIndicator(
            context,
            'Currently breastfeeding?',
            'is_breastfeeding',
          ),
          _yesNoIndicator(context, 'Using birth control?', 'on_birth_control'),

          _sectionTitle(context, 'Medical Conditions'),

          _yesNoIndicator(context, 'Hypertension', 'has_hypertension'),
          _yesNoIndicator(context, 'Asthma', 'has_asthma'),
          _yesNoIndicator(context, 'Diabetes', 'has_diabetes'),
          _yesNoIndicator(context, 'Sexually Transmitted Disease', 'has_std'),
          _yesNoIndicator(context, 'Persistent Cough', 'has_persistent_cough'),
          _yesNoIndicator(context, 'Cancer', 'has_cancer'),
          _yesNoIndicator(context, 'Heart Disease', 'has_heart_disease'),
          _yesNoIndicator(context, 'Blood Disease', 'has_blood_disease'),
          _yesNoIndicator(context, 'Lung Disease', 'has_lung_disease'),
          _yesNoIndicator(context, 'Liver Disease', 'has_liver_disease'),
        ],
      ),
    );
  }

  Widget _dentalChart(BuildContext context) {
    return const ToothChartScreen();
  }

  Widget _treatmentHistory(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.medical_services_outlined,
              size: 55,
              color: colors.onSurfaceVariant.withOpacity(0.5),
            ),
            const SizedBox(height: 14),
            Text(
              'No treatments recorded yet',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: colors.onSurface,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              'Treatment records will appear here once they are available.',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 11,
                color: colors.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Patient Details',
            style: GoogleFonts.poppins(
              fontSize: 17,
              fontWeight: FontWeight.w700,
            ),
          ),
          bottom: TabBar(
            isScrollable: true,
            tabAlignment: TabAlignment.start,
            labelColor: colors.primary,
            unselectedLabelColor: colors.onSurfaceVariant,
            indicatorColor: colors.primary,
            labelStyle: GoogleFonts.poppins(
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
            unselectedLabelStyle: GoogleFonts.poppins(
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
            tabs: const [
              Tab(text: 'Personal Info'),
              Tab(text: 'Medical History'),
              Tab(text: 'Dental Chart'),
              Tab(text: 'Treatment History'),
            ],
          ),
        ),
        body: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: colors.primaryContainer.withOpacity(0.35),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: colors.primary.withOpacity(0.12),
                    child: Icon(Icons.person, size: 30, color: colors.primary),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _value('name'),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.poppins(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: colors.onSurface,
                          ),
                        ),
                        const SizedBox(height: 3),

                        RichText(
                          text: TextSpan(
                            style: GoogleFonts.poppins(
                              fontSize: 11,
                              color: colors.onSurfaceVariant,
                            ),
                            children: [
                              const TextSpan(
                                text: 'Patient ID: ',
                                style: TextStyle(fontWeight: FontWeight.w700),
                              ),
                              TextSpan(
                                text: _value('p_id'),
                                style: const TextStyle(
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  _personalInfo(context),
                  _medicalHistory(context),
                  _dentalChart(context),
                  _treatmentHistory(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
