import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hawiah_client/core/custom_widgets/custom_button.dart';
import 'package:hawiah_client/core/custom_widgets/custom_loading/custom_loading.dart';
import 'package:hawiah_client/core/locale/app_locale_key.dart';
import 'package:hawiah_client/core/theme/app_colors.dart';
import 'package:hawiah_client/core/theme/app_text_style.dart';
import 'package:hawiah_client/features/location/service/location_service.dart';

typedef OnLocationSelected = void Function(
  double lat,
  double lng,
  String city,
  String fullAddress,
);

class MapScreenArgs {
  final OnLocationSelected onLocationSelected;
  final double? initialLat;
  final double? initialLng;

  const MapScreenArgs({required this.onLocationSelected, this.initialLat, this.initialLng});
}

class MapScreen extends StatefulWidget {
  static const String routeName = "MapScreen";
  final MapScreenArgs args;

  const MapScreen({super.key, required this.args});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final LocationService _locationService = LocationService();

  GoogleMapController? _mapController;

  bool _loading = true;
  bool _manualSelection = false;

  double? _lat;
  double? _lng;
  String? _city;
  String? _locality;

  DateTime? _lastUpdate;

  @override
  void initState() {
    super.initState();
    _initializeLocation();
  }

  Future<void> _initializeLocation() async {
    setState(() => _loading = true);
    if (widget.args.initialLat != null && widget.args.initialLng != null) {
      await _updateLocation(
        widget.args.initialLat!,
        widget.args.initialLng!,
        fetchLocality: true,
        shouldAnimate: true,
      );
      _manualSelection = true;
    } else {
      final data = await _locationService.getCurrentLocation();

      if (data != null && data.latitude != null && data.longitude != null) {
        await _updateLocation(
          data.latitude!,
          data.longitude!,
          fetchLocality: true,
          shouldAnimate: true,
        );

        _startListening();
      }
    }
    setState(() => _loading = false);
  }

  void _startListening() {
    _locationService.listenToLocation((location) async {
      if (_manualSelection) return;

      if (location.latitude == null || location.longitude == null) return;

      final now = DateTime.now();
      if (_lastUpdate != null && now.difference(_lastUpdate!).inMilliseconds < 1500) {
        return;
      }
      _lastUpdate = now;

      await _updateLocation(
        location.latitude!,
        location.longitude!,
        shouldAnimate: false,
      );
    });
  }

  Future<void> _updateLocation(
    double lat,
    double lng, {
    bool fetchLocality = false,
    bool shouldAnimate = false, // Add this
  }) async {
    final data = await _locationService.updateLocation(
      lat,
      lng,
      fetchLocality: fetchLocality,
    );

    if (!mounted) return;

    setState(() {
      _lat = data["lat"];
      _lng = data["lng"];
      _city = data["city"];
      _locality = data["locality"];
    });

    // Only move the camera if specifically requested
    if (shouldAnimate && _mapController != null) {
      _mapController!.animateCamera(
        CameraUpdate.newLatLng(LatLng(_lat!, _lng!)),
      );
    }
  }

  Future<void> _onMapTap(LatLng latLng) async {
    _manualSelection = true;
    _locationService.pauseLocationStream();

    await _updateLocation(
      latLng.latitude,
      latLng.longitude,
      fetchLocality: true,
    );
  }

  Future<void> _goToCurrentLocation() async {
    setState(() => _manualSelection = false); // Reset manual flag
    _locationService.resumeLocationStream();

    final data = await _locationService.getCurrentLocation();
    if (data != null) {
      await _updateLocation(
        data.latitude!,
        data.longitude!,
        fetchLocality: true,
        shouldAnimate: true,
      );
    }
  }

  @override
  void dispose() {
    _locationService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColor.mainAppColor,
        child: const Icon(Icons.my_location, color: Colors.white),
        onPressed: _goToCurrentLocation,
      ),
      body: _loading
          ? const Center(child: CustomLoading())
          : (_lat == null ? const Center(child: Text("Location unavailable")) : _buildMap()),
      bottomNavigationBar: _buildConfirmButton(),
    );
  }

  Widget _buildMap() {
    return Stack(
      children: [
        GoogleMap(
          initialCameraPosition: CameraPosition(
            target: LatLng(_lat!, _lng!),
            zoom: 14,
          ),
          onMapCreated: (controller) => _mapController = controller,
          markers: {
            Marker(
              markerId: const MarkerId("selected"),
              position: LatLng(_lat!, _lng!),
            ),
          },
          onTap: _onMapTap,
          onCameraMoveStarted: () {
            setState(() {
              _manualSelection = true;
            });
            _locationService.pauseLocationStream();
          },
          zoomControlsEnabled: false,
          myLocationEnabled: false,
          myLocationButtonEnabled: false,
        ),

        /// 🔹 Address Card
        if (_city != null || _locality != null)
          Positioned(
            top: MediaQuery.of(context).viewInsets.top + 50,
            left: 20,
            right: 20,
            child: Card(
              elevation: 3,
              child: Padding(
                padding: EdgeInsets.only(top: 12, bottom: 12.0, left: 16.0, right: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (_city != null)
                      Text(
                        _city!,
                        style: AppTextStyle.text16_700.copyWith(
                          color: AppColor.mainAppColor,
                        ),
                      ),
                    if (_locality != null)
                      Text(
                        _locality!,
                        style: const TextStyle(fontSize: 14),
                      ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildConfirmButton() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: CustomButton(
          text: AppLocaleKey.confirmcurrentlocation.tr(),
          onPressed: () {
            if (_lat != null && _lng != null) {
              widget.args.onLocationSelected(
                _lat!,
                _lng!,
                _city ?? "",
                _locality ?? "",
              );
            }
            Navigator.pop(context);
          },
        ),
      ),
    );
  }
}
