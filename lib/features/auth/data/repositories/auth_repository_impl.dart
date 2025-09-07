import 'package:flutter/foundation.dart';
import '../../../../core/db/database_helper.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../models/user_model.dart';

/// Concrete implementation of [AuthRepository] backed by an SQLite database.
class AuthRepositoryImpl implements AuthRepository {
  final DatabaseHelper _dbHelper;

  AuthRepositoryImpl({DatabaseHelper? dbHelper}) : _dbHelper = dbHelper ?? DatabaseHelper.instance;

  @override
  Future<User> register(User user) async {
    final model = UserModel(
      firstName: user.firstName,
      lastName: user.lastName,
      email: user.email,
      password: user.password,
    );
    try {
      final id = await _dbHelper.insertUser(model.toMap());
      return user.copyWith(id: id);
    } catch (e) {
      // On constraint failure (duplicate email), sqflite throws a specific
      // exception. We rethrow with a more descriptive message.
      debugPrint('Register error: $e');
      throw Exception('Email already in use');
    }
  }

  @override
  Future<User?> login(String email, String password) async {
    final data = await _dbHelper.getUserByEmail(email);
    if (data == null) return null;
    final model = UserModel.fromMap(data);
    if (model.password == password) {
      return model;
    }
    return null;
  }

  @override
  Future<void> updateUser(User user) async {
    final model = UserModel(
      id: user.id,
      firstName: user.firstName,
      lastName: user.lastName,
      email: user.email,
      password: user.password,
    );
    await _dbHelper.updateUser(model.toMap());
  }

  @override
  Future<void> changePassword(int id, String newPassword) async {
    await _dbHelper.updateUserPassword(id, newPassword);
  }
}