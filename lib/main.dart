import 'package:databases/features/authentication/index.dart';
import 'package:databases/features/home/screens/home_screen.dart';
import 'package:databases/features/home/providers/theme_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          final isDarkMode = themeProvider.isDarkMode;
          return CupertinoApp(
            title: 'Flutter Demo',
            home: const AuthWrapper(),
            theme: CupertinoThemeData(
              brightness: isDarkMode ? Brightness.dark : Brightness.light,
              primaryColor: isDarkMode ? CupertinoColors.white : CupertinoColors.black,
              scaffoldBackgroundColor: isDarkMode 
                  ? CupertinoColors.black 
                  : CupertinoColors.white,
            ),
          );
        },
      ),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;
    
    return StreamBuilder<User?>(
      stream: AuthService().authStateChanges,
      builder: (context, snapshot) {
        // Hiển thị loading khi đang kiểm tra trạng thái auth
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CupertinoPageScaffold(
            backgroundColor: isDarkMode ? CupertinoColors.black : CupertinoColors.white,
            child: Center(
              child: CupertinoActivityIndicator(
                color: isDarkMode ? CupertinoColors.white : CupertinoColors.black,
              ),
            ),
          );
        }

        // Nếu có user đã đăng nhập, chuyển đến HomeScreen
        if (snapshot.hasData && snapshot.data != null) {
          return const HomeScreen();
        }

        // Nếu không có user, chuyển đến AuthScreen
        return const AuthScreen();
      },
    );
  }
}
