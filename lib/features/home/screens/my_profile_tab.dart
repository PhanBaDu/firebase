import 'package:flutter/cupertino.dart';
import 'package:databases/features/authentication/services/auth_service.dart';
import 'package:databases/features/authentication/screens/change_password_screen.dart';
import 'package:databases/features/home/widgets/profile_header.dart';
import 'package:databases/features/home/widgets/profile_menu_item.dart';
import 'package:databases/features/home/providers/theme_provider.dart';
import 'package:databases/features/home/constants/app_colors.dart';
import 'package:provider/provider.dart';

class MyProfileTab extends StatefulWidget {
  const MyProfileTab({super.key});

  @override
  State<MyProfileTab> createState() => _MyProfileTabState();
}

class _MyProfileTabState extends State<MyProfileTab> {
  Future<void> _handleLogout(BuildContext context) async {
    try {
      // Gọi signOut từ AuthService trực tiếp
      await AuthService().signOut();

      // Không cần navigate thủ công vì AuthWrapper sẽ tự động chuyển hướng
    } catch (e) {
      print('Logout error: $e');

      // Hiển thị thông báo lỗi
      if (context.mounted) {
        showCupertinoDialog(
          context: context,
          builder: (errorContext) => CupertinoAlertDialog(
            title: const Text('Lỗi'),
            content: Text('Không thể đăng xuất: $e'),
            actions: [
              CupertinoDialogAction(
                child: const Text('OK'),
                onPressed: () => Navigator.pop(errorContext),
              ),
            ],
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = AuthService().currentUser;
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: const Text('My Profile'),
        backgroundColor: AppColors.getBackground(isDarkMode),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              // Profile header
              ProfileHeader(user: user, isDarkMode: isDarkMode),
              const SizedBox(height: 24),
              // Profile options
              Container(
                decoration: BoxDecoration(
                  color: CupertinoColors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    ProfileMenuItem(
                      icon: CupertinoIcons.person_crop_circle,
                      title: 'Chỉnh sửa hồ sơ',
                      onPressed: () {
                        // TODO: Edit profile
                      },
                      isDarkMode: isDarkMode,
                    ),
                    ProfileMenuItem(
                      icon: CupertinoIcons.lock,
                      title: 'Đổi mật khẩu',
                      onPressed: () {
                        Navigator.of(context).push(
                          CupertinoPageRoute(
                            builder: (context) => const ChangePasswordScreen(),
                          ),
                        );
                      },
                      isDarkMode: isDarkMode,
                    ),
                    ProfileMenuItem(
                      icon: CupertinoIcons.settings,
                      title: 'Cài đặt',
                      onPressed: () {
                        // TODO: Settings
                      },
                      isDarkMode: isDarkMode,
                    ),
                    ProfileMenuItem(
                      icon: isDarkMode ? CupertinoIcons.sun_max : CupertinoIcons.moon,
                      title: isDarkMode ? 'Chế độ sáng' : 'Chế độ tối',
                      onPressed: () {
                        themeProvider.toggleThemeMode();
                      },
                      showDivider: false,
                      isDarkMode: isDarkMode,
                    ),
                  ],
                ),
              ),
              const Spacer(),
              // Logout button
              CupertinoButton.filled(
                padding: const EdgeInsets.symmetric(
                  vertical: 15,
                  horizontal: 16,
                ),
                onPressed: () => _handleLogout(context),
                borderRadius: BorderRadius.circular(8),
                child: Text(
                  'Đăng xuất',
                  style: TextStyle(
                    color: AppColors.getButtonText(isDarkMode),
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 