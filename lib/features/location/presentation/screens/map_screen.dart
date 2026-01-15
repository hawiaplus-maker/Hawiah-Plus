import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_cancellable_tile_provider/flutter_map_cancellable_tile_provider.dart';
import 'package:hawiah_client/core/custom_widgets/custom_button.dart';
import 'package:hawiah_client/core/custom_widgets/custom_loading/custom_loading.dart';
import 'package:hawiah_client/core/images/app_images.dart';
import 'package:hawiah_client/core/locale/app_locale_key.dart';
import 'package:hawiah_client/core/theme/app_colors.dart';
import 'package:hawiah_client/core/theme/app_text_style.dart';
import 'package:hawiah_client/core/utils/navigator_methods.dart';
import 'package:hawiah_client/features/location/presentation/screens/add-new-location-screen.dart';
import 'package:hawiah_client/features/location/service/location_service.dart';
import 'package:latlong2/latlong.dart';

typedef OnLocationSelected = void Function(
  double lat,
  double lng,
  String city,
  String fullAddress,
);

class MapScreenArgs {
  final OnLocationSelected? onLocationSelected;
  final double? initialLat;
  final double? initialLng;

  const MapScreenArgs({this.onLocationSelected, this.initialLat, this.initialLng});
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

  final MapController _mapController = MapController();

  bool _loading = true;
  bool _manualSelection = false;
  bool _mapReady = false;

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
    bool shouldAnimate = false,
  }) async {
    // Restrict to Saudi Arabia bounds if necessary, though cameraTargetBounds handles it for the UI
    final data = await _locationService.updateLocation(
      lat,
      lng,
      fetchLocality: fetchLocality,
    );

    if (!mounted) return;

    setState(() {
      _lat = lat;
      _lng = lng;
      _city = data['city'];
      _locality = data['locality'];
    });

    if (shouldAnimate && _mapReady) {
      _mapController.move(LatLng(_lat!, _lng!), 14);
    }
  }

  void _onPositionChanged(MapCamera camera, bool hasGesture) {
    if (hasGesture) {
      _lat = camera.center.latitude;
      _lng = camera.center.longitude;
    }
  }

  Future<void> _onMapIdle() async {
    if (_lat != null && _lng != null) {
      await _updateLocation(_lat!, _lng!, fetchLocality: true);
    }
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
        FlutterMap(
          mapController: _mapController,
          options: MapOptions(
            initialCenter: LatLng(_lat!, _lng!),
            initialZoom: 14,
            onPositionChanged: _onPositionChanged,
            onMapEvent: (event) {
              if (event is MapEventMoveEnd) {
                _onMapIdle();
              }
            },
            onMapReady: () => _mapReady = true,
            // Restrict to Saudi Arabia
            cameraConstraint: CameraConstraint.unconstrained(),
            onPointerDown: (event, point) {
              setState(() {
                _manualSelection = true;
              });
              _locationService.pauseLocationStream();
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

        /// 🔹 Center Pin
        Center(
          child: Padding(
            padding:
                const EdgeInsets.only(bottom: 35), // Offset to put the tip of the pin at the center
            child: Image.asset(
              AppImages.pinImage,
              height: 50,
              width: 50,
            ),
          ),
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
              _locationService.dispose();
              widget.args.onLocationSelected?.call(
                _lat ?? 0.0,
                _lng ?? 0.0,
                _city ?? "",
                _locality ?? "",
              );
              NavigatorMethods.pushReplacementNamed(context, AddNewLocationScreen.routeName,
                  arguments: AddNewLocationScreenArgs(
                    onAddressAdded: () {
                      widget.args.onLocationSelected?.call(
                        _lat ?? 0.0,
                        _lng ?? 0.0,
                        _city ?? "",
                        _locality ?? "",
                      );
                    },
                    lat: _lat,
                    lng: _lng,
                    city: _city,
                    locality: _locality,
                  ));
            }
            // Navigator.pop(context);
          },
        ),
      ),
    );
  }
}
