import '../entities/task.dart';

/// Contract for interacting with tasks. Keeping a dedicated interface makes
/// testing easier and allows substituting different persistence mechanisms.
abstract class TaskRepository {
  Future<List<Task>> getTasks(int userId);
  Future<Task> addTask(Task task);
  Future<void> updateTask(Task task);
  Future<void> deleteTask(int id);
}