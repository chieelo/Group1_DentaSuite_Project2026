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

  String _value(String key) {
    final v = patient[key];
    return (v == null || v.trim().isEmpty) ? 'Not provided' : v;
  }

  @override
  Widget build(BuildContext context) {
    final p = context.pal;

    return DefaultTabController(
      length: 4,
      child: Scaffold(
        backgroundColor: p.bg,
        appBar: AppBar(
          backgroundColor: p.isDark ? p.surface : navy,
          foregroundColor: Colors.white,
          iconTheme: const IconThemeData(color: Colors.white),
          title: Text(
            'Patient Details',
            style: GoogleFonts.poppins(
              fontSize: 17,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          bottom: TabBar(
            isScrollable: true,
            tabAlignment: TabAlignment.start,
            indicatorColor: Colors.white,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            dividerColor: Colors.transparent,
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
              _info(context, 'Patient Name', _value('name')),
              _info(context, 'Patient ID', _value('id')),
              _info(context, 'Contact Number', _value('phone')),
              _info(context, 'Gender', _value('gender')),
              _info(context, 'Email Address', _value('email')),
              _info(context, 'Address', _value('address')),
            ]),

            _detailsContent([
              _info(context, 'Known Allergies', 'No information recorded'),
              _info(context, 'Existing Conditions',
                  'No information recorded'),
              _info(context, 'Current Medications',
                  'No information recorded'),
              _info(context, 'Previous Surgeries',
                  'No information recorded'),
              _info(context, 'Medical Notes', 'No information recorded'),
            ]),

            const ToothChartScreen(),

            _detailsContent([
              _info(
                context,
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

  Widget _info(BuildContext context, String label, String value) {
    return appCard(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: ts(context, 11, sub: true)),
          const SizedBox(height: 4),
          Text(
            value,
            style: ts(context, 13, weight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}