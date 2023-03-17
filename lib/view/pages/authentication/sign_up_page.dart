import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:story_app/bloc/auth/auth_bloc.dart';
import 'package:story_app/common.dart';
import 'package:story_app/models/form_models/sign_up_form_model.dart';
import 'package:story_app/shared/method.dart';

import '../../../shared/theme.dart';
import '../../widgets/buttons.dart';
import '../../widgets/forms.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({
    Key? key,
  }) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUnPageState();
}

class _SignUnPageState extends State<SignUpPage> {
  final TextEditingController emailController = TextEditingController(text: '');
  final TextEditingController nameController = TextEditingController(text: '');
  final TextEditingController passwordController =
      TextEditingController(text: '');

  bool validate() {
    if (emailController.text.isEmpty ||
        passwordController.text.isEmpty ||
        nameController.text.isEmpty) {
      return false;
    }
    return true;
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
        if (state is AuthUserCreated) {
          context.pop();

          showCustomSnackbar(
              context, AppLocalizations.of(context)!.successSignUpMessage);
        }

        if (state is AuthFailed) {
          showCustomSnackbar(context, state.e);
        }
      },
      builder: (context, state) {
        if (state is AuthLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildSignInTitle(),
              _buildForms(),
              _buildButton(),
              _buildSignInButton(),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSignInTitle() {
    return Container(
      margin: EdgeInsets.only(top: 18.h),
      child: Text(
        AppLocalizations.of(context)!.signUpTitle,
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
            title: 'Name',
            hintText: 'Your Name',
            controller: nameController,
          ),
          CustomTextFormField(
            title: 'Email',
            hintText: 'Your Email Address',
            controller: emailController,
          ),
          CustomTextFormField(
            title: 'Password',
            hintText: 'Your Password',
            isObsecure: true,
            controller: passwordController,
          ),
        ],
      ),
    );
  }

  Widget _buildButton() {
    return Container(
      margin: EdgeInsets.only(top: 48.h, left: 72.w, right: 72.w),
      child: CustomTextButton(
        title: 'Sign Up',
        onTap: () {
          if (validate()) {
            context.read<AuthBloc>().add(
                  AuthRegister(
                    SignUpFormModel(
                      name: nameController.text,
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
    );
  }

  Widget _buildSignInButton() {
    return GestureDetector(
      onTap: () {
        context.pop();
      },
      child: Container(
        margin: EdgeInsets.only(top: 48.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              AppLocalizations.of(context)!.signUpToSignInText,
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
