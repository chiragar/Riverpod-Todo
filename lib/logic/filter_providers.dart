import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpodtodo/data/models/todo.dart';
import 'package:riverpodtodo/logic/todo_provider.dart';

class FilterState {
  final Set<TaskStatus> selectedStatuses;
  final DateTimeRange? dateRange;

  FilterState({
    this.selectedStatuses = const {},
    this.dateRange,
  });

  FilterState copyWith({
    Set<TaskStatus>? selectedStatuses,
    DateTimeRange? dateRange,
  }) {
    return FilterState(
      selectedStatuses: selectedStatuses ?? this.selectedStatuses,
      dateRange: dateRange ?? this.dateRange,
    );
  }
}

class FilterNotifier extends StateNotifier<FilterState> {
  FilterNotifier() : super(FilterState());

  void toggleStatus(TaskStatus status) {
    final newStatuses = Set<TaskStatus>.from(state.selectedStatuses);
    if (newStatuses.contains(status)) {
      newStatuses.remove(status);
    } else {
      newStatuses.add(status);
    }
    state = state.copyWith(selectedStatuses: newStatuses);
  }

  void setDateRange(DateTimeRange? range) {
    state = state.copyWith(dateRange: range);
  }

  void resetFilters() {
    state = FilterState();
  }
}

final filterProvider = StateNotifierProvider<FilterNotifier, FilterState>(
  (ref) => FilterNotifier(),
);

final filteredTodosProvider = Provider<List<Todo>>((ref) {
  final todos = ref.watch(todoListProvider);
  final filter = ref.watch(filterProvider);

  return todos.where((todo) {
    final statusMatch = filter.selectedStatuses.isEmpty ||
        filter.selectedStatuses.contains(todo.status);

    final dateMatch = filter.dateRange == null ||
        (todo.dateTime.isAfter(filter.dateRange!.start) &&
            todo.dateTime.isBefore(filter.dateRange!.end));

    return statusMatch && dateMatch;
  }).toList();
});
