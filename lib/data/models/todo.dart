import 'package:equatable/equatable.dart';

enum TaskStatus {
  pending('Pending'),
  inProgress('In Progress'),
  completed('Completed');

  final String label;
  const TaskStatus(this.label);
}

class Todo extends Equatable {
  final String id;
  final String name;
  final String taskDetail;
  final DateTime dateTime;
  final TaskStatus status;

  const Todo({
    required this.id,
    required this.name,
    required this.taskDetail,
    required this.dateTime,
    required this.status,
  });

  @override
  List<Object> get props => [id, name, taskDetail, dateTime, status];

  Todo copyWith({
    String? id,
    String? name,
    String? taskDetail,
    DateTime? dateTime,
    TaskStatus? status,
  }) {
    return Todo(
      id: id ?? this.id,
      name: name ?? this.name,
      taskDetail: taskDetail ?? this.taskDetail,
      dateTime: dateTime ?? this.dateTime,
      status: status ?? this.status,
    );
  }
}
