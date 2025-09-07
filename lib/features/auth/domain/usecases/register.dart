import '../entities/user.dart';
import '../repositories/auth_repository.dart';

/// Use case for creating a new account. On success returns the created user
/// with an assigned id. Throws if the email is taken.
class RegisterUseCase {
  final AuthRepository repository;
  RegisterUseCase(this.repository);

  Future<User> call(User user) async {
    return await repository.register(user);
  }
}