import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:story_app/bloc/auth/auth_bloc.dart';

class SplashPage extends StatefulWidget {
  final VoidCallback? onAction;

  final Function()? toSignInPage;

  const SplashPage({super.key, this.toSignInPage, this.onAction});

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
          context.go('/main');
        }

        if (state is AuthFailed) {
          context.go('/sign-in');
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
