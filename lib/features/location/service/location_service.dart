import 'dart:async';

import 'package:geocoding/geocoding.dart' hide Location;
import 'package:location/location.dart';

class LocationService {
  final Location _location = Location();
  StreamSubscription<LocationData>? _locationSubscription;
  bool _isListening = false;

  // آخر قيم محفوظة
  double? lastLat;
  double? lastLng;
  String? lastCity;
  String? lastLocality;

  /// Get current location
  Future<LocationData?> getCurrentLocation() async {
    try {
      if (await checkAndRequestLocationService() && await checkAndRequestLocationPermission()) {
        return await _location.getLocation();
      }
      return null;
    } catch (e) {
      print("Error getting location: $e");
      return null;
    }
  }

  /// Check Service
  Future<bool> checkAndRequestLocationService() async {
    bool enabled = await _location.serviceEnabled();
    if (!enabled) {
      enabled = await _location.requestService();
    }
    return enabled;
  }

  /// Check Permission
  Future<bool> checkAndRequestLocationPermission() async {
    PermissionStatus permission = await _location.hasPermission();
    if (permission == PermissionStatus.deniedForever) return false;

    if (permission == PermissionStatus.denied) {
      permission = await _location.requestPermission();
    }
    return permission == PermissionStatus.granted;
  }

  /// Listen to GPS
  void listenToLocation(void Function(LocationData) onData) {
    _locationSubscription?.cancel();
    _isListening = true;
    _locationSubscription = _location.onLocationChanged.listen(onData);
  }

  /// Pause
  void pauseLocationStream() {
    _locationSubscription?.pause();
    _isListening = false;
  }

  /// Resume
  void resumeLocationStream() {
    if (_locationSubscription != null && !_isListening) {
      _locationSubscription?.resume();
      _isListening = true;
    }
  }

  /// Update location + reverse geocode (city / locality)
  Future<Map<String, dynamic>> updateLocation(
    double lat,
    double lng, {
    bool fetchLocality = false,
  }) async {
    lastLat = lat;
    lastLng = lng;

    String? city;
    String? locality;

    if (fetchLocality) {
      try {
        final placemarks = await placemarkFromCoordinates(lat, lng);
        if (placemarks.isNotEmpty) {
          final p = placemarks.first;

          // ⬅ السعودية: المدن بترجع بشكل ممتاز هنا
          city =
              p.locality?.trim() ?? p.subAdministrativeArea?.trim() ?? p.administrativeArea?.trim();

          locality = [
            p.street,
            p.subLocality,
            city,
            p.postalCode,
          ].where((v) => v != null && v.isNotEmpty).join(", ");
        }
      } catch (e) {
        print("Reverse geocode error: $e");
      }
    }

    lastCity = city ?? lastCity;
    lastLocality = locality ?? lastLocality;

    return {
      'lat': lastLat,
      'lng': lastLng,
      'city': lastCity,
      'locality': lastLocality,
    };
  }

  /// Configure update interval
  Future<void> configure({
    int intervalMs = 5000,
    double distanceFilter = 10,
  }) async {
    try {
      await _location.changeSettings(
        interval: intervalMs,
        distanceFilter: distanceFilter,
        accuracy: LocationAccuracy.high,
      );
    } catch (e) {
      print("changeSettings error: $e");
    }
  }

  /// Clean up
  void dispose() {
    _locationSubscription?.cancel();
  }
}
