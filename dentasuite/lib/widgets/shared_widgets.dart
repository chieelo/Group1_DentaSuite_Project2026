
import 'package:flutter/material.dart';

const Color mint = Color(0xFFC2FFE1);
const Color navy = Color(0xFF0D203B);
const Color appWhite = Color(0xFFFFFFFF);

const Color background = appWhite;
const Color blue = navy;

const String appFont = 'Poppins';

Widget sectionTitle(String title, {String? subtitle}) {
  return Builder(
    builder: (context) {
      final theme = Theme.of(context);

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontFamily: appFont,
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: navy,
            ).copyWith(
              color: theme.colorScheme.onSurface,
            ),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 3),
            Text(
              subtitle,
              style: TextStyle(
                fontFamily: appFont,
                fontSize: 12,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ],
      );
    },
  );
}

Widget statCard({
  required String title,
  required String value,
  required IconData icon,
  required Color color,
}) {
  return Builder(
    builder: (context) {
      final theme = Theme.of(context);

      return Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: theme.dividerColor),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(9),
              decoration: BoxDecoration(
                color: mint.withValues(alpha: 0.35),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: navy, size: 23),
            ),
            const SizedBox(height: 13),
            Text(
              value,
              style: TextStyle(
                fontFamily: appFont,
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: theme.colorScheme.onSurface,
              ),
            ),
            Text(
              title,
              style: TextStyle(
                fontFamily: appFont,
                fontSize: 11,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      );
    },
  );
}

Widget emptyMessage(String message) {
  return Builder(
    builder: (context) {
      final theme = Theme.of(context);

      return Center(
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.folder_open_rounded,
                size: 55,
                color: theme.colorScheme.onSurfaceVariant,
              ),
              const SizedBox(height: 12),
              Text(
                message,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: appFont,
                  color: theme.colorScheme.onSurfaceVariant,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
