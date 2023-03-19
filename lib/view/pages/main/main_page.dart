import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:story_app/shared/theme.dart';
import 'package:story_app/view/pages/main/home_page.dart';
import 'package:story_app/view/pages/main/profile_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: _buildBottomNavigationBar(),
      resizeToAvoidBottomInset: false,
      body: _buildBody(),
      floatingActionButton: uploadButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget _buildBody() {
    switch (currentIndex) {
      case 0:
        return const HomePage();
      case 1:
        return const ProfilePage();

      default:
        return const HomePage();
    }
  }

  Widget _buildBottomNavigationBar() {
    return SizedBox(
      height: 86.h,
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
              Icons.person,
              size: 24.w,
              color: currentIndex == 2 ? yellowColor : whiteColor,
            ),
          ),
        ],
      ),
    );
  }

  FloatingActionButton uploadButton() {
    return FloatingActionButton(
      backgroundColor: grayColor,
      onPressed: () {
        context.push('/upload-story');
      },
      child: Icon(
        Icons.add,
        size: 24.w,
        color: whiteColor,
      ),
    );
  }
}
