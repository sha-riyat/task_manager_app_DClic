/// Domain representation of a task belonging to a user.
class Task {
  final int? id;
  final String title;
  final String description;
  final String status; // e.g. 'A faire', 'En cours', 'Fait'
  final DateTime date;
  final int userId;

  const Task({
    this.id,
    required this.title,
    required this.description,
    required this.status,
    required this.date,
    required this.userId,
  });

  Task copyWith({
    int? id,
    String? title,
    String? description,
    String? status,
    DateTime? date,
    int? userId,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      status: status ?? this.status,
      date: date ?? this.date,
      userId: userId ?? this.userId,
    );
  }
}