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
            style: ts(context, 11, sub: true),
          ),

          const SizedBox(height: 20),

          _toothRow(context, List.generate(8, (i) => 18 - i)),
          const SizedBox(height: 10),
          _toothRow(context, List.generate(8, (i) => 28 + i)),

          const Divider(height: 35),

          _toothRow(context, List.generate(8, (i) => 48 - i)),
          const SizedBox(height: 10),
          _toothRow(context, List.generate(8, (i) => 38 + i)),

          const SizedBox(height: 20),

          Text(
            'Tap a tooth to view its details.',
            style: ts(context, 11, sub: true),
          ),
        ],
      ),
    );
  }

  Widget _toothRow(BuildContext context, List<int> teeth) {
    final p = context.pal;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: teeth.map((number) {
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.all(2),
            child: InkWell(
              borderRadius: BorderRadius.circular(6),
              onTap: () {
                // Tooth selection can be implemented here.
              },
              child: Container(
                height: 43,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: p.surface,
                  border: Border.all(color: p.border),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: FittedBox(
                  child: Text(
                    '$number',
                    style: GoogleFonts.poppins(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: p.textMain,
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