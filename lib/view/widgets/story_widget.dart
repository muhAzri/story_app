import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:story_app/models/story.dart';
import 'package:story_app/shared/theme.dart';

class StoryWidget extends StatefulWidget {
  final StoryModel story;
  final Function(StoryModel story) onTap;

  const StoryWidget({
    super.key,
    required this.story,
    required this.onTap,
  });

  @override
  State<StoryWidget> createState() => _StoryWidgetState();
}

class _StoryWidgetState extends State<StoryWidget> {
  bool isImageNotFound = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.onTap(widget.story);
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 12.h),
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: Colors.grey,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildStoryImage(),
            _buildStoryCredential(),
          ],
        ),
      ),
    );
  }

  Widget _buildStoryImage() {
    if (isImageNotFound) {
      return SizedBox(
        height: 80.h,
        width: double.infinity,
        child: Center(
          child: Text(
            'Image Not Found',
            style: primaryTextStyle.copyWith(
              fontSize: 18.sp,
              fontWeight: bold,
            ),
          ),
        ),
      );
    }

    return Container(
      height: 120.h,
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

  Widget _buildStoryCredential() {
    return Container(
      margin: EdgeInsets.only(top: 12.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.story.name!,
            style: primaryTextStyle.copyWith(
              fontWeight: semiBold,
            ),
          ),
          SizedBox(
            height: 4.h,
          ),
          Text(
            widget.story.description,
            maxLines: 2,
            style: primaryTextStyle.copyWith(
              fontWeight: medium,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
