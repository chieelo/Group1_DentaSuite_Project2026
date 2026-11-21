
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../model/user.dart';
import '../widgets/shared_widgets.dart';

class DashboardScreen extends StatelessWidget {
  final AppUser user;

  const DashboardScreen({
    super.key,
    required this.user,
  });

  String _greeting() {
    final h = DateTime.now().hour;
    if (h < 12) return 'Good morning';
    if (h < 18) return 'Good afternoon';
    return 'Good evening';
  }

  String _dateLabel() {
    const days = [
      'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'
    ];

    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];

    final n = DateTime.now();

    return '${days[n.weekday - 1]}, ${months[n.month - 1]} ${n.day}';
  }

  @override
  Widget build(BuildContext context) {
    final p = context.pal;

    final quickActions = <Widget>[
      _quickAction(
        context,
        Icons.person_add_alt_1_rounded,
        'New Patient',
        const Color(0xFF3B82F6),
      ),
      if (!user.isAssistant)
        _quickAction(
          context,
          Icons.add_chart_rounded,
          'Treatment',
          const Color(0xFF10B981),
        ),
      if (user.isDentist)
        _quickAction(
          context,
          Icons.post_add_rounded,
          'Certificate',
          const Color(0xFFF59E0B),
        ),
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _hero(context),

          const SizedBox(height: 24),

          sectionTitle('Clinic Overview'),
          const SizedBox(height: 12),

          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.12,
            children: [
              statCard(
                title: 'Total Patients',
                value: '128',
                icon: Icons.people_alt_rounded,
                color: const Color(0xFF3B82F6),
              ),
              statCard(
                title: 'Treatments',
                value: '86',
                icon: Icons.medical_services_rounded,
                color: const Color(0xFF10B981),
              ),
              statCard(
                title: 'Certificates',
                value: '24',
                icon: Icons.description_rounded,
                color: const Color(0xFFF59E0B),
              ),
              statCard(
                title: 'Staff Members',
                value: '5',
                icon: Icons.badge_rounded,
                color: const Color(0xFF8B5CF6),
              ),
            ],
          ),

          const SizedBox(height: 24),

          sectionTitle(
            'Quick Actions',
            subtitle: 'Frequently used clinic functions',
          ),

          const SizedBox(height: 12),

          Row(
            children: [
              for (int i = 0; i < quickActions.length; i++) ...[
                if (i > 0) const SizedBox(width: 10),
                quickActions[i],
              ],
            ],
          ),

          const SizedBox(height: 24),

          sectionTitle('Recent Activities'),
          const SizedBox(height: 12),

          appCard(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 4,
            ),
            child: Column(
              children: [
                _activity(
                  context,
                  'New patient registered',
                  'Maria Santos',
                  'Today',
                  Icons.person_add_alt_1_rounded,
                  const Color(0xFF3B82F6),
                ),
                Divider(height: 1, color: p.border),
                _activity(
                  context,
                  'Treatment recorded',
                  'Juan Dela Cruz',
                  'Today',
                  Icons.medical_services_rounded,
                  const Color(0xFF10B981),
                ),
                Divider(height: 1, color: p.border),
                _activity(
                  context,
                  'Certificate generated',
                  'Ana Reyes',
                  'Yesterday',
                  Icons.description_rounded,
                  const Color(0xFFF59E0B),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _circle(double size, double alpha) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withValues(alpha: alpha),
      ),
    );
  }

  Widget _hero(BuildContext context) {
    final isDark =
        Theme.of(context).brightness == Brightness.dark;

    final firstName = user.firstName.trim().isEmpty
        ? user.role
        : user.firstName;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: isDark
            ? const LinearGradient(
                colors: [
                  Color(0xFF18344F),
                  Color(0xFF0D203B),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : heroGradient,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: navy.withValues(alpha: 0.25),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22),
        child: Stack(
          children: [
            Positioned(
              right: -28,
              top: -28,
              child: _circle(120, 0.07),
            ),
            Positioned(
              right: 44,
              bottom: -46,
              child: _circle(100, 0.05),
            ),
            Padding(
              padding: const EdgeInsets.all(22),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(
                              alpha: 0.14,
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.calendar_today_rounded,
                                size: 12,
                                color: Colors.white,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                _dateLabel(),
                                style: GoogleFonts.poppins(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 16),

                        Text(
                          '${_greeting()},',
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            color: Colors.white70,
                          ),
                        ),

                        Text(
                          '$firstName!',
                          style: GoogleFonts.poppins(
                            fontSize: 27,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                            height: 1.2,
                          ),
                        ),

                        const SizedBox(height: 4),

                        Text(
                          'Welcome back to DentaSuite.',
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ),

                  Container(
                    width: 58,
                    height: 58,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withValues(alpha: 0.14),
                    ),
                    child: const Icon(
                      Icons.health_and_safety_rounded,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _quickAction(
    BuildContext context,
    IconData icon,
    String label,
    Color color,
  ) {
    return Expanded(
      child: appCard(
        padding: const EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 6,
        ),
        child: Column(
          children: [
            iconBubble(
              icon,
              color,
              size: 46,
              iconSize: 24,
            ),
            const SizedBox(height: 10),
            Text(
              label,
              textAlign: TextAlign.center,
              style: ts(
                context,
                11,
                weight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _activity(
    BuildContext context,
    String title,
    String name,
    String date,
    IconData icon,
    Color color,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          iconBubble(
            icon,
            color,
            size: 40,
            iconSize: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: ts(
                    context,
                    12,
                    weight: FontWeight.w600,
                  ),
                ),
                Text(
                  name,
                  style: ts(context, 11, sub: true),
                ),
              ],
            ),
          ),
          Text(
            date,
            style: ts(context, 10, sub: true),
          ),
        ],
      ),
    );
  }
}
