
import 'package:dentasuite/screens/add_patient_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'patient_details_screen.dart';
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

  Future<void> _addPatient() async {
    final newPatient = await Navigator.push<Map<String, String>>(
      context,
      MaterialPageRoute(
        builder: (_) => const AddPatientScreen(),
      ),
    );

    if (!mounted) return;

    if (newPatient != null) {
      _loadPatients();
    }
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
                  Expanded(
                    child: sectionTitle('Patient Directory'),
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
        ),
      ],
    );
  }
}
