import '../../domain/entities/task.dart';

/// Data layer representation of a task. Extends [Task] to reuse fields
/// defined in the domain entity and provide mapping to and from SQLite.
class TaskModel extends Task {
  const TaskModel({
    int? id,
    required String title,
    required String description,
    required String status,
    required DateTime date,
    required int userId,
  }) : super(
          id: id,
          title: title,
          description: description,
          status: status,
          date: date,
          userId: userId,
        );

  factory TaskModel.fromMap(Map<String, dynamic> map) {
    return TaskModel(
      id: map['id'] as int?,
      title: map['title'] as String,
      description: map['description'] as String,
      status: map['status'] as String,
      date: DateTime.parse(map['date'] as String),
      userId: map['user_id'] as int,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'title': title,
      'description': description,
      'status': status,
      'date': date.toIso8601String(),
      'user_id': userId,
    };
  }
}