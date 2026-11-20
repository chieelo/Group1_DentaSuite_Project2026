
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../widgets/shared_widgets.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Good day, Admin!',
            style: GoogleFonts.poppins(
              fontSize: 23,
              fontWeight: FontWeight.w700,
              color: navy,
            ),
          ),
          Text(
            'Welcome back to DentaSuite.',
            style: GoogleFonts.poppins(
              fontSize: 13,
              color: Colors.grey[600],
            ),
          ),

          const SizedBox(height: 22),

          sectionTitle('Clinic Overview'),
          const SizedBox(height: 12),

          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.35,
            children: [
              statCard(
                title: 'Total Patients',
                value: '128',
                icon: Icons.people_alt_rounded,
                color: Colors.blue,
              ),
              statCard(
                title: 'Treatments',
                value: '86',
                icon: Icons.medical_services_rounded,
                color: Colors.green,
              ),
              statCard(
                title: 'Certificates',
                value: '24',
                icon: Icons.description_rounded,
                color: Colors.orange,
              ),
              statCard(
                title: 'Staff Members',
                value: '5',
                icon: Icons.badge_rounded,
                color: Colors.purple,
              ),
            ],
          ),

          const SizedBox(height: 25),

          sectionTitle(
            'Quick Actions',
            subtitle: 'Frequently used clinic functions',
          ),

          const SizedBox(height: 12),

          _quickAction(
            icon: Icons.person_add_alt_1_rounded,
            title: 'Register New Patient',
            subtitle: 'Create a new patient profile',
            color: Colors.blue,
          ),

          _quickAction(
            icon: Icons.add_chart_rounded,
            title: 'Record Treatment',
            subtitle: 'Document a dental procedure',
            color: Colors.green,
          ),

          _quickAction(
            icon: Icons.post_add_rounded,
            title: 'Generate Certificate',
            subtitle: 'Create a digital dental certificate',
            color: Colors.orange,
          ),

          const SizedBox(height: 25),

          sectionTitle('Recent Activities'),
          const SizedBox(height: 12),

          _activity(
            'New patient registered',
            'Maria Santos',
            'Today',
            Icons.person_add_alt_1,
          ),

          _activity(
            'Treatment recorded',
            'Juan Dela Cruz',
            'Today',
            Icons.medical_services,
          ),

          _activity(
            'Certificate generated',
            'Ana Reyes',
            'Yesterday',
            Icons.description,
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _quickAction({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(13),
        border: Border.all(color: const Color(0xFFE8EBF0)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 27),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: navy,
                  ),
                ),
                Text(
                  subtitle,
                  style: GoogleFonts.poppins(
                    fontSize: 11,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: Colors.grey),
        ],
      ),
    );
  }

  Widget _activity(
    String title,
    String name,
    String date,
    IconData icon,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 13),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Color(0xFFE8EBF0)),
        ),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: const Color(0xFFEAF0F8),
            child: Icon(icon, color: navy, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  name,
                  style: GoogleFonts.poppins(
                    fontSize: 11,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          Text(
            date,
            style: GoogleFonts.poppins(
              fontSize: 10,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
