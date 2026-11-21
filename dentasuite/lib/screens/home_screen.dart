
import 'package:dentasuite/widgets/app_logo.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../model/user.dart';
import '../widgets/shared_widgets.dart';
import 'dashboard_screen.dart';
import 'patients_screen.dart';
import 'treatments_screen.dart';
import 'certificates_screen.dart';
import 'accounts_screen.dart';
import 'profile_screen.dart';

class DentaSuiteHomeScreen extends StatefulWidget {
  final bool isDarkMode;
  final ValueChanged<bool> onThemeChanged;
  final AppUser user;

  const DentaSuiteHomeScreen({
    super.key,
    required this.isDarkMode,
    required this.onThemeChanged,
    required this.user,
  });

  @override
  State<DentaSuiteHomeScreen> createState() =>
      _DentaSuiteHomeScreenState();
}

class NavItem {
  final String label;
  final IconData icon;
  final IconData selectedIcon;
  final Widget page;

  const NavItem({
    required this.label,
    required this.icon,
    required this.selectedIcon,
    required this.page,
  });
}

class _DentaSuiteHomeScreenState
    extends State<DentaSuiteHomeScreen> {
  int selectedIndex = 0;

  List<NavItem> get navigationItems {
    final user = widget.user;

    return [
      NavItem(
        label: 'Home',
        icon: Icons.dashboard_outlined,
        selectedIcon: Icons.dashboard_rounded,
        page: DashboardScreen(user: user),
      ),
      NavItem(
        label: 'Patients',
        icon: Icons.people_alt_outlined,
        selectedIcon: Icons.people_alt_rounded,
        page: const PatientsScreen(),
      ),
      NavItem(
        label: 'Treatments',
        icon: Icons.medical_services_outlined,
        selectedIcon: Icons.medical_services_rounded,
        page: const TreatmentsScreen(),
      ),
      if (user.isDentist)
        NavItem(
          label: 'Certificates',
          icon: Icons.description_outlined,
          selectedIcon: Icons.description_rounded,
          page: const CertificatesScreen(),
        ),
      if (user.isAdmin)
        NavItem(
          label: 'Accounts',
          icon: Icons.manage_accounts_outlined,
          selectedIcon: Icons.manage_accounts_rounded,
          page: const AccountsScreen(),
        ),
      NavItem(
        label: 'Profile',
        icon: Icons.person_outline_rounded,
        selectedIcon: Icons.person_rounded,
        page: ProfileScreen(
          user: user,
          isDarkMode: widget.isDarkMode,
          onThemeChanged: widget.onThemeChanged,
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final p = context.pal;
    final items = navigationItems;

    return Scaffold(
      backgroundColor: p.bg,
      appBar: AppBar(
        backgroundColor: p.surface,
        elevation: 0,
        title: Row(
          children: [
            const AppLogo(
              width: 30,
              height: 30,
            ),
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
          child: Divider(
            height: 1,
            color: p.border,
          ),
        ),
      ),

      body: IndexedStack(
        index: selectedIndex,
        children: items.map((item) => item.page).toList(),
      ),

      bottomNavigationBar: DecoratedBox(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(color: p.border),
          ),
        ),
        child: NavigationBar(
          selectedIndex: selectedIndex,
          onDestinationSelected: (index) {
            setState(() {
              selectedIndex = index;
            });
          },
          destinations: items.map((item) {
            return NavigationDestination(
              icon: Icon(item.icon),
              selectedIcon: Icon(item.selectedIcon),
              label: item.label,
            );
          }).toList(),
        ),
      ),
    );
  }
}
