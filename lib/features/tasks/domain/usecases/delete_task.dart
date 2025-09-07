import '../repositories/task_repository.dart';

/// Removes a task by its identifier.
class DeleteTaskUseCase {
  final TaskRepository repository;
  DeleteTaskUseCase(this.repository);

  Future<void> call(int id) async {
    await repository.deleteTask(id);
  }
}