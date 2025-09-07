/// Immutable representation of an application user.
///
/// The domain entity differs from the database model in that it doesn’t
/// necessarily map one‑to‑one to the underlying SQLite schema. In this
/// application however it is fairly close, containing optional id (to allow
/// creation of new users) and the required personal details.
class User {
  final int? id;
  final String firstName;
  final String lastName;
  final String email;
  final String password;

  const User({
    this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.password,
  });

  User copyWith({
    int? id,
    String? firstName,
    String? lastName,
    String? email,
    String? password,
  }) {
    return User(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      password: password ?? this.password,
    );
  }
}