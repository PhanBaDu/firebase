import 'package:flutter/cupertino.dart';
import 'package:databases/features/todo/models/todo_model.dart';
import 'package:databases/features/home/constants/app_colors.dart';
import 'package:intl/intl.dart';

class TodoItem extends StatelessWidget {
  final Todo todo;
  final VoidCallback onToggle;
  final VoidCallback onDelete;
  final bool isDarkMode;

  const TodoItem({
    super.key,
    required this.todo,
    required this.onToggle,
    required this.onDelete,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.getCardBackground(isDarkMode),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: todo.isCompleted
              ? AppColors.success.withOpacity(0.3)
              : AppColors.getDivider(isDarkMode),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Checkbox
            CupertinoButton(
              padding: EdgeInsets.zero,
              onPressed: onToggle,
              child: Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: todo.isCompleted
                      ? AppColors.success
                      : CupertinoColors.systemBackground,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                    color: todo.isCompleted
                        ? AppColors.success
                        : AppColors.getIconSecondary(isDarkMode),
                    width: 2,
                  ),
                ),
                child: todo.isCompleted
                    ? Icon(
                        CupertinoIcons.checkmark,
                        size: 16,
                        color: CupertinoColors.white,
                      )
                    : null,
              ),
            ),
            const SizedBox(width: 12),
            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    todo.title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.getTextPrimary(isDarkMode),
                      decoration: todo.isCompleted
                          ? TextDecoration.lineThrough
                          : null,
                      decorationColor: AppColors.getTextSecondary(isDarkMode),
                    ),
                  ),
                  if (todo.description.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      todo.description,
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.getTextSecondary(isDarkMode),
                        decoration: todo.isCompleted
                            ? TextDecoration.lineThrough
                            : null,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        CupertinoIcons.time,
                        size: 12,
                        color: AppColors.getTextSecondary(isDarkMode),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        _formatDate(todo.createdAt),
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.getTextSecondary(isDarkMode),
                        ),
                      ),
                      if (todo.isCompleted && todo.completedAt != null) ...[
                        const SizedBox(width: 16),
                        Icon(
                          CupertinoIcons.checkmark_circle_fill,
                          size: 12,
                          color: AppColors.success,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Hoàn thành: ${_formatDate(todo.completedAt!)}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.success,
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            // Delete button
            CupertinoButton(
              padding: EdgeInsets.zero,
              onPressed: onDelete,
              child: Icon(
                CupertinoIcons.delete,
                color: AppColors.error,
                size: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      if (difference.inHours == 0) {
        return '${difference.inMinutes} phút trước';
      }
      return '${difference.inHours} giờ trước';
    } else if (difference.inDays == 1) {
      return 'Hôm qua';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} ngày trước';
    } else {
      return DateFormat('dd/MM/yyyy').format(date);
    }
  }
}
