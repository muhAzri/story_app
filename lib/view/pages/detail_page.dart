import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:story_app/common.dart';

import '../../models/story.dart';
import '../../shared/theme.dart';

class DetailPage extends StatefulWidget {
  final StoryModel story;

  const DetailPage({super.key, required this.story});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  bool isImageNotFound = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 24.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildStoryImage(),
          _buildStoryInfo(),
        ],
      ),
    );
  }

  Widget _buildStoryImage() {
    Widget buildImage() {
      if (isImageNotFound) {
        return Center(
          child: Text(
            'Image Not Found',
            style: primaryTextStyle.copyWith(
              fontSize: 18.sp,
              fontWeight: bold,
            ),
          ),
        );
      }

      return Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(
              widget.story.photoUrl,
            ),
            onError: (exception, stackTrace) {
              setState(() {
                isImageNotFound = !isImageNotFound;
              });
            },
          ),
        ),
      );
    }

    return Container(
      margin: EdgeInsets.only(top: 48.h),
      height: 240.h,
      width: double.infinity,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: grayColor,
          )),
      child: buildImage(),
    );
  }

  Widget _buildStoryInfo() {
    return Container(
      margin: EdgeInsets.only(top: 48.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "${AppLocalizations.of(context)!.author}: ${widget.story.name}",
            style: primaryTextStyle.copyWith(
              fontSize: 16.sp,
              fontWeight: semiBold,
            ),
          ),
          SizedBox(
            height: 12.h,
          ),
          Text(
            AppLocalizations.of(context)!.description,
            style: primaryTextStyle.copyWith(
              fontSize: 16.sp,
              fontWeight: semiBold,
            ),
          ),
          SizedBox(
            height: 4.h,
          ),
          Text(
            widget.story.description,
            style: primaryTextStyle.copyWith(
              fontWeight: medium,
            ),
          ),
        ],
      ),
    );
  }
}
