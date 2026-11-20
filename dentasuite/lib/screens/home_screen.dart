
import 'package:dentasuite/widgets/app_logo.dart';
import 'package:flutter/material.dart';

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

class _DentaSuiteHomeScreenState
    extends State<DentaSuiteHomeScreen> {
  static const Color mint = Color(0xFFC2FFE1);
  static const Color navy = Color(0xFF0D203B);

  int selectedIndex = 0;

  final List<String> pageTitles = [
    'Dashboard',
    'Patients',
    'Treatments',
    'Certificates',
    'My Profile',
  ];

  final List<IconData> icons = [
    Icons.dashboard_rounded,
    Icons.people_alt_rounded,
    Icons.medical_services_rounded,
    Icons.description_rounded,
    Icons.person_rounded,
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final Color surfaceColor =
        isDark ? const Color(0xFF172B46) : Colors.white;

    final Color textColor = isDark ? Colors.white : navy;

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
      backgroundColor: theme.scaffoldBackgroundColor,

      appBar: AppBar(
        backgroundColor: surfaceColor,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        title: Row(
          children: [
            const AppLogo(
                width: 27,
                height: 27,
              ),
            const SizedBox(width: 10),
            Text(
              'DentaSuite',
              style: TextStyle(
                color: textColor,
                fontWeight: FontWeight.w700,
                fontSize: 20,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.notifications_none_rounded,
              color: textColor,
              size: 27,
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),

      body: Column(
        children: [
          Container(
            width: double.infinity,
            color: surfaceColor,
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 15),
            alignment: Alignment.centerLeft,
            child: Text(
              pageTitles[selectedIndex],
              style: TextStyle(
                fontSize: 14,
                color: theme.colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),

          Expanded(
            child: IndexedStack(
              index: selectedIndex,
              children: pages,
            ),
          ),
        ],
      ),

      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: surfaceColor,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 12,
              offset: const Offset(0, -3),
            ),
          ],
        ),
        child: SafeArea(
          child: BottomNavigationBar(
            currentIndex: selectedIndex,
            onTap: (index) {
              setState(() {
                selectedIndex = index;
              });
            },
            type: BottomNavigationBarType.fixed,
            backgroundColor: surfaceColor,
            selectedItemColor: isDark ? mint : navy,
            unselectedItemColor:
                theme.colorScheme.onSurfaceVariant,
            selectedFontSize: 11,
            unselectedFontSize: 10,
            elevation: 0,
            showUnselectedLabels: true,
            items: List.generate(
              icons.length,
              (index) => BottomNavigationBarItem(
                icon: Icon(icons[index]),
                label: pageTitles[index] == 'Dashboard'
                    ? 'Home'
                    : pageTitles[index] == 'My Profile'
                        ? 'Profile'
                        : pageTitles[index],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
