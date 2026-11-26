import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../widgets/shared_widgets.dart';

class ToothChartScreen extends StatefulWidget {
  const ToothChartScreen({super.key});

  @override
  State<ToothChartScreen> createState() => _ToothChartScreenState();
}

class _ToothChartScreenState extends State<ToothChartScreen> {

  final List<int> upperRight = [1, 2, 3, 4, 5, 6, 7, 8];
  final List<int> upperLeft = [9, 10, 11, 12, 13, 14, 15, 16];

  final List<int> lowerRight = [32, 31, 30, 29, 28, 27, 26, 25];
  final List<int> lowerLeft = [24, 23, 22, 21, 20, 19, 18, 17];

  final Map<int, Set<String>> selectedSurfaces = {};


  void toggleSurface(int toothNumber, String surface) {
    setState(() {
      selectedSurfaces.putIfAbsent(
        toothNumber,
        () => <String>{},
      );

      final toothSelections = selectedSurfaces[toothNumber]!;

      if (toothSelections.contains(surface)) {
        toothSelections.remove(surface);
      } else {
        toothSelections.add(surface);
      }

      if (toothSelections.isEmpty) {
        selectedSurfaces.remove(toothNumber);
      }
    });
  }

  void cancelSelection() {
    setState(() {
      selectedSurfaces.clear();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Selection cleared.'),
      ),
    );
  }

  void saveSelection() {
    final totalSurfaces = selectedSurfaces.values.fold<int>(
      0,
      (total, surfaces) => total + surfaces.length,
    );

    if (selectedSurfaces.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No tooth surfaces selected.'),
        ),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '$totalSurfaces surface(s) selected across '
          '${selectedSurfaces.length} tooth/teeth.',
        ),
      ),
    );

  }

  @override
  Widget build(BuildContext context) {
    final p = context.pal;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          sectionTitle('Dental Chart'),

          const SizedBox(height: 5),

          Text(
            'Select a tooth and mark the affected surfaces.',
            style: ts(context, 11, sub: true),
          ),

          const SizedBox(height: 20),

          _sectionHeader(
            context,
            title: 'Upper Teeth',
            subtitle: 'Maxillary arch',
            icon: Icons.keyboard_arrow_up_rounded,
          ),

          const SizedBox(height: 14),

          _quadrant(
            context,
            title: 'Upper Right',
            subtitle: 'Teeth 1–8',
            teeth: upperRight,
          ),

          const SizedBox(height: 16),

          _quadrant(
            context,
            title: 'Upper Left',
            subtitle: 'Teeth 9–16',
            teeth: upperLeft,
          ),

          const SizedBox(height: 24),

          _sectionHeader(
            context,
            title: 'Lower Teeth',
            subtitle: 'Mandibular arch',
            icon: Icons.keyboard_arrow_down_rounded,
          ),

          const SizedBox(height: 14),

          _quadrant(
            context,
            title: 'Lower Right',
            subtitle: 'Teeth 32–25',
            teeth: lowerRight,
          ),

          const SizedBox(height: 16),

          _quadrant(
            context,
            title: 'Lower Left',
            subtitle: 'Teeth 24–17',
            teeth: lowerLeft,
          ),

          const SizedBox(height: 24),

          _legend(context),

          const SizedBox(height: 20),

          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: cancelSelection,
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      vertical: 14,
                    ),
                    side: BorderSide(
                      color: p.border,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    'Cancel',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: p.textMain,
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: ElevatedButton(
                  onPressed: saveSelection,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      vertical: 14,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    'Save',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          Center(
            child: Text(
              '${selectedSurfaces.length} tooth/teeth selected',
              style: ts(context, 10, sub: true),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionHeader(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
  }) {
    final p = context.pal;
    final primary = Theme.of(context).colorScheme.primary;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 12,
      ),
      decoration: BoxDecoration(
        color: p.surface,
        border: Border.all(color: p.border),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: 26,
            color: primary,
          ),

          const SizedBox(width: 10),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: p.textMain,
                ),
              ),

              Text(
                subtitle,
                style: ts(context, 10, sub: true),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _quadrant(
    BuildContext context, {
    required String title,
    required String subtitle,
    required List<int> teeth,
  }) {
    final p = context.pal;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(
            left: 2,
            bottom: 8,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: p.textMain,
                ),
              ),

              Text(
                subtitle,
                style: ts(context, 9, sub: true),
              ),
            ],
          ),
        ),

        SizedBox(
          height: 205,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: teeth.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              final toothNumber = teeth[index];

              return _toothCard(
                context,
                toothNumber: toothNumber,
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _toothCard(
    BuildContext context, {
    required int toothNumber,
  }) {
    final p = context.pal;
    final primary = Theme.of(context).colorScheme.primary;

    final selected = selectedSurfaces[toothNumber] ?? <String>{};

    final hasSelection = selected.isNotEmpty;

    return Container(
      width: 108,
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        color: p.surface,
        border: Border.all(
          color: hasSelection ? primary : p.border,
          width: hasSelection ? 1.5 : 1,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Container(
            width: 34,
            height: 26,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: primary.withOpacity(0.10),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              '$toothNumber',
              style: GoogleFonts.poppins(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: primary,
              ),
            ),
          ),

          const SizedBox(height: 5),

          SizedBox(
            height: 65,
            width: 54,
            child: CustomPaint(
              painter: ToothSidePainter(
                color: p.textMain.withOpacity(0.75),
              ),
            ),
          ),

          const SizedBox(height: 5),

          _surfaceDiagram(
            context,
            toothNumber: toothNumber,
            selected: selected,
          ),
        ],
      ),
    );
  }

  Widget _surfaceDiagram(
    BuildContext context, {
    required int toothNumber,
    required Set<String> selected,
  }) {
    final primary = Theme.of(context).colorScheme.primary;
    final p = context.pal;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: (details) {
        const diagramSize = 84.0;
        final localPosition = details.localPosition;

        final center = Offset(
          diagramSize / 2,
          diagramSize / 2,
        );

        final dx = localPosition.dx - center.dx;
        final dy = localPosition.dy - center.dy;

        final distance = math.sqrt(dx * dx + dy * dy);

        const centerRadius = 18.0;

        String surface;

        if (distance <= centerRadius) {
          surface = 'center';
        } else {
          final angle = math.atan2(dy, dx);

          if (angle >= -math.pi / 4 &&
              angle < math.pi / 4) {
            surface = 'right';
          }

          else if (angle >= math.pi / 4 &&
              angle < 3 * math.pi / 4) {
            surface = 'bottom';
          }

          else if (angle >= 3 * math.pi / 4 ||
              angle < -3 * math.pi / 4) {
            surface = 'left';
          }

          else {
            surface = 'top';
          }
        }

        toggleSurface(toothNumber, surface);
      },
      child: SizedBox(
        width: 84,
        height: 84,
        child: CustomPaint(
          painter: FiveSurfacePainter(
            selected: selected,
            primaryColor: primary,
            borderColor: p.border,
            backgroundColor: p.surface,
            textColor: p.textMain,
          ),
        ),
      ),
    );
  }

  Widget _legend(BuildContext context) {
    final p = context.pal;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: p.surface,
        border: Border.all(color: p.border),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Tooth Surfaces',
            style: GoogleFonts.poppins(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: p.textMain,
            ),
          ),

          const SizedBox(height: 10),

          Wrap(
            spacing: 14,
            runSpacing: 10,
            children: const [
              _LegendItem(
                label: 'Top',
                letter: 'T',
              ),
              _LegendItem(
                label: 'Left',
                letter: 'L',
              ),
              _LegendItem(
                label: 'Center',
                letter: 'C',
              ),
              _LegendItem(
                label: 'Right',
                letter: 'R',
              ),
              _LegendItem(
                label: 'Bottom',
                letter: 'B',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _LegendItem extends StatelessWidget {
  final String label;
  final String letter;

  const _LegendItem({
    required this.label,
    required this.letter,
  });

  @override
  Widget build(BuildContext context) {
    final p = context.pal;
    final primary = Theme.of(context).colorScheme.primary;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 20,
          height: 20,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: Border.all(color: p.border),
            borderRadius: BorderRadius.circular(5),
          ),
          child: Text(
            letter,
            style: GoogleFonts.poppins(
              fontSize: 9,
              fontWeight: FontWeight.w600,
              color: primary,
            ),
          ),
        ),

        const SizedBox(width: 5),

        Text(
          label,
          style: ts(context, 10, sub: true),
        ),
      ],
    );
  }
}

class FiveSurfacePainter extends CustomPainter {
  final Set<String> selected;
  final Color primaryColor;
  final Color borderColor;
  final Color backgroundColor;
  final Color textColor;

  FiveSurfacePainter({
    required this.selected,
    required this.primaryColor,
    required this.borderColor,
    required this.backgroundColor,
    required this.textColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(
      size.width / 2,
      size.height / 2,
    );

    final radius = math.min(size.width, size.height) / 2 - 2;
    final centerRadius = radius * 0.43;

    final surfaces = [
      'top',
      'right',
      'bottom',
      'left',
    ];

    final labels = {
      'top': 'T',
      'right': 'R',
      'bottom': 'B',
      'left': 'L',
      'center': 'C',
    };

    for (int i = 0; i < surfaces.length; i++) {
      final surface = surfaces[i];

      final startAngle = -3 * math.pi / 4 + i * math.pi / 2;
      const sweepAngle = math.pi / 2;

      final path = Path()
        ..moveTo(center.dx, center.dy)
        ..arcTo(
          Rect.fromCircle(
            center: center,
            radius: radius,
          ),
          startAngle,
          sweepAngle,
          false,
        )
        ..close();

      final isSelected = selected.contains(surface);

      final fillPaint = Paint()
        ..color = isSelected
            ? primaryColor
            : backgroundColor
        ..style = PaintingStyle.fill;

      canvas.drawPath(path, fillPaint);

      final borderPaint = Paint()
        ..color = borderColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.2;

      canvas.drawPath(path, borderPaint);

      final labelAngle = startAngle + sweepAngle / 2;
      final labelRadius = (radius + centerRadius) / 2;

      final labelPosition = Offset(
        center.dx + math.cos(labelAngle) * labelRadius,
        center.dy + math.sin(labelAngle) * labelRadius,
      );

      _drawLabel(
        canvas,
        labels[surface]!,
        labelPosition,
        isSelected ? Colors.white : textColor,
      );
    }

    final centerSelected = selected.contains('center');

    canvas.drawCircle(
      center,
      centerRadius,
      Paint()
        ..color = centerSelected
            ? primaryColor
            : backgroundColor
        ..style = PaintingStyle.fill,
    );

    canvas.drawCircle(
      center,
      centerRadius,
      Paint()
        ..color = borderColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.2,
    );

    _drawLabel(
      canvas,
      'C',
      center,
      centerSelected ? Colors.white : textColor,
    );
  }

  void _drawLabel(
    Canvas canvas,
    String text,
    Offset position,
    Color color,
  ) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.w700,
        ),
      ),
      textDirection: TextDirection.ltr,
    );

    textPainter.layout();

    textPainter.paint(
      canvas,
      Offset(
        position.dx - textPainter.width / 2,
        position.dy - textPainter.height / 2,
      ),
    );
  }

  @override
  bool shouldRepaint(covariant FiveSurfacePainter oldDelegate) {
    return oldDelegate.selected != selected ||
        oldDelegate.primaryColor != primaryColor ||
        oldDelegate.borderColor != borderColor ||
        oldDelegate.backgroundColor != backgroundColor ||
        oldDelegate.textColor != textColor;
  }
}

class ToothSidePainter extends CustomPainter {
  final Color color;

  ToothSidePainter({
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.4
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final path = Path();

    path.moveTo(size.width * 0.24, size.height * 0.12);

    path.quadraticBezierTo(
      size.width * 0.12,
      size.height * 0.04,
      size.width * 0.20,
      size.height * 0.36,
    );

    path.quadraticBezierTo(
      size.width * 0.18,
      size.height * 0.48,
      size.width * 0.30,
      size.height * 0.52,
    );

    path.quadraticBezierTo(
      size.width * 0.50,
      size.height * 0.58,
      size.width * 0.70,
      size.height * 0.52,
    );

    path.quadraticBezierTo(
      size.width * 0.84,
      size.height * 0.46,
      size.width * 0.80,
      size.height * 0.30,
    );

    path.quadraticBezierTo(
      size.width * 0.88,
      size.height * 0.04,
      size.width * 0.68,
      size.height * 0.12,
    );

    path.quadraticBezierTo(
      size.width * 0.50,
      size.height * 0.20,
      size.width * 0.24,
      size.height * 0.12,
    );

    path.moveTo(size.width * 0.32, size.height * 0.50);

    path.quadraticBezierTo(
      size.width * 0.28,
      size.height * 0.62,
      size.width * 0.34,
      size.height * 0.78,
    );

    path.quadraticBezierTo(
      size.width * 0.38,
      size.height * 0.94,
      size.width * 0.46,
      size.height * 0.98,
    );

    path.quadraticBezierTo(
      size.width * 0.54,
      size.height * 0.88,
      size.width * 0.58,
      size.height * 0.68,
    );

    path.quadraticBezierTo(
      size.width * 0.62,
      size.height * 0.58,
      size.width * 0.68,
      size.height * 0.50,
    );

    canvas.drawPath(path, paint);

    final detailPath = Path()
      ..moveTo(size.width * 0.24, size.height * 0.40)
      ..quadraticBezierTo(
        size.width * 0.50,
        size.height * 0.48,
        size.width * 0.80,
        size.height * 0.38,
      );

    canvas.drawPath(detailPath, paint);
  }

  @override
  bool shouldRepaint(covariant ToothSidePainter oldDelegate) {
    return oldDelegate.color != color;
  }
}