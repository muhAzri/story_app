import 'package:equatable/equatable.dart';

class SignUpFormModel extends Equatable {
  final String email;
  final String name;
  final String password;

  const SignUpFormModel({
    required this.name,
    required this.email,
    required this.password,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'password': password,
    };
  }

  @override
  List<Object?> get props => [
        email,
        name,
        password,
      ];
}
