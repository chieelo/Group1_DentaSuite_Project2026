import 'package:flutter/material.dart';

import '../model/user.dart';

class ProfileScreen extends StatelessWidget {
  final bool isDarkMode;
  final ValueChanged<bool> onThemeChanged;
  final AppUser user;

  const ProfileScreen({
    super.key,
    required this.isDarkMode,
    required this.onThemeChanged,
    required this.user,
  });

  static const Color mint = Color(0xFFC2FFE1);
  static const Color navy = Color(0xFF0D203B);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const SizedBox(height: 10),

        CircleAvatar(
          radius: 45,
          backgroundColor: isDark ? const Color(0xFF29435C) : mint,
          child: Icon(Icons.person, color: isDark ? mint : navy, size: 50),
        ),

        const SizedBox(height: 15),

        Text(
          user.fullName,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 19,
            fontWeight: FontWeight.w700,
            color: theme.colorScheme.onSurface,
          ),
        ),

        const SizedBox(height: 4),

        Text(
          user.email,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 12,
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),

        const SizedBox(height: 5),

        Text(
          '@${user.username}',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 12,
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),

        const SizedBox(height: 12),

        Center(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 6),
            decoration: BoxDecoration(
              color: mint,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              user.role,
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: navy,
              ),
            ),
          ),
        ),

        const SizedBox(height: 30),

        _sectionTitle(context, 'Account Settings'),

        const SizedBox(height: 12),

        _profileOption(
          context,
          Icons.person_outline,
          'Personal Information',
          onTap: () {},
        ),

        _profileOption(
          context,
          Icons.lock_outline,
          'Change Password',
          onTap: () {},
        ),

        _profileOption(
          context,
          Icons.settings_outlined,
          'Application Settings',
          onTap: () {},
        ),

        _profileOption(
          context,
          Icons.help_outline,
          'Help and Support',
          onTap: () {},
        ),

        _profileOption(
          context,
          Icons.info_outline,
          'About DentaSuite',
          onTap: () {},
        ),

        const SizedBox(height: 25),

        _sectionTitle(context, 'Appearance'),

        const SizedBox(height: 12),

        Material(
          color: theme.cardColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: theme.dividerColor),
          ),
          clipBehavior: Clip.antiAlias,
          child: SwitchListTile(
            value: isDark,
            onChanged: onThemeChanged,
            activeThumbColor: navy,
            activeTrackColor: mint,
            secondary: Icon(
              isDark ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
              color: isDark ? mint : navy,
            ),
            title: Text(
              'Dark Mode',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onSurface,
              ),
            ),
            subtitle: Text(
              isDark
                  ? 'Dark appearance is enabled'
                  : 'Light appearance is enabled',
              style: TextStyle(
                fontSize: 11,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ),

        const SizedBox(height: 30),

        OutlinedButton.icon(
          onPressed: () {
            Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
          },
          icon: const Icon(Icons.logout, color: Colors.red),
          label: const Text(
            'Log Out',
            style: TextStyle(color: Colors.red, fontWeight: FontWeight.w600),
          ),
          style: OutlinedButton.styleFrom(
            side: const BorderSide(color: Colors.redAccent),
            padding: const EdgeInsets.all(13),
          ),
        ),

        const SizedBox(height: 20),
      ],
    );
  }

  Widget _sectionTitle(BuildContext context, String title) {
    final theme = Theme.of(context);

    return Text(
      title,
      style: TextStyle(
        fontSize: 17,
        fontWeight: FontWeight.w700,
        color: theme.colorScheme.onSurface,
      ),
    );
  }

  Widget _profileOption(
    BuildContext context,
    IconData icon,
    String title, {
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: theme.cardColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: theme.dividerColor),
        ),
        clipBehavior: Clip.antiAlias,
        child: ListTile(
          leading: Icon(icon, color: isDark ? mint : navy),
          title: Text(
            title,
            style: TextStyle(fontSize: 12, color: theme.colorScheme.onSurface),
          ),
          trailing: Icon(
            Icons.chevron_right,
            color: theme.colorScheme.onSurfaceVariant,
          ),
          onTap: onTap,
        ),
      ),
    );
  }
}
