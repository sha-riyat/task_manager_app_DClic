import '../repositories/auth_repository.dart';

/// Use case for changing a user’s password.
class ChangePasswordUseCase {
  final AuthRepository repository;
  ChangePasswordUseCase(this.repository);

  Future<void> call(int userId, String newPassword) async {
    await repository.changePassword(userId, newPassword);
  }
}