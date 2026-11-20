
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../widgets/shared_widgets.dart';

class TreatmentsScreen extends StatelessWidget {
  const TreatmentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final treatments = [
      ['Tooth Extraction', 'Maria Santos', 'November 19, 2026'],
      ['Dental Cleaning', 'Juan Dela Cruz', 'November 18, 2026'],
      ['Dental Filling', 'Ana Reyes', 'November 17, 2026'],
      ['Root Canal', 'Pedro Garcia', 'November 15, 2026'],
    ];

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Row(
          children: [
            Expanded(
              child: sectionTitle(
                'Treatment Records',
                subtitle: 'Manage dental procedures',
              ),
            ),
            ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Treatment form coming soon.'),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: navy,
                foregroundColor: Colors.white,
              ),
              child: const Icon(Icons.add),
            ),
          ],
        ),

        const SizedBox(height: 20),

        ...treatments.map((treatment) {
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(13),
              border: Border.all(
                color: const Color(0xFFE8EBF0),
              ),
            ),
            child: Row(
              children: [
                const CircleAvatar(
                  backgroundColor: Color(0xFFEAF0F8),
                  child: Icon(
                    Icons.medical_services_rounded,
                    color: navy,
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        treatment[0],
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        treatment[1],
                        style: GoogleFonts.poppins(
                          fontSize: 11,
                          color: Colors.grey[600],
                        ),
                      ),
                      Text(
                        treatment[2],
                        style: GoogleFonts.poppins(
                          fontSize: 10,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),

                const Icon(
                  Icons.chevron_right,
                  color: Colors.grey,
                ),
              ],
            ),
          );
        }),
      ],
    );
  }
}
