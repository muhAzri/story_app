import 'package:flutter/material.dart';
import 'package:story_app/models/story.dart';
import 'package:story_app/view/pages/authentication/sign_in_page.dart';
import 'package:story_app/view/pages/detail_page.dart';
import 'package:story_app/view/pages/main/main_page.dart';
import 'package:story_app/view/pages/splash_page.dart';

import '../view/pages/authentication/sign_up_page.dart';

class MyRouterDelegate extends RouterDelegate
    with ChangeNotifier, PopNavigatorRouterDelegateMixin {
  final GlobalKey<NavigatorState> _navigatorKey;

  MyRouterDelegate() : _navigatorKey = GlobalKey<NavigatorState>();

  StoryModel? selectedStory;
  bool isSplash = true;
  bool isSignIn = false;
  bool isSignUp = false;
  bool isAuthenticated = false;

  void signIn() {
    isSignIn = true;
    isSplash = false;
    notifyListeners();
  }

  void signUp() {
    isSignUp = true;
    notifyListeners();
  }

  void authenticate() {
    isSignUp = false;
    isSignIn = false;
    isAuthenticated = true;
    notifyListeners();
  }

  void signOut() {
    isAuthenticated = false;
    isSignIn = true;
    notifyListeners();
  }

  void selectStory(StoryModel story) {
    selectedStory = story;
    notifyListeners();
  }

  void unselectStory() {
    selectedStory = null;
    notifyListeners();
  }

  @override
  Widget build(BuildContext context) {
    return Navigator(
      pages: [
        if (isSplash)
          MaterialPage(
            key: const ValueKey("splash"),
            child: SplashPage(
              toSignInPage: signIn,
            ),
          ),
        if (isSignIn)
          MaterialPage(
            key: const ValueKey("sign-in"),
            child: SignInPage(
              onAction: authenticate,
              toSignUp: signUp,
            ),
          ),
        if (isSignUp)
          MaterialPage(
            key: const ValueKey("sign-up"),
            child: SignUnPage(
              onAction: authenticate,
              toSignIn: signIn,
            ),
          ),
        if (isAuthenticated)
          MaterialPage(
            key: const ValueKey("main"),
            child: MainPage(
              onSignOut: signOut,
              onStorySelected: selectStory,
            ),
          ),
        if (selectedStory != null)
          MaterialPage(
            key: ValueKey('detail-page/${selectedStory!.id}'),
            child: DetailPage(
              story: selectedStory!,
            ),
          )
      ],
      onPopPage: (route, result) {
        final didPop = route.didPop(result);
        if (!didPop) {
          return false;
        }

        unselectStory();
        isSignUp = false;

        return true;
      },
    );
  }

  @override
  GlobalKey<NavigatorState> get navigatorKey => _navigatorKey;

  @override
  Future<void> setNewRoutePath(configuration) {
    throw UnimplementedError();
  }
}
