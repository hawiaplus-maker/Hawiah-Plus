// ====== LocationState (اضافة city) ======
import 'package:latlong2/latlong.dart';

class LocationState {
  final double? latitude;
  final double? longitude;
  final String? locality; // full address-like string
  final String? city; // city only
  final bool isLoading;
  final String? error;

  const LocationState({
    this.latitude,
    this.longitude,
    this.locality,
    this.city,
    this.isLoading = false,
    this.error,
  });

  LocationState copyWith({
    double? latitude,
    double? longitude,
    String? locality,
    String? city,
    bool? isLoading,
    String? error,
  }) {
    return LocationState(
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      locality: locality ?? this.locality,
      city: city ?? this.city,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }

  bool get hasValidCoordinates => latitude != null && longitude != null;
  LatLng get latLng => LatLng(latitude ?? 0, longitude ?? 0);
}
