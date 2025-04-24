import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpodtodo/core/route/app_navigation.dart';
import 'package:riverpodtodo/data/models/todo.dart';
import 'package:riverpodtodo/logic/todo_provider.dart';
import 'package:riverpodtodo/ui/screen/filter_screen.dart';
import 'package:riverpodtodo/ui/widget/todo_item.dart';

import 'add_edit_todo_screen.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todos = ref.watch(todoListProvider);

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Todo List'),
          actions: [
            IconButton(
              icon: const Icon(Icons.filter_list),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const FilterScreen()),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () =>
                  AppNavigation.pushTo(const AddEditTodoScreen(), context),
            ),
          ],
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Pending'),
              Tab(text: 'In Progress'),
              Tab(text: 'Completed'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildTodoList(
                todos.where((t) => t.status == TaskStatus.pending).toList()),
            _buildTodoList(
                todos.where((t) => t.status == TaskStatus.inProgress).toList()),
            _buildTodoList(
                todos.where((t) => t.status == TaskStatus.completed).toList()),
          ],
        ),
      ),
    );
  }

  Widget _buildTodoList(List<Todo> todos) {
    return todos.isEmpty
        ? const Center(child: Text('No tasks found'))
        : ListView.builder(
            itemCount: todos.length,
            itemBuilder: (context, index) => TodoItem(todo: todos[index]),
          );
  }
}
