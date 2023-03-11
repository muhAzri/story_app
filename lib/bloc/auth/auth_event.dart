part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class AuthRegister extends AuthEvent {
  final SignUpFormModel formModel;

  const AuthRegister(this.formModel);

  @override
  List<Object> get props => [formModel];
}

class AuthLogin extends AuthEvent {
  final SignInFormModel formModel;

  const AuthLogin(this.formModel);

  @override
  List<Object> get props => [formModel];
}

class AuthSignOut extends AuthEvent{}

class AuthGetCurrentUser extends AuthEvent {}
