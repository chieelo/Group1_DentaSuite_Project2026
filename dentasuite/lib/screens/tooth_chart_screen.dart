
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../widgets/shared_widgets.dart';

class ToothChartScreen extends StatelessWidget {
  const ToothChartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          sectionTitle('Dental Chart'),
          const SizedBox(height: 5),

          Text(
            'Sample tooth chart interface',
            style: GoogleFonts.poppins(
              fontSize: 11,
              color: Colors.grey,
            ),
          ),

          const SizedBox(height: 20),

          _toothRow(List.generate(8, (i) => 18 - i)),
          const SizedBox(height: 10),
          _toothRow(List.generate(8, (i) => 28 + i)),

          const Divider(height: 35),

          _toothRow(List.generate(8, (i) => 48 - i)),
          const SizedBox(height: 10),
          _toothRow(List.generate(8, (i) => 38 + i)),

          const SizedBox(height: 20),

          Text(
            'Tap a tooth to view its details.',
            style: GoogleFonts.poppins(
              fontSize: 11,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _toothRow(List<int> teeth) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: teeth.map((number) {
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.all(2),
            child: InkWell(
              onTap: () {
                // Tooth selection can be implemented here.
              },
              child: Container(
                height: 43,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    color: const Color(0xFFB8C3D1),
                  ),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: FittedBox(
                  child: Text(
                    '$number',
                    style: GoogleFonts.poppins(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: navy,
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
