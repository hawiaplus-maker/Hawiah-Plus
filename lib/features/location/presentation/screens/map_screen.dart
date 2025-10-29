import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hawiah_client/core/custom_widgets/custom_button.dart';
import 'package:hawiah_client/core/custom_widgets/custom_loading/custom_loading.dart';
import 'package:hawiah_client/core/locale/app_locale_key.dart';
import 'package:hawiah_client/core/theme/app_colors.dart';
import 'package:hawiah_client/features/location/service/location_service.dart';
import 'package:location/location.dart';

typedef OnLocationSelected = void Function(double lat, double lng, String locality);

@immutable
class LocationState {
  final double? latitude;
  final double? longitude;
  final String? locality;
  final bool isLoading;
  final String? error;

  const LocationState({
    this.latitude,
    this.longitude,
    this.locality,
    this.isLoading = false,
    this.error,
  });

  LocationState copyWith({
    double? latitude,
    double? longitude,
    String? locality,
    bool? isLoading,
    String? error,
  }) {
    return LocationState(
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      locality: locality ?? this.locality,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }

  bool get hasValidCoordinates => latitude != null && longitude != null;
  LatLng get latLng => LatLng(latitude ?? 0, longitude ?? 0);
}

class MapScreenArgs {
  final OnLocationSelected onLocationSelected;

  const MapScreenArgs({required this.onLocationSelected});

  void safeLocationSelected(double lat, double lng, String locality) {
    if (_isValidCoordinate(lat, lng)) {
      onLocationSelected(lat, lng, locality);
    } else {
      log('Invalid coordinates: lat=$lat, lng=$lng');
    }
  }

  static bool _isValidCoordinate(double lat, double lng) {
    return lat >= -90 && lat <= 90 && lng >= -180 && lng <= 180;
  }
}

class MapScreen extends StatefulWidget {
  static const String routeName = 'MapScreen';
  final MapScreenArgs args;

  const MapScreen({super.key, required this.args});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final LocationService _locationService = LocationService();
  GoogleMapController? _mapController;
  LocationState _locationState = const LocationState();
  bool _isManualSelection = false;
  static const double _initialZoom = 14.0;

  @override
  void initState() {
    super.initState();
    _initLocation();
  }

  @override
  void dispose() {
    _locationService.dispose();
    super.dispose();
  }

  /// ✅ Determine and display initial user position
  Future<void> _initLocation() async {
    setState(() => _locationState = _locationState.copyWith(isLoading: true));

    final location = await _locationService.getCurrentLocation();
    if (location != null && location.latitude != null && location.longitude != null) {
      await _updateLocation(location.latitude!, location.longitude!, fetchLocality: true);
      _startListeningToLocation();
    } else {
      setState(() => _locationState = _locationState.copyWith(
            isLoading: false,
            error: 'location_error'.tr(),
          ));
    }
  }

  /// ✅ Start listening for live location updates
  void _startListeningToLocation() {
    _locationService.listenToLocation((LocationData data) async {
      if (!_isManualSelection && data.latitude != null && data.longitude != null) {
        await _updateLocation(data.latitude!, data.longitude!);
      }
    });
  }

  /// ✅ Update map + locality (reverse geocode)
  Future<void> _updateLocation(double lat, double lng, {bool fetchLocality = false}) async {
    String? locality;
    if (fetchLocality) {
      try {
        final placemarks = await placemarkFromCoordinates(lat, lng);
        if (placemarks.isNotEmpty) {
          final place = placemarks.first;
          locality = [place.street, place.locality, place.postalCode]
              .where((e) => e?.isNotEmpty == true)
              .join(', ');
        }
      } catch (e) {
        log("Placemark error: $e");
      }
    }

    setState(() {
      _locationState = _locationState.copyWith(
        latitude: lat,
        longitude: lng,
        locality: locality ?? _locationState.locality,
        isLoading: false,
        error: null,
      );
    });

    _mapController?.animateCamera(CameraUpdate.newLatLng(LatLng(lat, lng)));
  }

  /// ✅ When user taps on map manually
  Future<void> _onMapTap(LatLng latLng) async {
    _isManualSelection = true;
    _locationService.pauseLocationStream();

    setState(() {
      _locationState = _locationState.copyWith(
        latitude: latLng.latitude,
        longitude: latLng.longitude,
      );
    });

    await _updateLocation(latLng.latitude, latLng.longitude, fetchLocality: true);

    if (_locationState.locality != null) {
      widget.args.safeLocationSelected(
        latLng.latitude,
        latLng.longitude,
        _locationState.locality!,
      );
    }
  }

  /// ✅ Resume live tracking when pressing FAB
  Future<void> _resumeTracking() async {
    _isManualSelection = false;
    _locationService.resumeLocationStream();
    await _initLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColor.mainAppColor,
        onPressed: _resumeTracking,
        child: Icon(Icons.my_location, color: AppColor.whiteColor),
      ),
      body: _buildBody(),
      bottomNavigationBar: _buildBottomPanel(),
    );
  }

  Widget _buildBody() {
    if (_locationState.isLoading) {
      return const Center(child: CustomLoading());
    }

    if (!_locationState.hasValidCoordinates) {
      return Center(child: Text('location_unavailable'.tr()));
    }

    return Stack(
      children: [
        GoogleMap(
          onTap: _onMapTap,
          markers: {
            Marker(
              markerId: const MarkerId("selectedLocation"),
              position: _locationState.latLng,
            ),
          },
          zoomControlsEnabled: false,
          onMapCreated: (controller) {
            _mapController = controller;
            _mapController?.animateCamera(
              CameraUpdate.newLatLng(_locationState.latLng),
            );
          },
          initialCameraPosition: CameraPosition(
            target: _locationState.latLng,
            zoom: _initialZoom,
          ),
        ),
        if (_locationState.locality != null)
          Positioned(
            top: 10,
            left: 20,
            right: 20,
            child: SafeArea(
              top: true,
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text(
                    _locationState.locality!,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildBottomPanel() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: CustomButton(
          text: AppLocaleKey.confirm.tr(),
          onPressed: () {
            if (_locationState.hasValidCoordinates) {
              widget.args.safeLocationSelected(
                _locationState.latitude!,
                _locationState.longitude!,
                _locationState.locality ?? 'Unknown Location',
              );
            }
            Navigator.pop(context);
          },
        ),
      ),
    );
  }
}
