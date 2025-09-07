import '../../../../core/db/database_helper.dart';
import '../../domain/entities/task.dart';
import '../../domain/repositories/task_repository.dart';
import '../models/task_model.dart';

/// SQLite backed implementation of [TaskRepository]. This implementation
/// delegates all database operations to [DatabaseHelper] and performs
/// translation between domain entities and data transfer objects.
class TaskRepositoryImpl implements TaskRepository {
  final DatabaseHelper _dbHelper;

  TaskRepositoryImpl({DatabaseHelper? dbHelper}) : _dbHelper = dbHelper ?? DatabaseHelper.instance;

  @override
  Future<Task> addTask(Task task) async {
    final model = TaskModel(
      title: task.title,
      description: task.description,
      status: task.status,
      date: task.date,
      userId: task.userId,
    );
    final id = await _dbHelper.insertTask(model.toMap());
    return task.copyWith(id: id);
  }

  @override
  Future<void> deleteTask(int id) async {
    await _dbHelper.deleteTask(id);
  }

  @override
  Future<List<Task>> getTasks(int userId) async {
    final rows = await _dbHelper.getTasks(userId);
    return rows.map((e) => TaskModel.fromMap(e)).toList();
  }

  @override
  Future<void> updateTask(Task task) async {
    final model = TaskModel(
      id: task.id,
      title: task.title,
      description: task.description,
      status: task.status,
      date: task.date,
      userId: task.userId,
    );
    await _dbHelper.updateTask(model.toMap());
  }
}