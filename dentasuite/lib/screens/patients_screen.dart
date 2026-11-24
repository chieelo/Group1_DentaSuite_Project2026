import 'package:dentasuite/screens/add_patient_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'patient_details_screen.dart';
import 'edit_patient_screen.dart';
import '../service/patient_service.dart';
import '../widgets/shared_widgets.dart';

class PatientsScreen extends StatefulWidget {
  const PatientsScreen({super.key});

  @override
  State<PatientsScreen> createState() => _PatientsScreenState();
}

class _PatientsScreenState extends State<PatientsScreen> {
  final TextEditingController searchController = TextEditingController();

  final PatientService patientService = PatientService();

  static const List<String> _patientFilters = [
    'All Patients',
    'New Patients',
    'Archived Patients',
  ];

  static const int _newPatientDays = 30;

  String _selectedFilter = 'All Patients';

  late Future<List<Map<String, String>>> patientsFuture;

  @override
  void initState() {
    super.initState();
    patientsFuture = patientService.getPatients();
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

  DateTime? _parsePatientDate(String? rawValue) {
    final value = rawValue?.trim() ?? '';

    if (value.isEmpty) return null;

    final parsedIso = DateTime.tryParse(value);

    if (parsedIso != null) return parsedIso;

    final slashParts = value.split('/');

    if (slashParts.length == 3) {
      final month = int.tryParse(slashParts[0]);
      final day = int.tryParse(slashParts[1]);
      final year = int.tryParse(slashParts[2]);

      if (month != null && day != null && year != null) {
        return DateTime(year, month, day);
      }
    }

    final dashParts = value.split('-');

    if (dashParts.length == 3) {
      final first = int.tryParse(dashParts[0]);
      final second = int.tryParse(dashParts[1]);
      final third = int.tryParse(dashParts[2]);

      if (first != null && second != null && third != null) {
        if (dashParts[0].length == 4) {
          return DateTime(first, second, third);
        }

        return DateTime(third, second, first);
      }
    }

    return null;
  }

  bool _isNewPatient(Map<String, String> patient) {
    final registeredAt = _parsePatientDate(patient['dateregistered']);

    if (registeredAt == null) return false;

    final now = DateTime.now();

    final cutoff = now.subtract(const Duration(days: _newPatientDays));

    return !registeredAt.isBefore(cutoff) &&
        !registeredAt.isAfter(now.add(const Duration(days: 1)));
  }

  bool _isArchivedPatient(Map<String, String> patient) {
    final lastVisit = _parsePatientDate(patient['lastvisit']);

    if (lastVisit == null) return true;

    final cutoff = DateTime.now().subtract(const Duration(days: 365 * 2));

    return lastVisit.isBefore(cutoff);
  }

  List<Map<String, String>> _applyPatientFilters(
    List<Map<String, String>> patients,
  ) {
    switch (_selectedFilter) {
      case 'New Patients':
        return patients.where(_isNewPatient).toList();

      case 'Archived Patients':
        return patients.where(_isArchivedPatient).toList();

      case 'All Patients':
      default:
        return patients;
    }
  }

  Future<void> _addPatient() async {
    final newPatient = await Navigator.push<Map<String, String>>(
      context,
      MaterialPageRoute(builder: (_) => const AddPatientScreen()),
    );

    if (!mounted) return;

    if (newPatient != null) {
      _loadPatients();
    }
  }

  Future<void> _openPatientDetails(Map<String, String> patient) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => PatientDetailsScreen(patient: patient)),
    );

    if (!mounted) return;
    _loadPatients();
  }

  @override
  Widget build(BuildContext context) {
    final p = context.pal;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(child: sectionTitle('Patient Directory')),

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

              const SizedBox(height: 12),

              Align(
                alignment: Alignment.centerLeft,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: _patientFilters.map((filter) {
                      final selected = _selectedFilter == filter;

                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: FilterChip(
                          label: Text(
                            filter,
                            style: GoogleFonts.poppins(
                              fontSize: 11,
                              fontWeight: selected
                                  ? FontWeight.w600
                                  : FontWeight.w500,
                            ),
                          ),
                          selected: selected,
                          onSelected: (_) {
                            setState(() {
                              _selectedFilter = filter;
                            });
                          },
                          showCheckmark: false,
                          selectedColor: p.accentSoft,
                          backgroundColor: p.surface,
                          side: BorderSide(
                            color: selected ? p.accent : p.border,
                          ),
                          labelStyle: TextStyle(
                            color: selected ? p.accent : p.textMain,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ],
          ),
        ),

        Expanded(
          child: FutureBuilder<List<Map<String, String>>>(
            future: patientsFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
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
                          style: ts(context, 13, weight: FontWeight.w600),
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

              final patientsByFilter = _applyPatientFilters(patients);

              final query = searchController.text.toLowerCase();

              final filteredPatients = patientsByFilter.where((patient) {
                final name = (patient['name'] ?? '').toLowerCase();

                final id = (patient['id'] ?? '').toLowerCase();

                return name.contains(query) || id.contains(query);
              }).toList();

              if (filteredPatients.isEmpty) {
                final emptyText = _selectedFilter == 'All Patients'
                    ? 'No matching patients found.'
                    : 'No ${_selectedFilter.toLowerCase()} found.';

                return emptyMessage(emptyText);
              }

              return RefreshIndicator(
                onRefresh: () async {
                  final newFuture = patientService.getPatients();

                  setState(() {
                    patientsFuture = newFuture;
                  });

                  await newFuture;
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

                      onTap: () => _openPatientDetails(patient),

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

                                Text(phone, style: ts(context, 11, sub: true)),
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

                          Icon(Icons.chevron_right_rounded, color: p.textSub),
                        ],
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
