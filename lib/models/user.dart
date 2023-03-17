import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class UserModel extends Equatable {
  final String id;
  final String name;
  final String? email;
  final String? password;
  final String token;

  const UserModel({
    required this.id,
    required this.name,
    required this.token,
    this.email,
    this.password,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  UserModel copyWith({
    String? password,
    String? email,
  }) =>
      UserModel(
        id: id,
        name: name,
        email: email ?? this.email,
        password: password ?? this.password,
        token: token,
      );

  @override
  List<Object?> get props => [id, name, token];
}
