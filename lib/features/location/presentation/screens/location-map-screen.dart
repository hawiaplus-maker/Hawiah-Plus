import 'dart:async';

import 'package:defer_pointer/defer_pointer.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hawiah_client/core/custom_widgets/custom_button.dart';
import 'package:hawiah_client/core/locale/app_locale_key.dart';
import 'package:hawiah_client/features/location/service/location_service.dart';

class LocationScreenArgs {
  final LatLng initialLatLng;
  final Function(LatLng) onLocationSelected;

  LocationScreenArgs(
      {required this.initialLatLng, required this.onLocationSelected});
}

class LocationScreen extends StatefulWidget {
  static const routeName = '/location-screen';
  const LocationScreen({Key? key, required this.args}) : super(key: key);
  final LocationScreenArgs args;

  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  final LocationService locationService = LocationService();
  final Completer<GoogleMapController> mapController = Completer();
  late LatLng _currentPosition;
  String _currentAddress = "Getting location...";
  bool _showContainer = true;
  Timer? _inactivityTimer;

  @override
  void initState() {
    super.initState();
    _currentPosition = widget.args.initialLatLng;
    _getAddressFromLocation(_currentPosition);
    _startInactivityTimer();
  }

  void _startInactivityTimer() {
    _inactivityTimer?.cancel();
    _inactivityTimer = Timer(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() => _showContainer = true);
      }
    });
  }

  void _handleInteraction() {
    setState(() => _showContainer = false);
    _startInactivityTimer();
  }

  Future<void> _getAddressFromLocation(LatLng position) async {
    // Replace with your actual geocoding implementation
    setState(() {
      _currentAddress = "Lat: ${position.latitude.toStringAsFixed(4)}, "
          "Lng: ${position.longitude.toStringAsFixed(4)}";
    });
  }

  Future<void> _updateCameraPosition() async {
    final controller = await mapController.future;
    await controller.animateCamera(
      CameraUpdate.newLatLng(_currentPosition),
    );
  }

  @override
  void dispose() {
    _inactivityTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DeferredPointerHandler(
        child: Stack(
          children: [
            // Map with interaction handling
            Positioned.fill(
              child: GestureDetector(
                onTap: () => _handleInteraction(),
                child: Listener(
                  onPointerMove: (_) => _handleInteraction(),
                  child: DeferPointer(
                    child: GoogleMap(
                      onMapCreated: (GoogleMapController controller) {
                        mapController.complete(controller);
                      },
                      onTap: (LatLng argument) async {
                        setState(() => _currentPosition = argument);
                        await _getAddressFromLocation(argument);
                        await _updateCameraPosition();
                      },
                      onCameraMove: (position) => _handleInteraction(),
                      initialCameraPosition: CameraPosition(
                        target: _currentPosition,
                        zoom: 12,
                      ),
                      markers: <Marker>{
                        Marker(
                          markerId: const MarkerId("currentLocation"),
                          position: _currentPosition,
                        ),
                      },
                    ),
                  ),
                ),
              ),
            ),

            // Top AppBar
            Align(
              alignment: Alignment.topCenter,
              child: AnimatedOpacity(
                opacity: _showContainer ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 200),
                child: AppBar(
                  backgroundColor: Colors.transparent,
                  actions: [
                    IconButton(
                      icon: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 10),
                        padding: const EdgeInsets.all(10),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.black,
                          size: 16,
                        ),
                      ),
                      onPressed: () => Navigator.pop(context),
                    )
                  ],
                ),
              ),
            ),

            // Bottom Container with animation
            Align(
              alignment: Alignment.bottomCenter,
              child: AnimatedSlide(
                duration: const Duration(milliseconds: 300),
                offset: _showContainer ? Offset.zero : const Offset(0, 1),
                child: Container(
                  height: 0.2.sh,
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(20)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppLocaleKey.confirmcurrentlocation.tr(),
                            style: TextStyle(
                              color: const Color(0xff979797),
                              fontSize: 12.sp,
                            ),
                          ),
                          SizedBox(height: 10.h),
                          Text(
                           AppLocaleKey.currentaddress.tr(),
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 15.sp,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10.h),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10),
                        decoration: BoxDecoration(
                          color: const Color(0xffF9F9F9),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: const Color(0xffF9F9F9)),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              "assets/icons/location_map_icon.png",
                              height: 20,
                              width: 20,
                            ),
                            SizedBox(width: 10.w),
                            Expanded(
                              child: Text(
                                _currentAddress,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 15.sp,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: CustomButton(
          text: "confirm_address".tr(),
          onPressed: () {
            Navigator.pop(context);
            widget.args.onLocationSelected.call(_currentPosition);
          },
        ),
      ),
    );
  }
}
