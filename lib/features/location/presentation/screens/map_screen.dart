import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_cancellable_tile_provider/flutter_map_cancellable_tile_provider.dart';
import 'package:hawiah_client/core/custom_widgets/custom-text-field-widget.dart';
import 'package:hawiah_client/core/custom_widgets/custom_button.dart';
import 'package:hawiah_client/core/custom_widgets/custom_loading/custom_loading.dart';
import 'package:hawiah_client/core/images/app_images.dart';
import 'package:hawiah_client/core/locale/app_locale_key.dart';
import 'package:hawiah_client/core/theme/app_colors.dart';
import 'package:hawiah_client/core/theme/app_text_style.dart';
import 'package:hawiah_client/features/location/presentation/cubit/address_cubit.dart';
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

class _MapScreenState extends State<MapScreen> with WidgetsBindingObserver {
  final LocationService _locationService = LocationService();

  final MapController _mapController = MapController();

  bool _loading = true;
  bool _isInitializing = false;
  bool _manualSelection = false;
  bool _mapReady = false;

  double? _lat;
  double? _lng;
  String? _city;
  String? _locality;
  String? _country;
  String? _stateRegion;
  String? _postalCode;
  String? _streetName;
  String? _neighborhoodName;

  DateTime? _lastUpdate;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initializeMapQuickly();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _locationService.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      if (_lat == 24.7136 && _lng == 46.6753 && !_loading && !_isInitializing) {
        _fetchUserLocationInBackground();
      }
    }
  }

  /// Initialize map immediately with default location, then fetch GPS in background
  Future<void> _initializeMapQuickly() async {
    // If initial coordinates provided, use them
    if (widget.args.initialLat != null && widget.args.initialLng != null) {
      await _updateLocation(
        widget.args.initialLat!,
        widget.args.initialLng!,
        fetchLocality: true,
        shouldAnimate: false,
      );
      _manualSelection = true;
      setState(() => _loading = false);
    } else {
      // Show map immediately at Riyadh
      setState(() {
        _lat = 24.7136;
        _lng = 46.6753;
        _loading = false;
      });

      // Fetch user location in background
      _fetchUserLocationInBackground();
    }
  }

  Future<void> _fetchUserLocationInBackground() async {
    if (_isInitializing) return;
    _isInitializing = true;

    try {
      final isServiceEnabled = await _locationService.checkAndRequestLocationService();
      if (!isServiceEnabled) {
        _isInitializing = false;
        _showLocationServiceDialog();
        return;
      }

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
      // If GPS fails, keep the default Riyadh location (no update needed)
    } finally {
      _isInitializing = false;
    }
  }

  void _showLocationServiceDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text(AppLocaleKey.locationRequired.tr()),
        content: Text(AppLocaleKey.enableLocationService.tr()),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppLocaleKey.cancel.tr()),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              _fetchUserLocationInBackground();
            },
            child: Text(AppLocaleKey.openSettings.tr()),
          ),
        ],
      ),
    );
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
      _country = data['country'];
      _stateRegion = data['state'];
      _postalCode = data['postalCode'];
      _streetName = data['street'];
      _neighborhoodName = data['neighborhood'];
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
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColor.mainAppColor,
        child: const Icon(Icons.my_location, color: Colors.white),
        onPressed: _goToCurrentLocation,
      ),
      body: _loading ? const Center(child: CustomLoading()) : _buildMap(),
      bottomNavigationBar: _buildConfirmButton(),
    );
  }

  void _showAddressDetailsBottomSheet() {
    final TextEditingController countryController = TextEditingController(text: _country);
    final TextEditingController cityController = TextEditingController(text: _city);
    final TextEditingController stateController = TextEditingController(text: _stateRegion);
    final TextEditingController postalCodeController = TextEditingController(text: _postalCode);
    final TextEditingController streetController = TextEditingController(text: _streetName);
    final TextEditingController neighborhoodController =
        TextEditingController(text: _neighborhoodName);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return BlocProvider(
          create: (context) => AddressCubit(),
          child: StatefulBuilder(
            builder: (context, setModalState) {
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
                          IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () => Navigator.pop(context),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                AppLocaleKey.addAddressDetails.tr(),
                                style: AppTextStyle.text18_700,
                              ),
                              Text(
                                AppLocaleKey.addressDetailsSubtitle.tr(),
                                style: AppTextStyle.text14_400.copyWith(color: Colors.grey),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(
                            child: CustomTextField(
                              title: AppLocaleKey.city.tr(),
                              controller: cityController,
                              readOnly: true,
                            ),
                          ),
                          const SizedBox(width: 15),
                          Expanded(
                            child: CustomTextField(
                              title: AppLocaleKey.country.tr(),
                              controller: countryController,
                              readOnly: true,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      Row(
                        children: [
                          Expanded(
                            child: CustomTextField(
                              title: AppLocaleKey.postalCode.tr(),
                              controller: postalCodeController,
                            ),
                          ),
                          const SizedBox(width: 15),
                          Expanded(
                            child: CustomTextField(
                              title: AppLocaleKey.stateRegion.tr(),
                              controller: stateController,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      CustomTextField(
                        title: AppLocaleKey.streetName.tr(),
                        controller: streetController,
                      ),
                      const SizedBox(height: 15),
                      CustomTextField(
                        title: AppLocaleKey.neighborhood.tr(),
                        controller: neighborhoodController,
                      ),
                      const SizedBox(height: 30),
                      CustomButton(
                        text: AppLocaleKey.saveTitle.tr(),
                        onPressed: () {
                          context.read<AddressCubit>().storeAddress(
                                title: streetController.text.isNotEmpty
                                    ? streetController.text
                                    : (_locality ?? ""),
                                latitude: _lat!,
                                longitude: _lng!,
                                address: "${cityController.text}_${neighborhoodController.text}",
                                onSuccess: () {
                                  Navigator.pop(context); // Close Bottom Sheet
                                  Navigator.pop(context); // Close Map Screen
                                  widget.args.onLocationSelected?.call(
                                    _lat!,
                                    _lng!,
                                    _city ?? "",
                                    _locality ?? "",
                                  );
                                },
                              );
                        },
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
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
              _showAddressDetailsBottomSheet();
            }
          },
        ),
      ),
    );
  }
}
