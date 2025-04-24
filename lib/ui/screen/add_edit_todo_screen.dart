import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:riverpodtodo/core/utils/app_utils.dart';
import 'package:riverpodtodo/data/models/todo.dart';
import 'package:riverpodtodo/logic/todo_provider.dart';

class AddEditTodoScreen extends ConsumerStatefulWidget {
  final Todo? todo;

  const AddEditTodoScreen({super.key, this.todo});

  @override
  ConsumerState<AddEditTodoScreen> createState() => _AddEditTodoScreenState();
}

class _AddEditTodoScreenState extends ConsumerState<AddEditTodoScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _detailController;
  late DateTime _selectedDate;
  late TimeOfDay _selectedTime;
  late TaskStatus _selectedStatus;
  @override
  void initState() {
    super.initState();
    final todo = widget.todo;
    if (todo != null) {
      _nameController = TextEditingController(text: todo.name);
      _detailController = TextEditingController(text: todo.taskDetail);
      _selectedDate = todo.dateTime;
      _selectedTime = TimeOfDay.fromDateTime(todo.dateTime);
      _selectedStatus = widget.todo?.status ?? TaskStatus.pending;
    } else {
      _nameController = TextEditingController();
      _detailController = TextEditingController();
      _selectedDate = DateTime.now();
      _selectedTime = TimeOfDay.now();
      _selectedStatus = TaskStatus.pending;
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
      setState(() => _selectedDate = pickedDate);
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final pickedTime = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (pickedTime != null) {
      setState(() => _selectedTime = pickedTime);
    }
  }

  void _saveTodo() {
    if (_formKey.currentState!.validate()) {
      final dateTime = DateTime(
        _selectedDate.year,
        _selectedDate.month,
        _selectedDate.day,
        _selectedTime.hour,
        _selectedTime.minute,
      );

      final todo = Todo(
        id: widget.todo?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
        name: _nameController.text,
        taskDetail: _detailController.text,
        dateTime: dateTime,
        status: _selectedStatus,
      );

      if (widget.todo == null) {
        ref.read(todoListProvider.notifier).add(todo);
        showNativeToast("Record Add Successfully");
      } else {
        ref.read(todoListProvider.notifier).updateTodo(todo);
        showNativeToast("Record Edit Successfully");
      }

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.todo == null ? 'Add Todo' : 'Edit Todo'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              const SizedBox(height: 20),

              // Task Name
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  hintText: 'Task Name',
                ),
                validator: (value) => value!.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),

              // Task Details
              TextFormField(
                controller: _detailController,
                decoration: const InputDecoration(
                  hintText: 'Task Details',
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 20),

              // Date Picker
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Date: ${DateFormat.yMMMd().format(_selectedDate)}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  TextButton.icon(
                    onPressed: () => _selectDate(context),
                    icon: const Icon(Icons.calendar_today, size: 18),
                    label: const Text('Select Date'),
                  ),
                ],
              ),

              // Time Picker
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Time: ${_selectedTime.format(context)}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  TextButton.icon(
                    onPressed: () => _selectTime(context),
                    icon: const Icon(Icons.access_time, size: 18),
                    label: const Text('Select Time'),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Status Dropdown
              _buildStatusDropdown(),
              const SizedBox(height: 24),

              // Save Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _saveTodo,
                  icon: const Icon(Icons.check),
                  label: const Text('Save Task'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    textStyle: const TextStyle(fontSize: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusDropdown() {
    return DropdownButtonFormField<TaskStatus>(
      value: _selectedStatus,
      decoration: const InputDecoration(hintText: 'Status'),
      items: TaskStatus.values.map((status) {
        return DropdownMenuItem<TaskStatus>(
          value: status,
          child: Text(status.label),
        );
      }).toList(),
      onChanged: (value) {
        if (value != null) {
          setState(() => _selectedStatus = value);
        }
      },
    );
  }
}
