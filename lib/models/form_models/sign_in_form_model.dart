import 'package:equatable/equatable.dart';

import 'package:json_annotation/json_annotation.dart';

part 'sign_in_form_model.g.dart';

@JsonSerializable()
class SignInFormModel extends Equatable {
  final String email;
  final String password;

  const SignInFormModel({
    required this.email,
    required this.password,
  });

  Map<String, dynamic> toJson() => _$SignInFormModelToJson(this);

  @override
  List<Object?> get props => [email, password];
}
