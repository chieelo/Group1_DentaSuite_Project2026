import 'package:dentasuite/widgets/app_logo.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../widgets/shared_widgets.dart';
import 'dashboard_screen.dart';
import 'patients_screen.dart';
import 'treatments_screen.dart';
import 'certificates_screen.dart';
import 'profile_screen.dart';

class DentaSuiteHomeScreen extends StatefulWidget {
  final bool isDarkMode;
  final ValueChanged<bool> onThemeChanged;

  const DentaSuiteHomeScreen({
    super.key,
    required this.isDarkMode,
    required this.onThemeChanged,
  });

  @override
  State<DentaSuiteHomeScreen> createState() =>
      _DentaSuiteHomeScreenState();
}

class _DentaSuiteHomeScreenState extends State<DentaSuiteHomeScreen> {
  int selectedIndex = 0;

  static const List<String> navLabels = [
    'Home',
    'Patients',
    'Treatments',
    'Certificates',
    'Profile',
  ];

  static const List<IconData> icons = [
    Icons.dashboard_outlined,
    Icons.people_alt_outlined,
    Icons.medical_services_outlined,
    Icons.description_outlined,
    Icons.person_outline_rounded,
  ];

  static const List<IconData> selectedIcons = [
    Icons.dashboard_rounded,
    Icons.people_alt_rounded,
    Icons.medical_services_rounded,
    Icons.description_rounded,
    Icons.person_rounded,
  ];

  @override
  Widget build(BuildContext context) {
    final p = context.pal;

    final List<Widget> pages = [
      const DashboardScreen(),
      const PatientsScreen(),
      const TreatmentsScreen(),
      const CertificatesScreen(),
      ProfileScreen(
        isDarkMode: widget.isDarkMode,
        onThemeChanged: widget.onThemeChanged,
      ),
    ];

    return Scaffold(
      backgroundColor: p.bg,

      appBar: AppBar(
        backgroundColor: p.surface,
        title: Row(
          children: [
            const AppLogo(width: 30, height: 30),
            const SizedBox(width: 10),
            Text(
              'DentaSuite',
              style: GoogleFonts.poppins(
                color: p.textMain,
                fontWeight: FontWeight.w700,
                fontSize: 20,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Badge(
              smallSize: 8,
              child: Icon(
                Icons.notifications_none_rounded,
                color: p.textMain,
                size: 26,
              ),
            ),
          ),
          const SizedBox(width: 8),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Divider(height: 1, color: p.border),
        ),
      ),

      body: IndexedStack(
        index: selectedIndex,
        children: pages,
      ),

      bottomNavigationBar: DecoratedBox(
        decoration: BoxDecoration(
          border: Border(top: BorderSide(color: p.border)),
        ),
        child: NavigationBar(
          selectedIndex: selectedIndex,
          onDestinationSelected: (index) {
            setState(() {
              selectedIndex = index;
            });
          },
          destinations: List.generate(
            navLabels.length,
            (index) => NavigationDestination(
              icon: Icon(icons[index]),
              selectedIcon: Icon(selectedIcons[index]),
              label: navLabels[index],
            ),
          ),
        ),
      ),
    );
  }
}