import 'dart:async';
import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hawiah_client/core/custom_widgets/custom_button.dart';
import 'package:hawiah_client/core/custom_widgets/custom_loading/custom_loading.dart';
import 'package:hawiah_client/core/locale/app_locale_key.dart';
import 'package:hawiah_client/features/location/service/location_service.dart';

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
    _determineInitialPosition();
  }

  @override
  void dispose() {
    _locationService.dispose();
    super.dispose();
  }

  Future<void> _determineInitialPosition() async {
    setState(() => _locationState = _locationState.copyWith(isLoading: true));

    try {
      final location = await _locationService.getCurrentLocation();
      if (location?.latitude != null && location?.longitude != null) {
        await _updateLocationState(
          location!.latitude!,
          location.longitude!,
          fetchLocality: true,
        );
      }
    } catch (e) {
      setState(() {
        _locationState = _locationState.copyWith(
          isLoading: false,
          error: 'location_error'.tr(),
        );
      });
    }
  }

  Future<void> _updateLocationState(
    double lat,
    double lng, {
    bool fetchLocality = false,
  }) async {
    String? locality;

    if (fetchLocality) {
      try {
        final placemarks = await placemarkFromCoordinates(lat, lng);
        if (placemarks.isNotEmpty) {
          final place = placemarks.first;
          locality = [
            place.street,
            place.locality,
            place.postalCode
          ].where((e) => e?.isNotEmpty == true).join(', ');
        }
      } catch (e) {
        log("Placemark error: $e");
      }
    }

    setState(() {
      _locationState = _locationState.copyWith(
        latitude: lat,
        longitude: lng,
        locality: locality,
        isLoading: false,
        error: null,
      );
    });

    _mapController?.animateCamera(CameraUpdate.newLatLng(LatLng(lat, lng)));
  }

  Future<void> _onMapTap(LatLng latLng) async {
    _locationService.pauseLocationStream();
    _isManualSelection = true;

    // Immediately update position
    setState(() {
      _locationState = _locationState.copyWith(
        latitude: latLng.latitude,
        longitude: latLng.longitude,
      );
    });

    // Fetch locality asynchronously
    await _updateLocationState(
      latLng.latitude,
      latLng.longitude,
      fetchLocality: true,
    );

    // Notify parent with locality
    if (_locationState.locality != null) {
      widget.args.safeLocationSelected(
        latLng.latitude,
        latLng.longitude,
        _locationState.locality!,
      );
    }
  }

  Future<void> _resumeLocationTracking() async {
    _isManualSelection = false;
    _locationService.resumeLocationStream();
    await _determineInitialPosition();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        onPressed: _resumeLocationTracking,
        child: const Icon(Icons.my_location),
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
      return Center(
        child: Text('location_unavailable'.tr()),
      );
    }

    return GoogleMap(
      onTap: _onMapTap,
      markers: {
        Marker(
          markerId: const MarkerId("selectedLocation"),
          position: _locationState.latLng,
        )
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
    );
  }

  Widget _buildBottomPanel() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (_locationState.locality != null)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text(
                    _locationState.locality!,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
              ),
            const SizedBox(height: 8),
            CustomButton(
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
          ],
        ),
      ),
    );
  }
}