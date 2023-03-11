import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:story_app/models/form_models/sign_up_form_model.dart';
import 'package:story_app/services/auth_service.dart';

import '../../models/form_models/sign_in_form_model.dart';
import '../../models/user.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {
    on<AuthRegister>((event, emit) async {
      try {
        emit(AuthLoading());
        final UserModel user = await AuthService().register(event.formModel);

        emit(AuthSuccess(user));
      } catch (e) {
        emit(AuthFailed(e.toString()));
      }
    });

    on<AuthLogin>((event, emit) async {
      try {
        emit(AuthLoading());
        final UserModel user = await AuthService().login(event.formModel);

        emit(AuthSuccess(user));
      } catch (e) {
        emit(AuthFailed(e.toString()));
      }
    });

    on<AuthGetCurrentUser>((event, emit) async {
      try {
        emit(AuthLoading());

        final SignInFormModel data =
            await AuthService().getCredentialFromLocal();

        final UserModel user = await AuthService().login(data);

        emit(AuthSuccess(user));
      } catch (e) {
        emit(AuthFailed(e.toString()));
      }
    });

    on<AuthSignOut>((event, emit) async {
      try {
        emit(AuthLoading());

        await AuthService().logout();

        emit(AuthInitial());
      } catch (e) {
        emit(AuthFailed(e.toString()));
      }
    });
  }
}
