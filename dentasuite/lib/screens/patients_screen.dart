
import 'package:dentasuite/screens/add_patient_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'patient_details_screen.dart';
<<<<<<< HEAD
import '../service/patients_service.dart';
=======
import '../service/patient_service.dart';
>>>>>>> 868b1a19a975af7bb35714dbaebad48f23b9b066
import '../widgets/shared_widgets.dart';

class PatientsScreen extends StatefulWidget {
  const PatientsScreen({super.key});

  @override
  State<PatientsScreen> createState() => _PatientsScreenState();
}

class _PatientsScreenState extends State<PatientsScreen> {
  final TextEditingController searchController = TextEditingController();
<<<<<<< HEAD
  final PatientsService _patientsService = PatientsService();

  static const int _newPatientDays = 30;
  String _selectedFilter = 'All Patients';
  List<Map<String, String>> patients = [];
  bool _isLoading = true;
  String? _errorMessage;
=======
  final PatientService patientService = PatientService();

  late Future<List<Map<String, String>>> patientsFuture;
>>>>>>> 868b1a19a975af7bb35714dbaebad48f23b9b066

  @override
  void initState() {
    super.initState();
<<<<<<< HEAD
    _loadPatients();
  }

  DateTime? _patientDate(Map<String, String> patient, String key) {
    final value = patient[key];
    if (value == null || value.trim().isEmpty) return null;
    return DateTime.tryParse(value);
  }

  bool _isNewPatient(Map<String, String> patient) {
    final registeredAt = _patientDate(patient, 'registeredAt');
    if (registeredAt == null) return false;
    final age = DateTime.now().difference(registeredAt);
    return !age.isNegative && age.inDays <= _newPatientDays;
  }

  // Archived filtering is intentionally not guessed here:
  // the current GET response has no last-appointment date.
  bool _isArchivedPatient(Map<String, String> patient) => false;

  bool _matchesSelectedFilter(Map<String, String> patient) {
    switch (_selectedFilter) {
      case 'New Patients':
        return _isNewPatient(patient);
      case 'Archived Patients':
        return _isArchivedPatient(patient);
      default:
        return true;
    }
  }

  Future<void> _loadPatients() async {
    if (mounted) {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });
    }

    try {
      final result = await _patientsService.fetchPatients();
      if (!mounted) return;
      setState(() {
        patients = result;
        _isLoading = false;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _errorMessage = error.toString().replaceFirst('Exception: ', '');
        _isLoading = false;
      });
    }
=======
    patientsFuture = patientService.getPatients();
>>>>>>> 868b1a19a975af7bb35714dbaebad48f23b9b066
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void _loadPatients() {
    setState(() {
      patientsFuture = patientService.getPatients();
    });
  }

  Future<void> _addPatient() async {
    // The existing form currently returns local fields only.
    // POST integration requires the backend's confirmed request-body schema.
    final newPatient = await Navigator.push<Map<String, String>>(
      context,
      MaterialPageRoute(
        builder: (_) => const AddPatientScreen(),
      ),
    );

    if (!mounted) return;

    if (newPatient != null) {
<<<<<<< HEAD
      await _loadPatients();
=======
      _loadPatients();
>>>>>>> 868b1a19a975af7bb35714dbaebad48f23b9b066
    }
  }

  @override
  Widget build(BuildContext context) {
    final p = context.pal;
<<<<<<< HEAD
    final query = searchController.text.toLowerCase();

    final filteredPatients = patients.where((patient) {
      final matchesSearch =
          (patient['name'] ?? '').toLowerCase().contains(query) ||
          (patient['id'] ?? '').toLowerCase().contains(query);
      return matchesSearch && _matchesSelectedFilter(patient);
    }).toList();
=======
>>>>>>> 868b1a19a975af7bb35714dbaebad48f23b9b066

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Row(
                children: [
<<<<<<< HEAD
                  Expanded(child: sectionTitle('Patient Directory')),
                  IconButton(
                    tooltip: 'Refresh patients',
                    onPressed: _isLoading ? null : _loadPatients,
                    icon: const Icon(Icons.refresh),
=======
                  Expanded(
                    child: sectionTitle('Patient Directory'),
>>>>>>> 868b1a19a975af7bb35714dbaebad48f23b9b066
                  ),
                  ElevatedButton.icon(
                    onPressed: _addPatient,
                    icon: const Icon(Icons.add, size: 18),
                    label: Text(
                      'Add',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              Align(
                alignment: Alignment.centerLeft,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      'All Patients',
                      'New Patients',
                      'Archived Patients',
                    ].map((filter) {
                      final selected = _selectedFilter == filter;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: ChoiceChip(
                          label: Text(
                            filter,
                            style: GoogleFonts.poppins(
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                              color: selected ? p.onAccent : p.textMain,
                            ),
                          ),
                          selected: selected,
                          onSelected: (_) {
                            setState(() => _selectedFilter = filter);
                          },
                          selectedColor: p.accent,
                          backgroundColor: p.surface,
                          side: BorderSide(
                            color: selected ? p.accent : p.border,
                          ),
                          showCheckmark: false,
                          visualDensity: VisualDensity.compact,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 5,
                            vertical: 2,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: searchController,
                onChanged: (_) => setState(() {}),
                style: ts(context, 13),
                cursorColor: p.accent,
                decoration: InputDecoration(
                  hintText: 'Search patient name or ID...',
                  fillColor: p.surface,
                  prefixIcon: const Icon(Icons.search),
                ),
              ),
            ],
          ),
        ),
        Expanded(
<<<<<<< HEAD
          child: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _errorMessage != null
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              _errorMessage!,
                              textAlign: TextAlign.center,
                              style: ts(context, 12, sub: true),
                            ),
                            const SizedBox(height: 12),
                            ElevatedButton.icon(
                              onPressed: _loadPatients,
                              icon: const Icon(Icons.refresh),
                              label: const Text('Try again'),
                            ),
                          ],
                        ),
                      ),
                    )
                  : filteredPatients.isEmpty
                      ? emptyMessage(
                          _selectedFilter == 'Archived Patients'
                              ? 'Appointment history is not available yet.'
                              : 'No patients found in this category.',
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                          itemCount: filteredPatients.length,
                          itemBuilder: (context, index) {
                            final patient = filteredPatients[index];
                            final name = patient['name']?.isNotEmpty == true
                                ? patient['name']!
                                : 'Unnamed patient';

                            return appCard(
                              margin: const EdgeInsets.only(bottom: 12),
                              padding: const EdgeInsets.all(14),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        PatientDetailsScreen(patient: patient),
                                  ),
                                );
                              },
                              child: Row(
                                children: [
                                  gradientAvatar(name, size: 44),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          name,
                                          style: ts(
                                            context,
                                            13,
                                            weight: FontWeight.w600,
                                          ),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          patient['id'] ?? '',
                                          style: ts(context, 11, sub: true),
                                        ),
                                        Text(
                                          patient['phone'] ?? '',
                                          style: ts(context, 11, sub: true),
                                        ),
                                      ],
                                    ),
                                  ),
                                  if ((patient['gender'] ?? '').isNotEmpty)
                                    Padding(
                                      padding: const EdgeInsets.only(right: 6),
                                      child: statusChip(
                                        context,
                                        patient['gender']!,
                                        genderColor(patient['gender']!),
                                      ),
                                    ),
                                  Icon(
                                    Icons.chevron_right_rounded,
                                    color: p.textSub,
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
=======
          child: FutureBuilder<List<Map<String, String>>>(
            future: patientsFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (snapshot.hasError) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.error_outline,
                          size: 40,
                          color: Colors.red,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Unable to load patients.',
                          style: ts(
                            context,
                            13,
                            weight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          '${snapshot.error}',
                          textAlign: TextAlign.center,
                          style: ts(context, 11, sub: true),
                        ),
                        const SizedBox(height: 12),
                        ElevatedButton.icon(
                          onPressed: _loadPatients,
                          icon: const Icon(Icons.refresh),
                          label: const Text('Retry'),
                        ),
                      ],
                    ),
                  ),
                );
              }

              final patients = snapshot.data ?? [];

              final query = searchController.text.toLowerCase();

              final filteredPatients = patients.where((patient) {
                final name = (patient['name'] ?? '').toLowerCase();
                final id = (patient['id'] ?? '').toLowerCase();

                return name.contains(query) || id.contains(query);
              }).toList();

              if (filteredPatients.isEmpty) {
                return emptyMessage(
                  'No matching patients found.',
                );
              }

              return RefreshIndicator(
                onRefresh: () async {
                  _loadPatients();
                  await patientsFuture;
                },
                child: ListView.builder(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                  itemCount: filteredPatients.length,
                  itemBuilder: (context, index) {
                    final patient = filteredPatients[index];

                    final name = patient['name'] ?? 'Unknown Patient';
                    final id = patient['id'] ?? '';
                    final phone = patient['phone'] ?? '';
                    final gender = patient['gender'] ?? '';

                    return appCard(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(14),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => PatientDetailsScreen(
                              patient: patient,
                            ),
                          ),
                        );
                      },
                      child: Row(
                        children: [
                          gradientAvatar(name, size: 44),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  name,
                                  style: ts(
                                    context,
                                    13,
                                    weight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'Patient ID: $id',
                                  style: ts(context, 11, sub: true),
                                ),
                                Text(
                                  phone,
                                  style: ts(context, 11, sub: true),
                                ),
                              ],
                            ),
                          ),
                          if (gender.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(right: 6),
                              child: statusChip(
                                context,
                                gender,
                                genderColor(gender),
                              ),
                            ),
                          Icon(
                            Icons.chevron_right_rounded,
                            color: p.textSub,
                          ),
                        ],
                      ),
                    );
                  },
                ),
              );
            },
          ),
>>>>>>> 868b1a19a975af7bb35714dbaebad48f23b9b066
        ),
      ],
    );
  }
}
