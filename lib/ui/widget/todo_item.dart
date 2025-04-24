import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:riverpodtodo/core/route/app_navigation.dart';
import 'package:riverpodtodo/data/models/todo.dart';
import 'package:riverpodtodo/logic/todo_provider.dart';
import 'package:riverpodtodo/ui/screen/add_edit_todo_screen.dart';

class TodoItem extends ConsumerWidget {
  final Todo todo;

  const TodoItem({super.key, required this.todo});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Left Section - Task Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    todo.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    todo.taskDetail,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    DateFormat.yMMMd().add_jm().format(todo.dateTime),
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),

            // Right Section - Actions and Status
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: () => AppNavigation.pushTo(
                          AddEditTodoScreen(todo: todo), context),
                      icon: const Icon(Icons.edit),
                      tooltip: 'Edit Task',
                    ),
                    IconButton(
                      onPressed: () => _showDeleteDialog(context, ref, todo.id),
                      icon: const Icon(Icons.delete),
                      tooltip: 'Delete Task',
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Chip(
                  label: Text(
                    todo.status.label,
                    style: const TextStyle(color: Colors.white),
                  ),
                  backgroundColor: _getStatusColor(todo.status),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                ),
                const SizedBox(height: 4),
                DropdownButton<TaskStatus>(
                  value: todo.status,
                  iconSize: 20,
                  isDense: true,
                  underline: const SizedBox(),
                  onChanged: (TaskStatus? newStatus) {
                    if (newStatus != null) {
                      ref
                          .read(todoListProvider.notifier)
                          .updateStatus(todo.id, newStatus);
                    }
                  },
                  items: TaskStatus.values.map((status) {
                    return DropdownMenuItem<TaskStatus>(
                      value: status,
                      child: Row(
                        children: [
                          Icon(
                            _getStatusIcon(status),
                            color: _getStatusColor(status),
                            size: 18,
                          ),
                          const SizedBox(width: 6),
                          Text(status.label),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(TaskStatus status) {
    switch (status) {
      case TaskStatus.pending:
        return Colors.orange[100]!;
      case TaskStatus.inProgress:
        return Colors.blue[100]!;
      case TaskStatus.completed:
        return Colors.green[100]!;
    }
  }

  IconData _getStatusIcon(TaskStatus status) {
    switch (status) {
      case TaskStatus.pending:
        return Icons.access_time;
      case TaskStatus.inProgress:
        return Icons.autorenew;
      case TaskStatus.completed:
        return Icons.check_circle;
    }
  }

  void _showDeleteDialog(BuildContext context, WidgetRef ref, String todoId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Task',
              style: TextStyle(fontWeight: FontWeight.bold)),
          content: const Text('This action cannot be undone. Are you sure?'),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          actions: [
            TextButton(
              style: TextButton.styleFrom(foregroundColor: Colors.grey[600]),
              onPressed: () => Navigator.pop(context),
              child: const Text('CANCEL'),
            ),
            TextButton(
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              onPressed: () {
                ref.read(todoListProvider.notifier).remove(todoId);
                Navigator.pop(context);
              },
              child: const Text('DELETE'),
            ),
          ],
        );
      },
    );
  }
}
