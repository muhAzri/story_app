import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:story_app/bloc/story/story_bloc.dart';
import 'package:story_app/models/story.dart';
import 'package:story_app/shared/theme.dart';
import 'package:story_app/view/pages/main/home_page.dart';
import 'package:story_app/view/pages/main/profile_page.dart';
import 'package:story_app/view/pages/main/upload_story_page.dart';

class MainPage extends StatefulWidget {
  final Function() onSignOut;
  final Function(StoryModel story) onStorySelected;

  const MainPage(
      {super.key, required this.onSignOut, required this.onStorySelected});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int currentIndex = 0;

  @override
  void initState() {
    context.read<StoryBloc>().add(FetchStoriesEvent());
    super.initState();
  }

  void onUploadSuccess() {
    setState(() {
      currentIndex = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: _buildBottomNavigationBar(),
      resizeToAvoidBottomInset: false,
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    switch (currentIndex) {
      case 0:
        return HomePage(
          onStorySelected: widget.onStorySelected,
        );
      case 1:
        return UploadStoryPage(
          uploadSuccess: onUploadSuccess,
        );
      case 2:
        return ProfilePage(
          onSignOut: widget.onSignOut,
        );

      default:
        return HomePage(
          onStorySelected: widget.onStorySelected,
        );
    }
  }

  Widget _buildBottomNavigationBar() {
    return SizedBox(
      height: 82.h,
      child: BottomNavigationBar(
        backgroundColor: grayColor,
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        onTap: (value) {
          setState(() {
            currentIndex = value;
          });
        },
        items: [
          BottomNavigationBarItem(
            label: '',
            icon: Icon(
              Icons.home,
              size: 24.w,
              color: currentIndex == 0 ? yellowColor : whiteColor,
            ),
          ),
          BottomNavigationBarItem(
            label: '',
            icon: Icon(
              Icons.add,
              size: 24.w,
              color: currentIndex == 1 ? yellowColor : whiteColor,
            ),
          ),
          BottomNavigationBarItem(
            label: '',
            icon: Icon(
              Icons.person,
              size: 24.w,
              color: currentIndex == 2 ? yellowColor : whiteColor,
            ),
          ),
        ],
      ),
    );
  }
}
