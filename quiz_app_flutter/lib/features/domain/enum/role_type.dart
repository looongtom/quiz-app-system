import 'package:freezed_annotation/freezed_annotation.dart';

@JsonEnum(valueField: 'value')
enum RoleType {
  admin('ROLE_ADMIN'),
  user('ROLE_USER');

  const RoleType(this.value);

  final String value;
}
