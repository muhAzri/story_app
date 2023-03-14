
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:story_app/bloc/auth/auth_bloc.dart';

class SplashPage extends StatefulWidget {
  final VoidCallback onAction;

  final Function() toSignInPage;

  const SplashPage(
      {super.key, required this.toSignInPage, required this.onAction});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    context.read<AuthBloc>().add(AuthGetCurrentUser());

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthSuccess) {
          widget.onAction();
        }

        if (state is AuthFailed) {
          widget.toSignInPage();
        }
      },
      child: Scaffold(
          body: Center(
        child: Icon(
          Icons.library_books,
          color: Colors.blueGrey,
          size: 128.sp,
        ),
      )),
    );
  }
}
