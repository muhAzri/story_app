import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:story_app/bloc/story/story_bloc.dart';
import 'package:story_app/common.dart';

import '../../shared/theme.dart';

class DetailPage extends StatefulWidget {
  final String storyId;

  const DetailPage({super.key, required this.storyId});

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
    return BlocProvider(
      create: (context) => StoryBloc()..add(GetStoryByIdEvent(widget.storyId)),
      child: BlocBuilder<StoryBloc, StoryState>(
        builder: (context, state) {
          if (state is DetailStorySuccess) {
            return Container(
              margin: EdgeInsets.symmetric(horizontal: 24.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildStoryImage(state),
                  _buildStoryInfo(state),
                ],
              ),
            );
          }

          return const SizedBox();
        },
      ),
    );
  }

  Widget _buildStoryImage(DetailStorySuccess state) {
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
            image: NetworkImage(state.story.photoUrl),
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

  Widget _buildStoryInfo(DetailStorySuccess state) {
    return Container(
      margin: EdgeInsets.only(top: 48.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "${AppLocalizations.of(context)!.author}: ${state.story.name}",
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
            state.story.description,
            style: primaryTextStyle.copyWith(
              fontWeight: medium,
            ),
          ),
        ],
      ),
    );
  }
}
