
import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  final bool isDarkMode;
  final ValueChanged<bool> onThemeChanged;

  const ProfileScreen({
    super.key,
    required this.isDarkMode,
    required this.onThemeChanged,
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
          backgroundColor: isDark
              ? const Color(0xFF29435C)
              : mint,
          child: Icon(
            Icons.person,
            color: isDark ? mint : navy,
            size: 50,
          ),
        ),

        const SizedBox(height: 15),

        Text(
          'Admin User',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 19,
            fontWeight: FontWeight.w700,
            color: theme.colorScheme.onSurface,
          ),
        ),

        Text(
          'admin@dentasuite.com',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 12,
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),

        const SizedBox(height: 8),

        Center(
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 15,
              vertical: 5,
            ),
            decoration: BoxDecoration(
              color: mint,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              'ADMINISTRATOR',
              style: TextStyle(
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
        ),

        _profileOption(
          context,
          Icons.lock_outline,
          'Change Password',
        ),

        _profileOption(
          context,
          Icons.settings_outlined,
          'Application Settings',
        ),

        _profileOption(
          context,
          Icons.help_outline,
          'Help and Support',
        ),

        _profileOption(
          context,
          Icons.info_outline,
          'About DentaSuite',
        ),

        const SizedBox(height: 25),

        _sectionTitle(context, 'Appearance'),
        const SizedBox(height: 12),

        Container(
          decoration: BoxDecoration(
            color: theme.cardColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: theme.dividerColor,
            ),
          ),
          child: SwitchListTile(
            value: isDarkMode,
            onChanged: onThemeChanged,
            activeThumbColor: navy,
            activeTrackColor: mint,
            secondary: Icon(
              isDarkMode
                  ? Icons.dark_mode_rounded
                  : Icons.light_mode_rounded,
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
              isDarkMode
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
            Navigator.pushNamedAndRemoveUntil(
              context,
              '/',
              (route) => false,
            );
          },
          icon: const Icon(
            Icons.logout,
            color: Colors.red,
          ),
          label: const Text(
            'Log Out',
            style: TextStyle(
              color: Colors.red,
              fontWeight: FontWeight.w600,
            ),
          ),
          style: OutlinedButton.styleFrom(
            side: const BorderSide(
              color: Colors.redAccent,
            ),
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
    String title,
  ) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.dividerColor,
        ),
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: isDark ? mint : navy,
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 12,
            color: theme.colorScheme.onSurface,
          ),
        ),
        trailing: Icon(
          Icons.chevron_right,
          color: theme.colorScheme.onSurfaceVariant,
        ),
        onTap: () {},
      ),
    );
  }
}
