import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'sign_up_form_model.g.dart';

@JsonSerializable()
class SignUpFormModel extends Equatable {
  final String email;
  final String name;
  final String password;

  const SignUpFormModel({
    required this.name,
    required this.email,
    required this.password,
  });

  Map<String, dynamic> toJson() => _$SignUpFormModelToJson(this);

  @override
  List<Object?> get props => [
        email,
        name,
        password,
      ];
}
