import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_cancellable_tile_provider/flutter_map_cancellable_tile_provider.dart';
import 'package:hawiah_client/core/custom_widgets/custom-text-field-widget.dart'; // Ensure this path is correct
import 'package:hawiah_client/core/custom_widgets/custom_button.dart';
import 'package:hawiah_client/core/custom_widgets/custom_loading/custom_loading.dart';
import 'package:hawiah_client/core/images/app_images.dart';
import 'package:hawiah_client/core/locale/app_locale_key.dart';
import 'package:hawiah_client/core/theme/app_colors.dart';
import 'package:hawiah_client/core/theme/app_text_style.dart';
import 'package:hawiah_client/features/location/service/location_service.dart';
import 'package:latlong2/latlong.dart';

class LocationScreenArgs {
  final LatLng initialLatLng;
  final Function(LatLng latLng, String? locality, String? neighborhood) onLocationSelected;

  LocationScreenArgs({
    required this.initialLatLng,
    required this.onLocationSelected,
  });
}

class LocationScreen extends StatefulWidget {
  static const routeName = '/location-screen';
  const LocationScreen({Key? key, required this.args}) : super(key: key);
  final LocationScreenArgs args;

  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  final LocationService _locationService = LocationService();
  final MapController _mapController = MapController();

  bool _loading = true;
  bool _mapReady = false;

  double? _lat;
  double? _lng;
  String? _city;
  String? _neighborhood;
  String? _locality;
  String? _country;
  String? _stateRegion;
  String? _postalCode;
  String? _streetName;

  @override
  void initState() {
    super.initState();
    _initializeMap();
  }

  @override
  void dispose() {
    _locationService.dispose();
    super.dispose();
  }

  /// Initialize map with provided location
  Future<void> _initializeMap() async {
    await _updateLocation(
      widget.args.initialLatLng.latitude,
      widget.args.initialLatLng.longitude,
      fetchLocality: true,
      shouldAnimate: false,
    );
    setState(() => _loading = false);
  }

  Future<void> _updateLocation(
    double lat,
    double lng, {
    bool fetchLocality = false,
    bool shouldAnimate = false,
  }) async {
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
      _neighborhood = data['neighborhood'];
      _country = data['country'];
      _stateRegion = data['state'];
      _postalCode = data['postalCode'];
      _streetName = data['street'];
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

  /// 🔹 The Bottom Sheet to confirm/edit neighborhood and address details
  void _showAddressDetailsBottomSheet() {
    final TextEditingController cityController = TextEditingController(text: _city);
    final TextEditingController neighborhoodController = TextEditingController(text: _neighborhood);
    final TextEditingController streetController = TextEditingController(text: _streetName);
    final TextEditingController postalCodeController = TextEditingController(text: _postalCode);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 20,
            right: 20,
            top: 20,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppLocaleKey.addAddressDetails.tr(),
                      style: AppTextStyle.text18_700,
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                CustomTextField(
                  title: AppLocaleKey.city.tr(),
                  controller: cityController,
                  readOnly: true, // Usually city is fixed by GPS
                ),
                const SizedBox(height: 15),
                CustomTextField(
                  title: AppLocaleKey.neighborhood.tr(),
                  controller: neighborhoodController,
                  hintText: AppLocaleKey.neighborhood.tr(),
                ),
                const SizedBox(height: 15),
                CustomTextField(
                  title: AppLocaleKey.streetName.tr(),
                  controller: streetController,
                  hintText: AppLocaleKey.streetName.tr(),
                ),
                const SizedBox(height: 15),
                CustomTextField(
                  title: AppLocaleKey.postalCode.tr(),
                  controller: postalCodeController,
                  hintText: AppLocaleKey.postalCode.tr(),
                ),
                const SizedBox(height: 30),
                CustomButton(
                  text: AppLocaleKey.saveTitle.tr(),
                  onPressed: () {
                    Navigator.pop(context); // Close Bottom Sheet
                    Navigator.pop(context); // Close Location Screen

                    // Return the updated data back to the previous screen
                    widget.args.onLocationSelected.call(
                        LatLng(_lat!, _lng!),
                        streetController.text.isNotEmpty ? streetController.text : _locality,
                        neighborhoodController.text);
                  },
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _loading ? const Center(child: CustomLoading()) : _buildMap(),
      bottomNavigationBar: _buildConfirmButton(),
    );
  }

  Widget _buildMap() {
    return Stack(
      children: [
        FlutterMap(
          mapController: _mapController,
          options: MapOptions(
            initialCenter: LatLng(_lat ?? 24.7136, _lng ?? 46.6753),
            initialZoom: 14,
            onPositionChanged: _onPositionChanged,
            onMapEvent: (event) {
              if (event is MapEventMoveEnd) {
                _onMapIdle();
              }
            },
            onMapReady: () => _mapReady = true,
            cameraConstraint: CameraConstraint.unconstrained(),
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
            padding: const EdgeInsets.only(bottom: 35),
            child: Image.asset(
              AppImages.pinImage,
              height: 50,
              width: 50,
            ),
          ),
        ),

        /// 🔹 Address Card (Top of Map)
        if (_city != null || _locality != null || _neighborhood != null)
          Positioned(
            top: MediaQuery.of(context).padding.top + 20,
            left: 20,
            right: 20,
            child: Card(
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (_city != null)
                      Text(
                        _city!,
                        style: AppTextStyle.text16_700.copyWith(color: AppColor.mainAppColor),
                      ),
                    if (_neighborhood != null)
                      Text(_neighborhood!,
                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                    if (_locality != null) Text(_locality!, style: const TextStyle(fontSize: 14)),
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
              _showAddressDetailsBottomSheet();
            }
          },
        ),
      ),
    );
  }
}
