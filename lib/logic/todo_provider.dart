import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpodtodo/data/models/todo.dart';

class TodoList extends StateNotifier<List<Todo>> {
  TodoList() : super([]);

  void add(Todo todo) => state = [...state, todo];

  void updateStatus(String id, TaskStatus newStatus) {
    state = [
      for (final todo in state)
        if (todo.id == id) todo.copyWith(status: newStatus) else todo,
    ];
  }

  void remove(String id) => state = state.where((t) => t.id != id).toList();

  void updateTodo(Todo updatedTodo) {
    state = [
      for (final todo in state)
        if (todo.id == updatedTodo.id) updatedTodo else todo,
    ];
  }
}

final todoListProvider = StateNotifierProvider<TodoList, List<Todo>>((ref) {
  return TodoList();
});
