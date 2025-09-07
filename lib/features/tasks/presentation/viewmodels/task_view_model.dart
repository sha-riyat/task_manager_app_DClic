import 'package:flutter/material.dart';

import '../../domain/entities/task.dart';
import '../../domain/repositories/task_repository.dart';
import '../../data/repositories/task_repository_impl.dart';
import '../../domain/usecases/get_tasks.dart';
import '../../domain/usecases/add_task.dart';
import '../../domain/usecases/update_task.dart';
import '../../domain/usecases/delete_task.dart';

/// View model managing the collection of tasks belonging to the currently
/// authenticated user. Supports adding, updating, deleting, filtering and
/// searching tasks. Calls to the data layer are forwarded through use cases.
class TaskViewModel extends ChangeNotifier {
  TaskViewModel({TaskRepository? repository})
      : _repository = repository ?? TaskRepositoryImpl(),
        _getTasksUseCase = GetTasksUseCase(repository ?? TaskRepositoryImpl()),
        _addTaskUseCase = AddTaskUseCase(repository ?? TaskRepositoryImpl()),
        _updateTaskUseCase = UpdateTaskUseCase(repository ?? TaskRepositoryImpl()),
        _deleteTaskUseCase = DeleteTaskUseCase(repository ?? TaskRepositoryImpl());

  final TaskRepository _repository;
  final GetTasksUseCase _getTasksUseCase;
  final AddTaskUseCase _addTaskUseCase;
  final UpdateTaskUseCase _updateTaskUseCase;
  final DeleteTaskUseCase _deleteTaskUseCase;

  List<Task> _tasks = [];
  bool _isLoading = false;
  String _searchQuery = '';
  String _statusFilter = 'Tout';
  String? _error;
  int? _userId;

  List<Task> get tasks {
    // Apply status filter and search query
    Iterable<Task> filtered = _tasks;
    if (_statusFilter != 'Tout') {
      filtered = filtered.where((t) => t.status == _statusFilter);
    }
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((t) =>
          t.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          t.description.toLowerCase().contains(_searchQuery.toLowerCase()));
    }
    return filtered.toList();
  }

  bool get isLoading => _isLoading;
  String get searchQuery => _searchQuery;
  String get statusFilter => _statusFilter;
  String? get error => _error;

  /// Sets the current user id used to fetch tasks. If the id changes the task
  /// list is refreshed.
  void setUserId(int? id) {
    if (_userId != id) {
      _userId = id;
      if (id != null) {
        loadTasks(id);
      }
    }
  }

  Future<void> loadTasks(int userId) async {
    _setLoading(true);
    try {
      final list = await _getTasksUseCase(userId);
      _tasks = list;
      _error = null;
    } catch (e) {
      _error = 'Impossible de charger les tâches';
    }
    _setLoading(false);
  }

  Future<void> addTask({required String title, required String description, required String status}) async {
    if (_userId == null) return;
    final task = Task(
      title: title,
      description: description,
      status: status,
      date: DateTime.now(),
      userId: _userId!,
    );
    // Persist the task in the database
    await _addTaskUseCase(task);
    // Reload all tasks for the current user. This will set _tasks and notify listeners.
    await loadTasks(_userId!);
    // Reset the status filter to ensure the new task is visible regardless of previous filters.
    _statusFilter = 'Tout';
    notifyListeners();
  }

  Future<void> updateTaskStatus(Task task, String newStatus) async {
    final updated = task.copyWith(status: newStatus);
    await _updateTaskUseCase(updated);
    final index = _tasks.indexWhere((t) => t.id == task.id);
    if (index != -1) {
      _tasks[index] = updated;
      notifyListeners();
    }
  }

  Future<void> updateTask(Task task, {String? title, String? description, String? status}) async {
    final updated = task.copyWith(
      title: title ?? task.title,
      description: description ?? task.description,
      status: status ?? task.status,
      // Update the date to now, indicating modification time. If you want
      // to keep the original creation date, remove this line.
      date: DateTime.now(),
    );
    await _updateTaskUseCase(updated);
    // Reload tasks from the database to ensure the latest values are reflected
    if (_userId != null) {
      await loadTasks(_userId!);
    }
  }

  Future<void> deleteTask(Task task) async {
    if (task.id == null) return;
    await _deleteTaskUseCase(task.id!);
    _tasks.removeWhere((t) => t.id == task.id);
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void setStatusFilter(String status) {
    _statusFilter = status;
    notifyListeners();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}