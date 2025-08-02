import 'package:flutter/cupertino.dart';
import 'package:databases/features/home/widgets/welcome_card.dart';
import 'package:databases/features/home/providers/theme_provider.dart';
import 'package:databases/features/home/constants/app_colors.dart';
import 'package:provider/provider.dart';

class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;
    
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: const Text('Home'),
        backgroundColor: AppColors.getBackground(isDarkMode),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Welcome card
              WelcomeCard(
                title: 'Chào mừng về nhà!',
                subtitle: 'Đây là trang chủ của bạn',
                icon: CupertinoIcons.house_fill,
                isDarkMode: isDarkMode,
              ),
              const SizedBox(height: 32),
              // Quick actions
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: CupertinoColors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Quick Actions',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: CupertinoColors.black,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: CupertinoButton(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            color: CupertinoColors.black,
                            borderRadius: BorderRadius.circular(8),
                            onPressed: () {
                              // TODO: Add action
                            },
                            child: const Text(
                              'Action 1',
                              style: TextStyle(
                                color: CupertinoColors.white,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: CupertinoButton(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            color: CupertinoColors.black,
                            borderRadius: BorderRadius.circular(8),
                            onPressed: () {
                              // TODO: Add action
                            },
                            child: const Text(
                              'Action 2',
                              style: TextStyle(
                                color: CupertinoColors.white,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 