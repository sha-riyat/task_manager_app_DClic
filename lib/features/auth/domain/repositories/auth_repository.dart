import '../entities/user.dart';

/// Abstract repository that defines the contract for authenticating users.
///
/// Implementations of this interface live in the data layer and talk to
/// SQLite via [DatabaseHelper]. The view models depend on this abstraction
/// rather than on concrete implementations directly, making the code easier
/// to test and swap out in the future.
abstract class AuthRepository {
  /// Attempts to register a new [User] and returns the created instance on
  /// success. Throws if the email is already taken.
  Future<User> register(User user);

  /// Attempts to authenticate the user by email and password. Returns the
  /// authenticated [User] or `null` if authentication fails.
  Future<User?> login(String email, String password);

  /// Persists an updated [User] record.
  Future<void> updateUser(User user);

  /// Updates the password for the given user id.
  Future<void> changePassword(int id, String newPassword);
}