import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:story_app/bloc/story/story_bloc.dart';
import 'package:story_app/common.dart';
import 'package:story_app/models/form_models/add_story_form_model.dart';
import 'package:story_app/shared/method.dart';
import 'package:story_app/shared/theme.dart';
import 'package:story_app/view/widgets/buttons.dart';
import 'package:story_app/view/widgets/forms.dart';

class UploadStoryPage extends StatefulWidget {
  final Function() uploadSuccess;

  const UploadStoryPage({super.key, required this.uploadSuccess});

  @override
  State<UploadStoryPage> createState() => _UploadStoryPageState();
}

class _UploadStoryPageState extends State<UploadStoryPage> {
  XFile? selectedImage;
  final TextEditingController descriptionController =
      TextEditingController(text: '');

  bool validate() {
    if (selectedImage == null || descriptionController.text.isEmpty) {
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 24.w),
        child: Column(
          children: [
            _buildImage(),
            _buildImageSelector(),
            _buildForms(),
          ],
        ),
      ),
    );
  }

  Widget _buildImage() {
    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: 360.h),
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.only(
          top: 84.h,
        ),
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: grayColor,
          ),
        ),
        child: selectedImage == null
            ? Center(
                child: Text(
                  AppLocalizations.of(context)!.noImage,
                  style: primaryTextStyle.copyWith(
                    fontSize: 18.sp,
                    fontWeight: semiBold,
                  ),
                ),
              )
            : Image.file(
                File(
                  selectedImage!.path,
                ),
              ),
      ),
    );
  }

  Widget _buildImageSelector() {
    return Container(
      margin: EdgeInsets.only(top: 12.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            margin: EdgeInsets.only(bottom: 12.h),
            child: Text(
              AppLocalizations.of(context)!.selectImageFrom,
              style: secondaryTextStyle.copyWith(
                  fontSize: 12.sp, fontWeight: semiBold),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomTextButton(
                title: 'Gallery',
                width: 120.w,
                onTap: () async {
                  final image = await selectImageByGallery();

                  setState(() {
                    selectedImage = image;
                  });
                },
              ),
              SizedBox(
                width: 6.w,
              ),
              CustomTextButton(
                width: 120.w,
                title: 'Camera',
                onTap: () async {
                  final image = await selectImageByCamera();

                  setState(() {
                    selectedImage = image;
                  });
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildForms() {
    return BlocListener<StoryBloc, StoryState>(
      listener: (context, state) {
        if (state is StorySuccess) {
          showCustomSnackbar(context, AppLocalizations.of(context)!.storyAdded);
          widget.uploadSuccess();
        }

        if (state is StoryFailed) {
          showCustomSnackbar(context, state.e);
        }
      },
      child: Container(
        margin: EdgeInsets.only(top: 12.h),
        child: Column(
          children: [
            CustomTextFormField(
              hintText: AppLocalizations.of(context)!.inputYourDescription,
              controller: descriptionController,
            ),
            _buildButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildButton() {
    return Container(
      margin: EdgeInsets.only(top: 24.h),
      child: CustomTextButton(
        width: 270.w,
        title: AppLocalizations.of(context)!.submit,
        onTap: () {
          if (validate()) {
            context.read<StoryBloc>().add(
                  AddStoryEvent(
                    AddStoryFormModel(
                      File(selectedImage!.path),
                      descriptionController.text,
                    ),
                  ),
                );
          } else {
            showCustomSnackbar(context, 'Semua Field Harus Terisi');
          }
        },
      ),
    );
  }
}
