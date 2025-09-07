import 'package:flutter/material.dart';

import '../../../auth/domain/entities/user.dart';
import '../../../auth/domain/repositories/auth_repository.dart';
import '../../../auth/data/repositories/auth_repository_impl.dart';
import '../../../auth/domain/usecases/update_user.dart';
import '../../../auth/domain/usecases/change_password.dart';

/// View model dedicated to profile management. While the [AuthViewModel]
/// maintains the current authenticated user, this class encapsulates the
/// actions for modifying user details and notifying its own listeners. When
/// profile changes succeed the caller should also update the AuthViewModel
/// accordingly so that the UI remains consistent.
class ProfileViewModel extends ChangeNotifier {
  ProfileViewModel({AuthRepository? repository})
      : _repository = repository ?? AuthRepositoryImpl(),
        _updateUserUseCase = UpdateUserUseCase(repository ?? AuthRepositoryImpl()),
        _changePasswordUseCase = ChangePasswordUseCase(repository ?? AuthRepositoryImpl());

  final AuthRepository _repository;
  final UpdateUserUseCase _updateUserUseCase;
  final ChangePasswordUseCase _changePasswordUseCase;

  bool _isUpdating = false;
  String? _error;

  bool get isUpdating => _isUpdating;
  String? get error => _error;

  /// Persists the supplied [user] changes. On success returns normally; on
  /// failure sets [error]. The caller should update its own copy of the user.
  Future<bool> updateProfile(User user) async {
    _setUpdating(true);
    try {
      await _updateUserUseCase(user);
      _error = null;
      _setUpdating(false);
      return true;
    } catch (e) {
      _error = 'Erreur lors de la mise à jour du profil';
      _setUpdating(false);
      return false;
    }
  }

  /// Changes the password for the given user id.
  Future<bool> changePassword(int userId, String newPassword) async {
    _setUpdating(true);
    try {
      await _changePasswordUseCase(userId, newPassword);
      _error = null;
      _setUpdating(false);
      return true;
    } catch (e) {
      _error = 'Erreur lors du changement de mot de passe';
      _setUpdating(false);
      return false;
    }
  }

  void _setUpdating(bool value) {
    _isUpdating = value;
    notifyListeners();
  }
}