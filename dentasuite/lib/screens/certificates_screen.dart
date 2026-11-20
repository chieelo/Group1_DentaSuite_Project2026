import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../widgets/shared_widgets.dart';

class CertificatesScreen extends StatelessWidget {
  const CertificatesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        sectionTitle(
          'Dental Certificates',
          subtitle: 'Create and manage digital certificates',
        ),

        const SizedBox(height: 20),

        // Hero card: gradient + white text is readable in both modes.
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: heroGradient,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.description_rounded,
                color: Colors.white,
                size: 35,
              ),

              const SizedBox(height: 12),

              Text(
                'Generate a Dental Certificate',
                style: GoogleFonts.poppins(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),

              const SizedBox(height: 5),

              Text(
                'Prepare a digital certificate using stored patient information.',
                style: GoogleFonts.poppins(
                  fontSize: 11,
                  color: Colors.white70,
                ),
              ),

              const SizedBox(height: 18),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Certificate generation coming soon.',
                        ),
                      ),
                    );
                  },
                  icon: const Icon(Icons.add),
                  label: Text(
                    'Create Certificate',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: navy,
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 25),

        sectionTitle('Previously Generated'),

        const SizedBox(height: 12),

        _certificate(context, 'Maria Santos', 'CERT-0001'),
        _certificate(context, 'Juan Dela Cruz', 'CERT-0002'),
        _certificate(context, 'Ana Reyes', 'CERT-0003'),
      ],
    );
  }

  Widget _certificate(BuildContext context, String name, String id) {
    final p = context.pal;

    return appCard(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(15),
      child: Row(
        children: [
          iconBubble(
            Icons.picture_as_pdf_rounded,
            Colors.redAccent,
            size: 42,
            iconSize: 24,
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: ts(context, 13, weight: FontWeight.w600),
                ),
                Text(id, style: ts(context, 10, sub: true)),
              ],
            ),
          ),

          Icon(Icons.more_vert, color: p.textSub),
        ],
      ),
    );
  }
}