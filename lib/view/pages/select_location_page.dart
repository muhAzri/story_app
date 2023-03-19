import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geocoding/geocoding.dart' as geo;
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:story_app/shared/theme.dart';
import 'package:story_app/view/widgets/buttons.dart';

class SelectLocationPage extends StatefulWidget {
  const SelectLocationPage({super.key});

  @override
  State<SelectLocationPage> createState() => _SelectLocationPageState();
}

class _SelectLocationPageState extends State<SelectLocationPage> {
  final dicodingOffice = const LatLng(-6.8957473, 107.6337669);
  late LatLng latestLatLng;

  late GoogleMapController mapController;

  late final Set<Marker> markers = {};

  geo.Placemark? placemark;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Stack(
            children: [
              GoogleMap(
                initialCameraPosition: CameraPosition(
                  zoom: 18,
                  target: dicodingOffice,
                ),
                markers: markers,
                zoomControlsEnabled: false,
                mapToolbarEnabled: false,
                myLocationButtonEnabled: false,
                myLocationEnabled: true,
                onMapCreated: (controller) async {
                  final info = await geo.placemarkFromCoordinates(
                      dicodingOffice.latitude, dicodingOffice.longitude);

                  final place = info[0];
                  final street = place.street!;
                  final address =
                      '${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}';

                  setState(() {
                    placemark = place;
                  });

                  defineMarker(dicodingOffice, street, address);

                  setState(() {
                    mapController = controller;
                  });
                },
                onLongPress: (LatLng latLng) => onLongPressGoogleMap(latLng),
              ),
              Positioned(
                top: 16.h,
                right: 16.r,
                child: FloatingActionButton(
                  child: const Icon(Icons.my_location),
                  onPressed: () => onMyLocationButtonPress(),
                ),
              ),
              Positioned(
                bottom: 16.h,
                right: 16.r,
                child: CustomTextButton(
                  width: 75.w,
                  title: "OK",
                  onTap: () {
                    context.pushReplacement(
                      '/upload-story',
                      extra: latestLatLng,
                    );
                  },
                ),
              ),
              if (placemark == null)
                const SizedBox()
              else
                Positioned(
                  bottom: 16.h,
                  right: 16.w,
                  left: 16.w,
                  child: PlacemarkWidget(
                    placemark: placemark!,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  void onLongPressGoogleMap(LatLng latLng) async {
    final info =
        await geo.placemarkFromCoordinates(latLng.latitude, latLng.longitude);

    final place = info[0];
    final street = place.street!;
    final address =
        '${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}';

    setState(() {
      placemark = place;
      latestLatLng = latLng;
    });

    defineMarker(latLng, street, address);

    mapController.animateCamera(
      CameraUpdate.newLatLng(latLng),
    );
  }

  void onMyLocationButtonPress() async {
    final Location location = Location();
    late bool serviceEnabled;
    late PermissionStatus permissionGranted;
    late LocationData locationData;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    locationData = await location.getLocation();
    final latLng = LatLng(locationData.latitude!, locationData.longitude!);

    final info =
        await geo.placemarkFromCoordinates(latLng.latitude, latLng.longitude);

    final place = info[0];
    final street = place.street!;
    final address =
        '${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}';

    setState(() {
      placemark = place;
    });

    defineMarker(latLng, street, address);

    mapController.animateCamera(
      CameraUpdate.newLatLng(latLng),
    );
  }

  void defineMarker(LatLng latLng, String street, String address) {
    final marker = Marker(
      markerId: const MarkerId("source"),
      position: latLng,
      infoWindow: InfoWindow(
        title: street,
        snippet: address,
      ),
    );

    setState(() {
      markers.clear();
      markers.add(marker);
      latestLatLng = latLng;
    });
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
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(12.r)),
              boxShadow: <BoxShadow>[
                BoxShadow(
                  blurRadius: 20.r,
                  offset: Offset.zero,
                  color: Colors.grey.withOpacity(0.5),
                )
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(placemark.street!,
                    style: primaryTextStyle.copyWith(
                      fontSize: 16.sp,
                      fontWeight: bold,
                    )),
                Text(
                    '${placemark.subLocality}, ${placemark.locality}, ${placemark.postalCode}, ${placemark.country}',
                    style: primaryTextStyle.copyWith(
                      fontSize: 14.sp,
                      fontWeight: medium,
                    )),
              ],
            ),
          ),
        ),
        SizedBox(
          width: 87.w,
        ),
      ],
    );
  }
}
