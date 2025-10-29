import 'dart:async';

import 'package:location/location.dart';

class LocationService {
  final Location _location = Location();
  StreamSubscription<LocationData>? _locationSubscription;
  bool _isListening = false;

  /// ✅ Get current location (with checks)
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

  /// ✅ Ensure location service is active
  Future<bool> checkAndRequestLocationService() async {
    bool serviceEnabled = await _location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await _location.requestService();
    }
    return serviceEnabled;
  }

  /// ✅ Ensure location permission is granted
  Future<bool> checkAndRequestLocationPermission() async {
    PermissionStatus permission = await _location.hasPermission();
    if (permission == PermissionStatus.deniedForever) return false;

    if (permission == PermissionStatus.denied) {
      permission = await _location.requestPermission();
    }
    return permission == PermissionStatus.granted;
  }

  /// ✅ Start location updates (callback)
  void listenToLocation(void Function(LocationData) onData) {
    _locationSubscription?.cancel();
    _isListening = true;
    _locationSubscription = _location.onLocationChanged.listen(onData);
  }

  /// ✅ Pause stream updates
  void pauseLocationStream() {
    _locationSubscription?.pause();
    _isListening = false;
  }

  /// ✅ Resume stream updates
  void resumeLocationStream() {
    if (_locationSubscription != null && !_isListening) {
      _locationSubscription?.resume();
      _isListening = true;
    }
  }

  /// ✅ Stop everything
  void dispose() {
    _locationSubscription?.cancel();
  }
}
