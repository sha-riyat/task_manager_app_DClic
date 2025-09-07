import '../entities/task.dart';
import '../repositories/task_repository.dart';

/// Retrieves all tasks for a given user id. Tasks are returned sorted by
/// descending date (newest first).
class GetTasksUseCase {
  final TaskRepository repository;
  GetTasksUseCase(this.repository);

  Future<List<Task>> call(int userId) async {
    return await repository.getTasks(userId);
  }
}