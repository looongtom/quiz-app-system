import 'package:quiz_app_flutter/features/data/model/user_model/user_model.dart';
import 'package:quiz_app_flutter/features/domain/enum/role_type.dart';

class UserEntity {
  final int id;
  final String username;
  final String email;
  final RoleType role;

  const UserEntity({
    required this.id,
    required this.username,
    required this.email,
    required this.role,
  });

  factory UserEntity.fromModel(UserModel model) {
    return UserEntity(
      id: model.id ?? 0,
      username: model.username ?? '',
      email: model.email ?? '',
      role: model.roles ?? RoleType.user,
    );
  }

  UserEntity copyWith({
    int? id,
    String? username,
    String? email,
    RoleType? role,
  }) {
    return UserEntity(
      id: id ?? this.id,
      username: username ?? this.username,
      email: email ?? this.email,
      role: role ?? this.role,
    );
  }
}