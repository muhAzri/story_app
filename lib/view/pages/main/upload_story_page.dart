import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:story_app/bloc/story/story_bloc.dart';
import 'package:story_app/common.dart';
import 'package:go_router/go_router.dart';
import 'package:story_app/models/form_models/add_story_form_model.dart';
import 'package:story_app/shared/method.dart';
import 'package:story_app/shared/theme.dart';

import 'package:story_app/view/widgets/buttons.dart';
import 'package:story_app/view/widgets/forms.dart';

class UploadStoryPage extends StatefulWidget {
  final LatLng? latestLatLng;

  const UploadStoryPage({
    super.key,
    this.latestLatLng,
  });

  @override
  State<UploadStoryPage> createState() => _UploadStoryPageState();
}

class _UploadStoryPageState extends State<UploadStoryPage> {
  LatLng? latestLatLng;
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
  void initState() {
    if (widget.latestLatLng != null) {
      setState(() {
        latestLatLng = widget.latestLatLng;
      });
    }
    super.initState();
  }

  @override
  void dispose() {
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
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
      ),
    );
  }

  Widget _buildImage() {
    Widget imageSelection() {
      if (selectedImage == null) {
        return Center(
          child: Text(
            AppLocalizations.of(context)!.noImage,
            style: primaryTextStyle.copyWith(
              fontSize: 18.sp,
              fontWeight: semiBold,
            ),
          ),
        );
      }

      if (kIsWeb) {
        return Image.network(
          Uri.file(selectedImage!.path).toString(),
        );
      }

      return Image.file(
        File(
          selectedImage!.path,
        ),
      );
    }

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
        child: imageSelection(),
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
          context.pop();
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
            SizedBox(height: 12.h),
            CustomTextButton(
              title: 'Select Location',
              onTap: () async {
                // final LatLng? result = await Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //     builder: (context) => const SelectLocationPage(),
                //   ),
                // );

                context.pushReplacement('/select-location');
              },
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
            final AddStoryFormModel formModel = AddStoryFormModel(
              image: selectedImage!,
              description: descriptionController.text,
              lattitude: latestLatLng != null ? latestLatLng!.latitude : null,
              longtitude: latestLatLng != null ? latestLatLng!.longitude : null,
            );

            print(formModel);

            context.read<StoryBloc>().add(
                  AddStoryEvent(formModel),
                );
          } else {
            showCustomSnackbar(context, 'Semua Field Harus Terisi');
          }
        },
      ),
    );
  }
}
