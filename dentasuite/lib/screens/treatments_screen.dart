import 'package:flutter/material.dart';

import '../widgets/shared_widgets.dart';

class TreatmentsScreen extends StatelessWidget {
  const TreatmentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final p = context.pal;

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
              child: const Icon(Icons.add),
            ),
          ],
        ),

        const SizedBox(height: 20),

        ...treatments.map((treatment) {
          return appCard(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(15),
            child: Row(
              children: [
                iconBubble(
                  Icons.medical_services_rounded,
                  const Color(0xFF10B981),
                  size: 42,
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        treatment[0],
                        style: ts(context, 13, weight: FontWeight.w600),
                      ),
                      Text(
                        treatment[1],
                        style: ts(context, 11, sub: true),
                      ),
                      Text(
                        treatment[2],
                        style: ts(context, 10, sub: true),
                      ),
                    ],
                  ),
                ),

                Icon(
                  Icons.chevron_right_rounded,
                  color: p.textSub,
                ),
              ],
            ),
          );
        }),
      ],
    );
  }
}