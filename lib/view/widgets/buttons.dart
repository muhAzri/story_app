import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:story_app/shared/theme.dart';

class CustomTextButton extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  final double? width;

  const CustomTextButton({
    super.key,
    required this.title,
    required this.onTap,
    this.width
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width ?? double.infinity,
        padding: EdgeInsets.symmetric(
          vertical: 14.h,
          horizontal: 24.w,
        ),
        decoration: BoxDecoration(
          color: grayColor,
          borderRadius: BorderRadius.circular(6.r),
        ),
        child: Center(
          child: Text(
            title,
            style: whiteTextStyle.copyWith(
              fontWeight: medium,
            ),
          ),
        ),
      ),
    );
  }
}
