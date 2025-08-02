import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:databases/features/home/constants/app_colors.dart';

class ProfileHeader extends StatelessWidget {
  final User? user;
  final bool isDarkMode;

  const ProfileHeader({
    super.key,
    required this.user,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.getCardBackground(isDarkMode),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(
            CupertinoIcons.person_circle_fill,
            size: 80,
            color: AppColors.getIconPrimary(isDarkMode),
          ),
          const SizedBox(height: 16),
                      Text(
              user?.email ?? 'User',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.getTextPrimary(isDarkMode),
              ),
            ),
          const SizedBox(height: 8),
                      Text(
              'Member since ${user?.metadata.creationTime?.year ?? 'N/A'}',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.getTextSecondary(isDarkMode),
              ),
            ),
          if (user?.emailVerified == false) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 6,
              ),
              decoration: BoxDecoration(
                color: CupertinoColors.systemOrange.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: CupertinoColors.systemOrange.withOpacity(0.3),
                ),
              ),
              child: const Text(
                '⚠️ Email chưa được xác thực',
                style: TextStyle(
                  fontSize: 12,
                  color: CupertinoColors.systemOrange,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
} 