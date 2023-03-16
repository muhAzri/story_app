import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../shared/theme.dart';

class CustomTextFormField extends StatelessWidget {
  final String? title;
  final String hintText;
  final bool isObsecure;
  final TextEditingController? controller;

  const CustomTextFormField({
    super.key,
    this.title,
    required this.hintText,
    this.controller,
    this.isObsecure = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 8.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTitle(),
          _buildContainer(),
        ],
      ),
    );
  }

  Widget _buildTitle() {
    if (title != null) {
      return Container(
        margin: EdgeInsets.only(
          top: 12.h,
          bottom: 12.h,
        ),
        child: Text(
          title!,
          style: primaryTextStyle.copyWith(
            fontWeight: semiBold,
          ),
        ),
      );
    }

    return const SizedBox();
  }

  Widget _buildContainer() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 18.h),
      decoration: BoxDecoration(
        color: grayColor,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        children: [
          _buildTextFormField(),
        ],
      ),
    );
  }

  Widget _buildTextFormField() {
    return Expanded(
      child: TextFormField(
        obscureText: isObsecure,
        controller: controller,
        style: primaryTextStyle.copyWith(
          fontWeight: medium,
          color: Colors.white,
        ),
        decoration: InputDecoration.collapsed(
          hintText: hintText,
          hintStyle: whiteTextStyle.copyWith(
            fontWeight: light,
          ),
        ),
      ),
    );
  }
}
