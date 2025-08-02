import 'package:flutter/cupertino.dart';
import 'package:databases/features/home/screens/home_tab.dart';
import 'package:databases/features/home/screens/my_profile_tab.dart';
import 'package:databases/features/home/providers/theme_provider.dart';
import 'package:databases/features/home/constants/app_colors.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;
    
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.person),
            label: 'My Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        backgroundColor: AppColors.getTabBarBackground(isDarkMode),
        activeColor: AppColors.getTabBarActive(isDarkMode),
        inactiveColor: AppColors.getTabBarInactive(isDarkMode),
      ),
      tabBuilder: (context, index) {
        return CupertinoTabView(
          builder: (context) {
            switch (index) {
              case 0:
                return const HomeTab();
              case 1:
                return const MyProfileTab();
              default:
                return const HomeTab();
            }
          },
        );
      },
    );
  }
} 