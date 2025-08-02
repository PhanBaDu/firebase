import 'package:flutter/cupertino.dart';
import 'package:databases/features/authentication/services/auth_service.dart';
import 'package:databases/features/home/providers/theme_provider.dart';
import 'package:databases/features/home/constants/app_colors.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final TextEditingController _currentPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  
  bool _isLoading = false;
  bool _showCurrentPassword = false;
  bool _showNewPassword = false;
  bool _showConfirmPassword = false;
  String? _errorMessage;
  String? _successMessage;

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
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

  bool _validateInputs() {
    if (_currentPasswordController.text.trim().isEmpty) {
      setState(() {
        _errorMessage = 'Vui lòng nhập mật khẩu hiện tại';
      });
      return false;
    }

    if (_newPasswordController.text.trim().isEmpty) {
      setState(() {
        _errorMessage = 'Vui lòng nhập mật khẩu mới';
      });
      return false;
    }

    if (_newPasswordController.text.length < 6) {
      setState(() {
        _errorMessage = 'Mật khẩu mới phải có ít nhất 6 ký tự';
      });
      return false;
    }

    if (_confirmPasswordController.text.trim().isEmpty) {
      setState(() {
        _errorMessage = 'Vui lòng xác nhận mật khẩu mới';
      });
      return false;
    }

    if (_newPasswordController.text != _confirmPasswordController.text) {
      setState(() {
        _errorMessage = 'Mật khẩu xác nhận không khớp';
      });
      return false;
    }

    if (_currentPasswordController.text == _newPasswordController.text) {
      setState(() {
        _errorMessage = 'Mật khẩu mới không được trùng với mật khẩu hiện tại';
      });
      return false;
    }

    return true;
  }

  Future<void> _handleChangePassword() async {
    _clearMessages();

    if (!_validateInputs()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final user = AuthService().currentUser;
      if (user?.email == null) {
        throw FirebaseAuthException(
          code: 'user-not-found',
          message: 'Không tìm thấy thông tin người dùng',
        );
      }
      
      await AuthService().resetPasswordFromCurrentPassword(
        currentPassword: _currentPasswordController.text.trim(),
        email: user!.email!,
        newPassword: _newPasswordController.text.trim(),
      );
      
      setState(() {
        _successMessage = 'Đổi mật khẩu thành công!';
      });
      
      // Clear all inputs after success
      _currentPasswordController.clear();
      _newPasswordController.clear();
      _confirmPasswordController.clear();
      
      // Auto navigate back after 2 seconds
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          Navigator.of(context).pop();
        }
      });
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      switch (e.code) {
        case 'wrong-password':
          errorMessage = 'Mật khẩu hiện tại không đúng';
          break;
        case 'weak-password':
          errorMessage = 'Mật khẩu mới quá yếu';
          break;
        case 'requires-recent-login':
          errorMessage = 'Vui lòng đăng nhập lại để thực hiện thao tác này';
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
        middle: const Text('Đổi mật khẩu'),
        backgroundColor: AppColors.getBackground(isDarkMode),
        leading: CupertinoNavigationBarBackButton(
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 32),
                // Icon
                Icon(
                  CupertinoIcons.lock_shield,
                  size: 80,
                  color: AppColors.getIconPrimary(isDarkMode),
                ),
                const SizedBox(height: 32),
                // Title
                Text(
                  'Đổi mật khẩu',
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
                  'Nhập mật khẩu hiện tại và mật khẩu mới',
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
                // Current Password Input
                CupertinoTextField(
                  controller: _currentPasswordController,
                  placeholder: 'Mật khẩu hiện tại',
                  obscureText: !_showCurrentPassword,
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
                  suffix: CupertinoButton(
                    padding: EdgeInsets.zero,
                    onPressed: () {
                      setState(() {
                        _showCurrentPassword = !_showCurrentPassword;
                      });
                    },
                    child: Icon(
                      _showCurrentPassword ? CupertinoIcons.eye_slash : CupertinoIcons.eye,
                      color: AppColors.getIconSecondary(isDarkMode),
                      size: 20,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // New Password Input
                CupertinoTextField(
                  controller: _newPasswordController,
                  placeholder: 'Mật khẩu mới',
                  obscureText: !_showNewPassword,
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
                  suffix: CupertinoButton(
                    padding: EdgeInsets.zero,
                    onPressed: () {
                      setState(() {
                        _showNewPassword = !_showNewPassword;
                      });
                    },
                    child: Icon(
                      _showNewPassword ? CupertinoIcons.eye_slash : CupertinoIcons.eye,
                      color: AppColors.getIconSecondary(isDarkMode),
                      size: 20,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // Confirm Password Input
                CupertinoTextField(
                  controller: _confirmPasswordController,
                  placeholder: 'Xác nhận mật khẩu mới',
                  obscureText: !_showConfirmPassword,
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
                  suffix: CupertinoButton(
                    padding: EdgeInsets.zero,
                    onPressed: () {
                      setState(() {
                        _showConfirmPassword = !_showConfirmPassword;
                      });
                    },
                    child: Icon(
                      _showConfirmPassword ? CupertinoIcons.eye_slash : CupertinoIcons.eye,
                      color: AppColors.getIconSecondary(isDarkMode),
                      size: 20,
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                // Change Password Button
                CupertinoButton(
                  onPressed: _isLoading ? null : _handleChangePassword,
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
                          'Đổi mật khẩu',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.getButtonText(isDarkMode),
                          ),
                        ),
                ),
                const SizedBox(height: 16),
                // Cancel Button
                CupertinoButton(
                  onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
                  child: Text(
                    'Hủy',
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
    );
  }
} 