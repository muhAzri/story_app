import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:story_app/bloc/auth/auth_bloc.dart';
import 'package:story_app/bloc/locale/locale_cubit.dart';
import 'package:story_app/bloc/story/story_bloc.dart';
import 'package:story_app/common.dart';
import 'package:go_router/go_router.dart';
import 'package:story_app/view/pages/authentication/sign_in_page.dart';
import 'package:story_app/view/pages/authentication/sign_up_page.dart';
import 'package:story_app/view/pages/detail_page.dart';
import 'package:story_app/view/pages/main/main_page.dart';
import 'package:story_app/view/pages/main/upload_story_page.dart';
import 'package:story_app/view/pages/select_location_page.dart';
import 'package:story_app/view/pages/splash_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterConfig.loadEnvVariables();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  GoRouter _router() {
    return GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const SplashPage(),
        ),
        GoRoute(
          path: '/sign-in',
          builder: (context, state) => const SignInPage(),
        ),
        GoRoute(
          path: '/sign-up',
          builder: (context, state) => const SignUpPage(),
        ),
        GoRoute(
          path: '/main',
          builder: (context, state) => const MainPage(),
        ),
        GoRoute(
          path: '/upload-story',
          name: 'upload-story',
          builder: (context, state) {
            Map<String,dynamic>? addtionalDataMap = state.extra as Map<String,dynamic>?;

            return UploadStoryPage(
              addtionalData: addtionalDataMap,
            );
          },
        ),
        GoRoute(
          path: '/select-location',
          name: 'select-location',
          builder: (context, state) {
            Map<String,dynamic>? addtionalDataMap = state.extra as Map<String,dynamic>?;

            return SelectLocationPage(
              addtionalData: addtionalDataMap,
            );
          }
        ),
        GoRoute(
          path: '/detail:storyId',
          name: "detail",
          builder: (context, state) => DetailPage(
            storyId: state.params['storyId']!,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AuthBloc(),
        ),
        BlocProvider(
          create: (context) => StoryBloc(),
        ),
        BlocProvider(
          create: (context) => LocalizationCubit(),
        ),
      ],
      child: ScreenUtilInit(
        designSize: const Size(375, 812),
        builder: (context, child) {
          return BlocBuilder<LocalizationCubit, Locale>(
            builder: (context, locale) {
              return MaterialApp.router(
                debugShowCheckedModeBanner: false,
                localizationsDelegates: AppLocalizations.localizationsDelegates,
                supportedLocales: AppLocalizations.supportedLocales,
                locale: locale,
                routerConfig: _router(),
              );
            },
          );
        },
      ),
    );
  }
}
