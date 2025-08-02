import 'package:flutter/cupertino.dart';
import 'package:databases/features/home/constants/app_colors.dart';

class ProfileMenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback? onPressed;
  final bool showDivider;
  final bool isDarkMode;

  const ProfileMenuItem({
    super.key,
    required this.icon,
    required this.title,
    this.onPressed,
    this.showDivider = true,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CupertinoButton(
          padding: const EdgeInsets.all(16),
          onPressed: onPressed,
          child: Row(
            children: [
              Icon(
                icon,
                color: AppColors.getIconPrimary(isDarkMode),
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: TextStyle(
                  color: AppColors.getTextPrimary(isDarkMode),
                  fontSize: 16,
                ),
              ),
              const Spacer(),
              Icon(
                CupertinoIcons.chevron_right,
                color: AppColors.getIconSecondary(isDarkMode),
                size: 16,
              ),
            ],
          ),
        ),
        if (showDivider)
                  Container(
          height: 1,
          margin: const EdgeInsets.only(left: 48),
          color: AppColors.getDivider(isDarkMode),
        ),
      ],
    );
  }
} 