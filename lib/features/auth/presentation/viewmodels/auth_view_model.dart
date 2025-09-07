import 'package:flutter/material.dart';

import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/usecases/login.dart';
import '../../domain/usecases/register.dart';
import '../../domain/usecases/update_user.dart';
import '../../domain/usecases/change_password.dart';

/// View model responsible for orchestrating authentication flows and exposing
/// user state to the UI. It utilises various use cases defined in the domain
/// layer and notifies listeners when state changes.
class AuthViewModel extends ChangeNotifier {
  AuthViewModel({AuthRepository? repository})
      : _repository = repository ?? AuthRepositoryImpl(),
        _loginUseCase = LoginUseCase(repository ?? AuthRepositoryImpl()),
        _registerUseCase = RegisterUseCase(repository ?? AuthRepositoryImpl()),
        _updateUserUseCase = UpdateUserUseCase(repository ?? AuthRepositoryImpl()),
        _changePasswordUseCase = ChangePasswordUseCase(repository ?? AuthRepositoryImpl());

  final AuthRepository _repository;
  final LoginUseCase _loginUseCase;
  final RegisterUseCase _registerUseCase;
  final UpdateUserUseCase _updateUserUseCase;
  final ChangePasswordUseCase _changePasswordUseCase;

  User? _user;
  bool _isLoading = false;
  String? _error;

  User? get user => _user;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _user != null;

  /// Attempts to authenticate with the given credentials. Returns true if
  /// successful. On failure, [error] will contain a message.
  Future<bool> login(String email, String password) async {
    _setLoading(true);
    _error = null;
    try {
      final result = await _loginUseCase(email, password);
      if (result != null) {
        _user = result;
        _setLoading(false);
        return true;
      } else {
        _error = 'Adresse mail ou mot de passe incorrect';
        _setLoading(false);
        return false;
      }
    } catch (e) {
      _error = e.toString();
      _setLoading(false);
      return false;
    }
  }

  /// Registers a new user. Returns true on success. If the email is taken,
  /// [error] is set to a descriptive message.
  Future<bool> register({required String firstName, required String lastName, required String email, required String password}) async {
    _setLoading(true);
    _error = null;
    try {
      final user = User(firstName: firstName, lastName: lastName, email: email, password: password);
      final created = await _registerUseCase(user);
      _user = created;
      _setLoading(false);
      return true;
    } catch (e) {
      _error = e.toString();
      _setLoading(false);
      return false;
    }
  }

  /// Updates the currently authenticated user's profile details. If the user
  /// isn't authenticated, this call does nothing.
  Future<void> updateProfile({required String firstName, required String lastName, required String email}) async {
    if (_user == null) return;
    final updated = _user!.copyWith(firstName: firstName, lastName: lastName, email: email);
    await _updateUserUseCase(updated);
    _user = updated;
    notifyListeners();
  }

  /// Changes the user's password. Requires the user to be authenticated.
  Future<void> changePassword(String newPassword) async {
    if (_user == null) return;
    await _changePasswordUseCase(_user!.id!, newPassword);
    _user = _user!.copyWith(password: newPassword);
    notifyListeners();
  }

  void logout() {
    _user = null;
    notifyListeners();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}