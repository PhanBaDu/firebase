import 'package:databases/features/authentication/services/auth_service.dart';
import 'package:databases/features/authentication/screens/reset_password_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:databases/features/home/providers/theme_provider.dart';
import 'package:databases/features/home/constants/app_colors.dart';
import 'package:provider/provider.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isLoading = false;
  bool _isSignUp = true; // Toggle between sign up and sign in
  String? _errorMessage;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _clearError() {
    if (_errorMessage != null) {
      setState(() {
        _errorMessage = null;
      });
    }
  }

  bool _validateInputs() {
    if (_emailController.text.trim().isEmpty) {
      setState(() {
        _errorMessage = 'Vui lòng nhập email';
      });
      return false;
    }

    if (!RegExp(
      r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
    ).hasMatch(_emailController.text.trim())) {
      setState(() {
        _errorMessage = 'Email không hợp lệ';
      });
      return false;
    }

    if (_passwordController.text.isEmpty) {
      setState(() {
        _errorMessage = 'Vui lòng nhập mật khẩu';
      });
      return false;
    }

    if (_passwordController.text.length < 6) {
      setState(() {
        _errorMessage = 'Mật khẩu phải có ít nhất 6 ký tự';
      });
      return false;
    }

    return true;
  }

  // Method để xử lý lỗi credential và thử lại
  Future<void> _handleCredentialError() async {
    try {
      // Thử refresh token trước
      await AuthService().refreshToken();

      // Nếu vẫn lỗi, thử đăng nhập lại
      await AuthService().signIn(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      // Không cần navigate thủ công vì AuthWrapper sẽ tự động chuyển hướng
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage =
              'Không thể khôi phục phiên đăng nhập. Vui lòng đăng nhập lại';
        });
      }
    }
  }

  void _handleAuth() async {
    _clearError();

    if (!_validateInputs()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      if (_isSignUp) {
        await AuthService().createAccount(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        );
      } else {
        await AuthService().signIn(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        );
      }

      // Không cần navigate thủ công vì AuthWrapper sẽ tự động chuyển hướng
      // Chỉ cần đảm bảo loading state được reset
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      switch (e.code) {
        case 'weak-password':
          errorMessage = 'Mật khẩu quá yếu';
          break;
        case 'email-already-in-use':
          errorMessage = 'Email đã được sử dụng';
          break;
        case 'user-not-found':
          errorMessage = 'Không tìm thấy tài khoản với email này';
          break;
        case 'wrong-password':
          errorMessage = 'Mật khẩu không đúng';
          break;
        case 'invalid-email':
          errorMessage = 'Email không hợp lệ';
          break;
        case 'invalid-credential':
          errorMessage =
              'Thông tin đăng nhập không hợp lệ hoặc đã hết hạn. Vui lòng thử lại';
          // Tự động thử khôi phục credential
          _handleCredentialError();
          return;
          break;
        case 'user-disabled':
          errorMessage = 'Tài khoản đã bị vô hiệu hóa';
          break;
        case 'operation-not-allowed':
          errorMessage = 'Phương thức đăng nhập này không được phép';
          break;
        case 'network-request-failed':
          errorMessage = 'Lỗi kết nối mạng. Vui lòng kiểm tra kết nối internet';
          break;
        case 'too-many-requests':
          errorMessage = 'Quá nhiều yêu cầu. Vui lòng thử lại sau';
          break;
        case 'requires-recent-login':
          errorMessage = 'Yêu cầu đăng nhập lại để thực hiện thao tác này';
          break;
        default:
          errorMessage = 'Đã xảy ra lỗi: ${e.message}';
      }

      if (mounted) {
        setState(() {
          _errorMessage = errorMessage;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Đã xảy ra lỗi không xác định';
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;

    return CupertinoPageScaffold(
      backgroundColor: AppColors.getBackground(isDarkMode),
      navigationBar: null,
      child: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight:
                    MediaQuery.of(context).size.height -
                    MediaQuery.of(context).padding.top -
                    MediaQuery.of(context).padding.bottom -
                    48,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 32),
                  // Title
                  Text(
                    _isSignUp ? 'Đăng ký' : 'Đăng nhập',
                    style: TextStyle(
                      color: AppColors.getTextPrimary(isDarkMode),
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  // Error Message
                  if (_errorMessage != null) ...[
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: CupertinoColors.systemRed.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: CupertinoColors.systemRed.withOpacity(0.3),
                        ),
                      ),
                      child: Text(
                        _errorMessage!,
                        style: const TextStyle(
                          color: CupertinoColors.systemRed,
                          fontSize: 14,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                  // Email Input
                  CupertinoTextField(
                    controller: _emailController,
                    placeholder: 'Email',
                    keyboardType: TextInputType.emailAddress,
                    autocorrect: false,
                    enableSuggestions: false,
                    onChanged: (_) => _clearError(),
                    decoration: BoxDecoration(
                      color: CupertinoColors.systemGrey6,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    style: const TextStyle(
                      color: CupertinoColors.black,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Password Input
                  CupertinoTextField(
                    controller: _passwordController,
                    placeholder: 'Mật khẩu',
                    obscureText: !_isPasswordVisible,
                    enableSuggestions: false,
                    autocorrect: false,
                    onChanged: (_) => _clearError(),
                    decoration: BoxDecoration(
                      color: CupertinoColors.systemGrey6,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    style: const TextStyle(
                      color: CupertinoColors.black,
                      fontSize: 14,
                    ),
                    suffix: CupertinoButton(
                      padding: const EdgeInsets.only(right: 8),
                      child: Icon(
                        _isPasswordVisible
                            ? CupertinoIcons.eye_slash
                            : CupertinoIcons.eye,
                        color: CupertinoColors.systemGrey,
                        size: 20,
                      ),
                      onPressed: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 32),
                  // Auth Button
                  CupertinoButton(
                    onPressed: _isLoading ? null : _handleAuth,
                    color: AppColors.getButtonPrimary(isDarkMode),
                    borderRadius: BorderRadius.circular(8),
                    padding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 16,
                    ),
                    child: _isLoading
                        ? CupertinoActivityIndicator(
                            color: AppColors.getButtonText(isDarkMode),
                          )
                        : Text(
                            _isSignUp ? 'Đăng ký' : 'Đăng nhập',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppColors.getButtonText(isDarkMode),
                            ),
                          ),
                  ),
                  const SizedBox(height: 16),
                  // Toggle between sign up and sign in
                  CupertinoButton(
                    onPressed: _isLoading
                        ? null
                        : () {
                            setState(() {
                              _isSignUp = !_isSignUp;
                              _clearError();
                            });
                          },
                    child: Text(
                      _isSignUp
                          ? 'Đã có tài khoản? Đăng nhập'
                          : 'Chưa có tài khoản? Đăng ký',
                      style: TextStyle(
                        color: AppColors.getTextPrimary(isDarkMode),
                        fontSize: 12,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Forgot Password
                  CupertinoButton(
                    onPressed: _isLoading
                        ? null
                        : () {
                            Navigator.of(context).push(
                              CupertinoPageRoute(
                                builder: (context) =>
                                    const ResetPasswordScreen(),
                              ),
                            );
                          },
                    child: Text(
                      'Quên mật khẩu?',
                      style: TextStyle(
                        color: AppColors.getTextPrimary(isDarkMode),
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
