import 'dart:async';

import 'package:defer_pointer/defer_pointer.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_cancellable_tile_provider/flutter_map_cancellable_tile_provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hawiah_client/core/custom_widgets/custom_button.dart';
import 'package:hawiah_client/core/images/app_images.dart';
import 'package:hawiah_client/core/locale/app_locale_key.dart';
import 'package:hawiah_client/features/location/presentation/widget/selected_location_widget.dart';
import 'package:hawiah_client/features/location/service/location_service.dart';
import 'package:latlong2/latlong.dart';

class LocationScreenArgs {
  final LatLng initialLatLng;
  final Function(LatLng) onLocationSelected;

  LocationScreenArgs({required this.initialLatLng, required this.onLocationSelected});
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
  final MapController _mapController = MapController();
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
    if (_showContainer) {
      setState(() => _showContainer = false);
    }
    _inactivityTimer?.cancel();
  }

  Future<void> _getAddressFromLocation(LatLng position) async {
    final data = await locationService.updateLocation(
      position.latitude,
      position.longitude,
      fetchLocality: true,
    );
    setState(() {
      _currentPosition = position;
      _currentAddress = data["locality"] ??
          "Lat: ${position.latitude.toStringAsFixed(4)}, Lng: ${position.longitude.toStringAsFixed(4)}";
    });
  }

  void _onPositionChanged(MapCamera camera, bool hasGesture) {
    if (hasGesture) {
      _currentPosition = camera.center;
    }
  }

  Future<void> _onMapIdle() async {
    await _getAddressFromLocation(_currentPosition);
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
              child: FlutterMap(
                mapController: _mapController,
                options: MapOptions(
                  initialCenter: _currentPosition,
                  initialZoom: 12,
                  onPositionChanged: _onPositionChanged,
                  onMapEvent: (event) {
                    if (event is MapEventMoveStart) {
                      _handleInteraction();
                    } else if (event is MapEventMoveEnd) {
                      _startInactivityTimer();
                      _onMapIdle();
                    }
                  },
                ),
                children: [
                  TileLayer(
                    urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'com.futuretec.hawiahplus',
                    keepBuffer: 2,
                    panBuffer: 1,
                    tileProvider: CancellableNetworkTileProvider(),
                  ),
                ],
              ),
            ),

            /// 🔹 Center Pin
            Center(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 35),
                child: Image.asset(
                  AppImages.mapPin,
                  height: 40,
                  width: 40,
                ),
              ),
            ),

            // Top selected location widget
            SelectedLocationWidget(showContainer: _showContainer),

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
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
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
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
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
