import 'package:flutter/cupertino.dart';
import 'package:databases/features/home/constants/app_colors.dart';

class WelcomeCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final bool isDarkMode;

  const WelcomeCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
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
            icon,
            size: 60,
            color: AppColors.getIconPrimary(isDarkMode),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.getTextPrimary(isDarkMode),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 16,
              color: AppColors.getTextSecondary(isDarkMode),
            ),
          ),
        ],
      ),
    );
  }
} 