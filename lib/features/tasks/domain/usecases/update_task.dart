import '../entities/task.dart';
import '../repositories/task_repository.dart';

/// Saves changes to an existing task.
class UpdateTaskUseCase {
  final TaskRepository repository;
  UpdateTaskUseCase(this.repository);

  Future<void> call(Task task) async {
    await repository.updateTask(task);
  }
}