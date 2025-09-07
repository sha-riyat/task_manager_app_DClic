import '../entities/user.dart';
import '../repositories/auth_repository.dart';

/// Use case responsible for logging in a user. It delegates the actual
/// authentication to the [AuthRepository] interface.
class LoginUseCase {
  final AuthRepository repository;
  LoginUseCase(this.repository);

  Future<User?> call(String email, String password) async {
    return await repository.login(email, password);
  }
}