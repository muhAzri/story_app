import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:story_app/bloc/story/story_bloc.dart';
import 'package:story_app/common.dart';
import 'package:geocoding/geocoding.dart' as geo;

import '../../shared/theme.dart';

class DetailPage extends StatefulWidget {
  final String storyId;

  const DetailPage({super.key, required this.storyId});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  late final Set<Marker> markers = {};
  bool isImageNotFound = false;
  geo.Placemark? placemark;

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
              child: ListView(
                children: [
                  _buildStoryImage(state),
                  _buildStoryInfo(state),
                  if (state.story.latitude != null &&
                      state.story.longitude != null)
                    _buildMapLocation(state),
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
    return Container(
      margin: EdgeInsets.only(top: 48.h),
      height: 240.h,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: grayColor),
      ),
      child: _buildStoryImageContent(state),
    );
  }

  Widget _buildStoryImageContent(DetailStorySuccess state) {
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
            setState(() => isImageNotFound = true);
          },
        ),
      ),
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

  Widget _buildMapLocation(DetailStorySuccess state) {
    final location = LatLng(state.story.latitude!, state.story.longitude!);

    Future<void> onMapCreated(GoogleMapController controller) async {
      final info = await geo.placemarkFromCoordinates(
        location.latitude,
        location.longitude,
      );
      final place = info[0];
      final street = place.street!;
      final address =
          '${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}';

      setState(() {
        placemark = place;
      });

      final marker = Marker(
        markerId: MarkerId(state.story.id),
        position: location,
        infoWindow: InfoWindow(
          title: street,
          snippet: address,
        ),
      );
      markers.add(marker);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(top: 12.h),
          child: Text(
            'Address',
            style: primaryTextStyle.copyWith(
              fontWeight: semiBold,
              fontSize: 16.sp,
            ),
          ),
        ),
        if (placemark != null) PlacemarkWidget(placemark: placemark!),
        Container(
          height: 240.h,
          width: double.infinity,
          margin: EdgeInsets.only(top: 12.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: grayColor,
            ),
          ),
          child: GoogleMap(
            onMapCreated: onMapCreated,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            mapToolbarEnabled: false,
            zoomGesturesEnabled: false,
            markers: markers.toSet(),
            initialCameraPosition: CameraPosition(
              target: location,
              zoom: 18,
            ),
          ),
        ),
      ],
    );
  }
}

class PlacemarkWidget extends StatelessWidget {
  const PlacemarkWidget({
    super.key,
    required this.placemark,
  });
  final geo.Placemark placemark;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                placemark.street!,
                style: primaryTextStyle.copyWith(
                    fontSize: 16, fontWeight: semiBold),
              ),
              Text(
                '${placemark.subLocality}, ${placemark.locality}, ${placemark.postalCode}, ${placemark.country}',
                style: primaryTextStyle.copyWith(
                    fontSize: 16, fontWeight: semiBold),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
