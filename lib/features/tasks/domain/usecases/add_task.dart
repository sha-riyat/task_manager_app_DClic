import '../entities/task.dart';
import '../repositories/task_repository.dart';

/// Persists a new [Task] for a user. Returns the task with its newly
/// generated id.
class AddTaskUseCase {
  final TaskRepository repository;
  AddTaskUseCase(this.repository);

  Future<Task> call(Task task) async {
    return await repository.addTask(task);
  }
}