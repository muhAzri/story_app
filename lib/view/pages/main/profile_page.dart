import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:story_app/bloc/auth/auth_bloc.dart';
import 'package:story_app/bloc/locale/locale_cubit.dart';
import 'package:story_app/common.dart';
import 'package:story_app/shared/theme.dart';
import 'package:story_app/view/widgets/buttons.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({
    super.key,
  });

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildLanguageRow(),
          _buildSignOutButton(),
        ],
      ),
    );
  }

  Widget _buildLanguageRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              context.read<LocalizationCubit>().setLocale(const Locale('id'));
            });
          },
          child: Text(
            '\u{1F1EE}\u{1F1E9}',
            style: primaryTextStyle.copyWith(
              fontSize: BlocProvider.of<LocalizationCubit>(context).state ==
                      const Locale('id')
                  ? 64.sp
                  : 24.sp,
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            setState(() {
              context.read<LocalizationCubit>().setLocale(const Locale('en'));
            });
          },
          child: Text(
            '\u{1F1EC}\u{1F1E7}',
            style: primaryTextStyle.copyWith(
              fontSize: BlocProvider.of<LocalizationCubit>(context).state ==
                      const Locale('en')
                  ? 64.sp
                  : 24.sp,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSignOutButton() {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthInitial) {
          context.go('/sign-in');
        }
      },
      builder: (context, state) {
        return Container(
          margin: EdgeInsets.symmetric(horizontal: 48.w, vertical: 12.h),
          child: CustomTextButton(
            title: AppLocalizations.of(context)!.signOut,
            onTap: () {
              context.read<AuthBloc>().add(AuthSignOut());
            },
          ),
        );
      },
    );
  }
}
