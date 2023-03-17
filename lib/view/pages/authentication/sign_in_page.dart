import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:story_app/common.dart';
import 'package:story_app/models/form_models/sign_in_form_model.dart';
import 'package:story_app/shared/method.dart';
import 'package:story_app/shared/theme.dart';
import 'package:story_app/view/widgets/buttons.dart';

import '../../../bloc/auth/auth_bloc.dart';
import '../../widgets/forms.dart';

class SignInPage extends StatefulWidget {
  final VoidCallback? onAction;
  final Function()? toSignUp;

  const SignInPage({super.key, this.onAction, this.toSignUp});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final TextEditingController emailController = TextEditingController(text: '');
  final TextEditingController passwordController =
      TextEditingController(text: '');

  bool validate() {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      return false;
    }
    return true;
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthSuccess) {
          showCustomSnackbar(
              context, AppLocalizations.of(context)!.successLoginMessage);
          context.go('/main');
        }

        if (state is AuthFailed) {
          showCustomSnackbar(context, state.e);
          throw state.e;
        }
      },
      builder: (context, state) {
        if (state is AuthLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildSignInTitle(),
            _buildForms(),
            _buildButton(),
            _buildSignUpButton(),
          ],
        );
      },
    );
  }

  Widget _buildSignInTitle() {
    return Container(
      margin: EdgeInsets.only(top: 24.h),
      child: Text(
        AppLocalizations.of(context)!.signInTitle,
        style: primaryTextStyle.copyWith(
          fontSize: 18.sp,
          fontWeight: bold,
        ),
      ),
    );
  }

  Widget _buildForms() {
    return Container(
      margin: EdgeInsets.only(top: 24.h, left: 24.w, right: 24.w),
      child: Column(
        children: [
          CustomTextFormField(
            title: AppLocalizations.of(context)!.emailTitle,
            hintText: AppLocalizations.of(context)!.emailHintText,
            controller: emailController,
          ),
          CustomTextFormField(
            title: AppLocalizations.of(context)!.passwordTitle,
            hintText: AppLocalizations.of(context)!.passwordHintText,
            isObsecure: true,
            controller: passwordController,
          ),
        ],
      ),
    );
  }

  Widget _buildButton() {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthSuccess) {
          // widget.onAction;
        }

        if (state is AuthFailed) {
          showCustomSnackbar(context, state.e);
        }
      },
      child: Container(
        margin: EdgeInsets.only(top: 48.h, left: 72.w, right: 72.w),
        child: CustomTextButton(
          title: AppLocalizations.of(context)!.signInButton,
          onTap: () {
            if (validate()) {
              context.read<AuthBloc>().add(
                    AuthLogin(
                      SignInFormModel(
                        email: emailController.text,
                        password: passwordController.text,
                      ),
                    ),
                  );
            } else {
              showCustomSnackbar(
                  context, AppLocalizations.of(context)!.formValidationMessage);
            }
          },
        ),
      ),
    );
  }

  Widget _buildSignUpButton() {
    return GestureDetector(
      onTap: () {
        context.push('/sign-up');
      },
      child: Container(
        margin: EdgeInsets.only(top: 48.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              AppLocalizations.of(context)!.signInToSignUpText,
              style: secondaryTextStyle.copyWith(
                fontSize: 15.sp,
              ),
            )
          ],
        ),
      ),
    );
  }
}
