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

  @override
  Widget build(BuildContext context) {
    final filteredPatients = patients.where((patient) {
      final query = searchController.text.toLowerCase();

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
                  Expanded(
                    child: Text(
                      'Patient Directory',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w700,
                        fontSize: 17,
                        color: navy,
                      ),
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () async {
                      final newPatient =
                          await Navigator.push<Map<String, String>>(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const AddPatientScreen(),
                            ),
                          );

                      if (newPatient != null) {
                        setState(() {
                          newPatient['id'] =
                              'PAT-${(patients.length + 1).toString().padLeft(4, '0')}';
                          patients.add(newPatient);
                        });
                      }
                    },
                    icon: const Icon(Icons.add, size: 18),
                    label: Text(
                      'Add',
                      style: GoogleFonts.poppins(fontSize: 12),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: navy,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 15),

              TextField(
                controller: searchController,
                onChanged: (_) => setState(() {}),
                decoration: InputDecoration(
                  hintText: 'Search patient name or ID...',
                  hintStyle: GoogleFonts.poppins(fontSize: 12),
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ],
          ),
        ),

        Expanded(
          child: filteredPatients.isEmpty
              ? emptyMessage('No matching patients found.')
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: filteredPatients.length,
                  itemBuilder: (context, index) {
                    final patient = filteredPatients[index];

                    return Card(
                      color: Colors.white,
                      elevation: 0,
                      margin: const EdgeInsets.only(bottom: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(13),
                        side: const BorderSide(color: Color(0xFFE8EBF0)),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(12),
                        leading: const CircleAvatar(
                          backgroundColor: Color(0xFFEAF0F8),
                          child: Icon(Icons.person, color: navy),
                        ),
                        title: Text(
                          patient['name']!,
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        subtitle: Text(
                          '${patient['id']}\n${patient['phone']}',
                          style: GoogleFonts.poppins(fontSize: 10),
                        ),
                        isThreeLine: true,
                        trailing: const Icon(
                          Icons.chevron_right,
                          color: Colors.grey,
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  PatientDetailsScreen(patient: patient),
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
