import 'package:flutter/cupertino.dart';
import 'package:databases/features/authentication/services/auth_service.dart';
import 'package:databases/features/home/providers/theme_provider.dart';
import 'package:databases/features/home/constants/app_colors.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;
  String? _successMessage;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _clearMessages() {
    if (_errorMessage != null || _successMessage != null) {
      setState(() {
        _errorMessage = null;
        _successMessage = null;
      });
    }
  }

  bool _validateEmail() {
    if (_emailController.text.trim().isEmpty) {
      setState(() {
        _errorMessage = 'Vui lòng nhập email';
      });
      return false;
    }

    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(_emailController.text.trim())) {
      setState(() {
        _errorMessage = 'Email không hợp lệ';
      });
      return false;
    }

    return true;
  }

  Future<void> _handleResetPassword() async {
    _clearMessages();

    if (!_validateEmail()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await AuthService().resetPassword(email: _emailController.text.trim());
      
      setState(() {
        _successMessage = 'Email reset password đã được gửi. Vui lòng kiểm tra hộp thư của bạn.';
      });
      
      // Clear email input after success
      _emailController.clear();
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      switch (e.code) {
        case 'invalid-email':
          errorMessage = 'Email không hợp lệ';
          break;
        case 'user-not-found':
          errorMessage = 'Không tìm thấy tài khoản với email này';
          break;
        case 'too-many-requests':
          errorMessage = 'Quá nhiều yêu cầu. Vui lòng thử lại sau';
          break;
        case 'network-request-failed':
          errorMessage = 'Lỗi kết nối mạng. Vui lòng kiểm tra internet';
          break;
        default:
          errorMessage = 'Đã xảy ra lỗi: ${e.message}';
      }

      setState(() {
        _errorMessage = errorMessage;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Đã xảy ra lỗi không xác định';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;

    return CupertinoPageScaffold(
      backgroundColor: AppColors.getBackground(isDarkMode),
      navigationBar: CupertinoNavigationBar(
        middle: const Text('Quên mật khẩu'),
        backgroundColor: AppColors.getBackground(isDarkMode),
        leading: CupertinoNavigationBarBackButton(
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height -
                    MediaQuery.of(context).padding.top -
                    MediaQuery.of(context).padding.bottom -
                    48,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 32),
                  // Icon
                  Icon(
                    CupertinoIcons.lock_rotation,
                    size: 80,
                    color: AppColors.getIconPrimary(isDarkMode),
                  ),
                  const SizedBox(height: 32),
                  // Title
                  Text(
                    'Đặt lại mật khẩu',
                    style: TextStyle(
                      color: AppColors.getTextPrimary(isDarkMode),
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  // Description
                  Text(
                    'Nhập email của bạn để nhận link đặt lại mật khẩu',
                    style: TextStyle(
                      color: AppColors.getTextSecondary(isDarkMode),
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  // Success Message
                  if (_successMessage != null) ...[
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.success.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: AppColors.success.withOpacity(0.3),
                        ),
                      ),
                      child: Text(
                        _successMessage!,
                        style: const TextStyle(
                          color: AppColors.success,
                          fontSize: 14,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                  // Error Message
                  if (_errorMessage != null) ...[
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.error.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: AppColors.error.withOpacity(0.3),
                        ),
                      ),
                      child: Text(
                        _errorMessage!,
                        style: const TextStyle(
                          color: AppColors.error,
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
                    onChanged: (_) => _clearMessages(),
                    decoration: BoxDecoration(
                      color: AppColors.getCardBackground(isDarkMode),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    style: TextStyle(
                      color: AppColors.getTextPrimary(isDarkMode),
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 32),
                  // Reset Password Button
                  CupertinoButton(
                    onPressed: _isLoading ? null : _handleResetPassword,
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
                            'Gửi email reset password',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppColors.getButtonText(isDarkMode),
                            ),
                          ),
                  ),
                  const SizedBox(height: 16),
                  // Back to Login
                  CupertinoButton(
                    onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
                    child: Text(
                      'Quay lại đăng nhập',
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