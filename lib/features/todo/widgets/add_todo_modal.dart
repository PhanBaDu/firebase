import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:databases/features/todo/providers/todo_provider.dart';
import 'package:databases/features/home/providers/theme_provider.dart';
import 'package:databases/features/home/constants/app_colors.dart';

class AddTodoModal extends StatefulWidget {
  const AddTodoModal({super.key});

  @override
  State<AddTodoModal> createState() => _AddTodoModalState();
}

class _AddTodoModalState extends State<AddTodoModal> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
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
    if (_titleController.text.trim().isEmpty) {
      setState(() {
        _errorMessage = 'Vui lòng nhập tiêu đề';
      });
      return false;
    }
    return true;
  }

  Future<void> _addTodo() async {
    _clearError();

    if (!_validateInputs()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await context.read<TodoProvider>().addTodo(
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
      );

      if (mounted) {
        Navigator.of(context).pop();
      }
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
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
        middle: const Text('Thêm Todo'),
        backgroundColor: AppColors.getBackground(isDarkMode),
        leading: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Hủy'),
        ),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: _isLoading ? null : _addTodo,
          child: _isLoading
              ? const CupertinoActivityIndicator()
              : const Text('Thêm'),
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
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
                  ),
                ),
                const SizedBox(height: 16),
              ],
              // Title Input
              Text(
                'Tiêu đề *',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.getTextPrimary(isDarkMode),
                ),
              ),
              const SizedBox(height: 8),
              CupertinoTextField(
                controller: _titleController,
                placeholder: 'Nhập tiêu đề todo',
                onChanged: (_) => _clearError(),
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
              const SizedBox(height: 24),
              // Description Input
              Text(
                'Mô tả',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.getTextPrimary(isDarkMode),
                ),
              ),
              const SizedBox(height: 8),
              CupertinoTextField(
                controller: _descriptionController,
                placeholder: 'Nhập mô tả (tùy chọn)',
                maxLines: 4,
                onChanged: (_) => _clearError(),
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
              const Spacer(),
              // Add Button
              CupertinoButton(
                onPressed: _isLoading ? null : _addTodo,
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
                        'Thêm Todo',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.getButtonText(isDarkMode),
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