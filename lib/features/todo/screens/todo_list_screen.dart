import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:databases/features/todo/providers/todo_provider.dart';
import 'package:databases/features/todo/models/todo_model.dart';
import 'package:databases/features/todo/widgets/todo_item.dart';
import 'package:databases/features/todo/widgets/add_todo_modal.dart';
import 'package:databases/features/home/providers/theme_provider.dart';
import 'package:databases/features/home/constants/app_colors.dart';

class TodoListScreen extends StatefulWidget {
  const TodoListScreen({super.key});

  @override
  State<TodoListScreen> createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  @override
  void initState() {
    super.initState();
    // Initialize todo provider when screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TodoProvider>().initialize();
    });
  }

  void _showAddTodoModal() {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => const AddTodoModal(),
    );
  }

  void _showDeleteCompletedDialog() {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('Xóa tất cả đã hoàn thành'),
        content: const Text('Bạn có chắc chắn muốn xóa tất cả các todo đã hoàn thành?'),
        actions: [
          CupertinoDialogAction(
            child: const Text('Hủy'),
            onPressed: () => Navigator.pop(context),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            child: const Text('Xóa'),
            onPressed: () {
              Navigator.pop(context);
              context.read<TodoProvider>().deleteCompletedTodos();
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;
    final todoProvider = Provider.of<TodoProvider>(context);

    return CupertinoPageScaffold(
      backgroundColor: AppColors.getBackground(isDarkMode),
      navigationBar: CupertinoNavigationBar(
        middle: const Text('Realtime Database Todo'),
        backgroundColor: AppColors.getBackground(isDarkMode),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: _showAddTodoModal,
          child: const Icon(CupertinoIcons.add),
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            // Database Info
            Container(
              padding: const EdgeInsets.all(12),
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.getButtonPrimary(isDarkMode).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: AppColors.getButtonPrimary(isDarkMode).withOpacity(0.3),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    CupertinoIcons.bolt,
                    color: AppColors.getButtonPrimary(isDarkMode),
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Realtime Database',
                    style: TextStyle(
                      color: AppColors.getButtonPrimary(isDarkMode),
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            // Stats Section
            Container(
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.getCardBackground(isDarkMode),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStatItem(
                    'Tổng cộng',
                    todoProvider.totalTodos.toString(),
                    CupertinoIcons.list_bullet,
                    isDarkMode,
                  ),
                  _buildStatItem(
                    'Đã hoàn thành',
                    todoProvider.completedCount.toString(),
                    CupertinoIcons.checkmark_circle,
                    isDarkMode,
                  ),
                  _buildStatItem(
                    'Chưa hoàn thành',
                    todoProvider.pendingCount.toString(),
                    CupertinoIcons.clock,
                    isDarkMode,
                  ),
                ],
              ),
            ),
            // Actions Section
            if (todoProvider.completedCount > 0) ...[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: CupertinoButton(
                  color: AppColors.error,
                  onPressed: _showDeleteCompletedDialog,
                  child: const Text('Xóa tất cả đã hoàn thành'),
                ),
              ),
              const SizedBox(height: 16),
            ],
            // Todo List
            Expanded(
              child: todoProvider.isLoading
                  ? const Center(
                      child: CupertinoActivityIndicator(),
                    )
                  : todoProvider.todos.isEmpty
                      ? _buildEmptyState(isDarkMode)
                      : _buildTodoList(todoProvider, isDarkMode),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon, bool isDarkMode) {
    return Column(
      children: [
        Icon(
          icon,
          color: AppColors.getIconPrimary(isDarkMode),
          size: 24,
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.getTextPrimary(isDarkMode),
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: AppColors.getTextSecondary(isDarkMode),
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState(bool isDarkMode) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            CupertinoIcons.checkmark_circle,
            size: 80,
            color: AppColors.getIconSecondary(isDarkMode),
          ),
          const SizedBox(height: 16),
          Text(
            'Chưa có todo nào',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.getTextPrimary(isDarkMode),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Nhấn + để thêm todo mới',
            style: TextStyle(
              fontSize: 16,
              color: AppColors.getTextSecondary(isDarkMode),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTodoList(TodoProvider todoProvider, bool isDarkMode) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: todoProvider.todos.length,
      itemBuilder: (context, index) {
        final todo = todoProvider.todos[index];
        return TodoItem(
          todo: todo,
          onToggle: () => todoProvider.toggleTodoCompletion(todo),
          onDelete: () => todoProvider.deleteTodo(todo.id),
          isDarkMode: isDarkMode,
        );
      },
    );
  }
} 