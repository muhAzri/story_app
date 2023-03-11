import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:story_app/bloc/auth/auth_bloc.dart';

class SplashPage extends StatefulWidget {
  final Function() toSignInPage;

  const SplashPage({super.key, required this.toSignInPage});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    context.read<AuthBloc>().add(AuthGetCurrentUser());

    Timer(
      const Duration(seconds: 2),
      widget.toSignInPage,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Icon(
        Icons.library_books,
        color: Colors.blueGrey,
        size: 128.sp,
      ),
    ));
  }
}
