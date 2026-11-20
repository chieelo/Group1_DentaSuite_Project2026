import 'package:dentasuite/screens/add_patient_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'patient_details_screen.dart';
import '../widgets/shared_widgets.dart';

class PatientsScreen extends StatefulWidget {
  const PatientsScreen({super.key});

  @override
  State<PatientsScreen> createState() => _PatientsScreenState();
}

class _PatientsScreenState extends State<PatientsScreen> {
  final TextEditingController searchController = TextEditingController();

  final List<Map<String, String>> patients = [
    {
      'name': 'Maria Santos',
      'id': 'PAT-0001',
      'phone': '09171234567',
      'gender': 'Female',
    },
    {
      'name': 'Juan Dela Cruz',
      'id': 'PAT-0002',
      'phone': '09181234567',
      'gender': 'Male',
    },
    {
      'name': 'Ana Reyes',
      'id': 'PAT-0003',
      'phone': '09191234567',
      'gender': 'Female',
    },
    {
      'name': 'Pedro Garcia',
      'id': 'PAT-0004',
      'phone': '09201234567',
      'gender': 'Male',
    },
  ];

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  Future<void> _addPatient() async {
    final newPatient = await Navigator.push<Map<String, String>>(
      context,
      MaterialPageRoute(builder: (_) => const AddPatientScreen()),
    );

    if (newPatient != null) {
      setState(() {
        newPatient['id'] =
            'PAT-${(patients.length + 1).toString().padLeft(4, '0')}';
        patients.add(newPatient);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final p = context.pal;
    final query = searchController.text.toLowerCase();

    final filteredPatients = patients.where((patient) {
      return patient['name']!.toLowerCase().contains(query) ||
          patient['id']!.toLowerCase().contains(query);
    }).toList();

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
            ],
          ),
        ),
        Expanded(
          child: filteredPatients.isEmpty
              ? emptyMessage('No matching patients found.')
              : ListView.builder(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                  itemCount: filteredPatients.length,
                  itemBuilder: (context, index) {
                    final patient = filteredPatients[index];

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
                          gradientAvatar(patient['name']!, size: 44),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  patient['name']!,
                                  style: ts(context, 13,
                                      weight: FontWeight.w600),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  patient['id']!,
                                  style: ts(context, 11, sub: true),
                                ),
                                Text(
                                  patient['phone']!,
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
                          Icon(Icons.chevron_right_rounded,
                              color: p.textSub),
                        ],
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
}