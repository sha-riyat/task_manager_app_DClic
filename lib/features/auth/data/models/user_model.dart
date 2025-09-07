import '../../domain/entities/user.dart';

/// Data transfer object representing a user within the data layer.
///
/// This class knows how to serialize to and from a `Map<String, dynamic>`
/// for storing and retrieving users in SQLite.
class UserModel extends User {
  const UserModel({
    int? id,
    required String firstName,
    required String lastName,
    required String email,
    required String password,
  }) : super(
          id: id,
          firstName: firstName,
          lastName: lastName,
          email: email,
          password: password,
        );

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] as int?,
      firstName: map['first_name'] as String,
      lastName: map['last_name'] as String,
      email: map['email'] as String,
      password: map['password'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'password': password,
    };
  }
}