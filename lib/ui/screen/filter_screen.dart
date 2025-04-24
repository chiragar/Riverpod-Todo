import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpodtodo/data/models/todo.dart';
import 'package:riverpodtodo/logic/filter_providers.dart';

class FilterScreen extends ConsumerWidget {
  const FilterScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filterState = ref.watch(filterProvider);
    final notifier = ref.read(filterProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Filter Tasks'),
        actions: [
          IconButton(
            icon: const Icon(Icons.clear_all),
            onPressed: () => notifier.resetFilters(),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text('Status Filter', style: TextStyle(fontSize: 18)),
          _buildStatusFilter(TaskStatus.pending, filterState, notifier),
          _buildStatusFilter(TaskStatus.inProgress, filterState, notifier),
          _buildStatusFilter(TaskStatus.completed, filterState, notifier),
          const SizedBox(height: 24),
          _buildDateRangePicker(filterState, notifier, context),
        ],
      ),
    );
  }

  Widget _buildStatusFilter(
    TaskStatus status,
    FilterState filterState,
    FilterNotifier notifier,
  ) {
    return CheckboxListTile(
      title: Text(status.label),
      value: filterState.selectedStatuses.contains(status),
      onChanged: (_) => notifier.toggleStatus(status),
    );
  }

  Widget _buildDateRangePicker(
    FilterState filterState,
    FilterNotifier notifier,
    BuildContext context,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Date Range', style: TextStyle(fontSize: 18)),
        const SizedBox(height: 8),
        ListTile(
          title: Text(
            filterState.dateRange == null
                ? 'Select Date Range'
                : '${_formatDate(filterState.dateRange!.start)} - '
                    '${_formatDate(filterState.dateRange!.end)}',
          ),
          trailing: const Icon(Icons.calendar_today),
          onTap: () async {
            final picked = await showDateRangePicker(
              context: context,
              firstDate: DateTime(2000),
              lastDate: DateTime(2100),
              initialDateRange: filterState.dateRange,
            );
            if (picked != null) {
              notifier.setDateRange(picked);
            }
          },
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
