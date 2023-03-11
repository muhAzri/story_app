import 'package:equatable/equatable.dart';

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

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['userId'],
      name: json['name'],
      token: json['token'],
    );
  }

  UserModel copywith({
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
