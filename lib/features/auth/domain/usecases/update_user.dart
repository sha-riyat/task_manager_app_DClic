import '../entities/user.dart';
import '../repositories/auth_repository.dart';

/// Use case for updating user profile information. Persists changes in the data
/// layer via [AuthRepository].
class UpdateUserUseCase {
  final AuthRepository repository;
  UpdateUserUseCase(this.repository);

  Future<void> call(User user) async {
    await repository.updateUser(user);
  }
}