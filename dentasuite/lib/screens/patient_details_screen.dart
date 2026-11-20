
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'tooth_chart_screen.dart';
import '../widgets/shared_widgets.dart';

class PatientDetailsScreen extends StatelessWidget {
  final Map<String, String> patient;

  const PatientDetailsScreen({
    super.key,
    required this.patient,
  });

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        backgroundColor: background,
        appBar: AppBar(
          backgroundColor: navy,
          foregroundColor: Colors.white,
          title: Text(
            'Patient Details',
            style: GoogleFonts.poppins(
              fontSize: 17,
              fontWeight: FontWeight.w600,
            ),
          ),
          bottom: TabBar(
            isScrollable: true,
            indicatorColor: Colors.white,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            labelStyle: GoogleFonts.poppins(fontSize: 11),
            tabs: const [
              Tab(text: 'Personal Info'),
              Tab(text: 'Medical History'),
              Tab(text: 'Dental Chart'),
              Tab(text: 'Treatment History'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _detailsContent([
              _info('Patient Name', patient['name']!),
              _info('Patient ID', patient['id']!),
              _info('Contact Number', patient['phone']!),
              _info('Gender', patient['gender']!),
              _info('Email Address', 'Not provided'),
              _info('Address', 'Not provided'),
            ]),

            _detailsContent([
              _info('Known Allergies', 'No information recorded'),
              _info('Existing Conditions', 'No information recorded'),
              _info('Current Medications', 'No information recorded'),
              _info('Previous Surgeries', 'No information recorded'),
              _info('Medical Notes', 'No information recorded'),
            ]),

            const ToothChartScreen(),

            _detailsContent([
              _info(
                'Treatment History',
                'No treatments recorded yet',
              ),
            ]),
          ],
        ),
      ),
    );
  }

  Widget _detailsContent(List<Widget> children) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: children,
    );
  }

  Widget _info(String label, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 11,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: navy,
            ),
          ),
        ],
      ),
    );
  }
}
