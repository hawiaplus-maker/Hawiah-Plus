// add_new_location_screen.dart
import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_cancellable_tile_provider/flutter_map_cancellable_tile_provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hawiah_client/core/custom_widgets/custom-text-field-widget.dart';
import 'package:hawiah_client/core/custom_widgets/custom_app_bar.dart';
import 'package:hawiah_client/core/custom_widgets/custom_button.dart';
import 'package:hawiah_client/core/custom_widgets/custom_select/custom_select_item.dart';
import 'package:hawiah_client/core/custom_widgets/custom_select/custom_single_select.dart';
import 'package:hawiah_client/core/images/app_images.dart';
import 'package:hawiah_client/core/locale/app_locale_key.dart';
import 'package:hawiah_client/core/theme/app_colors.dart';
import 'package:hawiah_client/core/theme/app_text_style.dart';
import 'package:hawiah_client/core/utils/navigator_methods.dart';
import 'package:hawiah_client/core/utils/validation_methods.dart';
import 'package:hawiah_client/features/location/presentation/cubit/address_cubit.dart';
import 'package:hawiah_client/features/location/presentation/cubit/address_state.dart';
import 'package:hawiah_client/features/location/presentation/model/neighborhood_model.dart';
import 'package:hawiah_client/features/location/presentation/screens/map_screen.dart';
import 'package:hawiah_client/features/location/service/location_service.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';

typedef OnLocationSelected = void Function(
  double lat,
  double lng,
  String city,
  String fullAddress,
);

class AddNewLocationScreenArgs {
  final void Function() onAddressAdded;
  final double? lat;
  final double? lng;
  final String? city;
  final String? locality;

  AddNewLocationScreenArgs({
    required this.onAddressAdded,
    this.lat,
    this.lng,
    this.city,
    this.locality,
  });
}

class AddNewLocationScreen extends StatefulWidget {
  static const String routeName = '/addNewLocation';
  final AddNewLocationScreenArgs args;

  const AddNewLocationScreen({super.key, required this.args});

  @override
  State<AddNewLocationScreen> createState() => _AddNewLocationScreenState();
}

class _AddNewLocationScreenState extends State<AddNewLocationScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController titleController = TextEditingController();
  final LocationService locationService = LocationService();
  final MapController _mapController = MapController();

  int? selectedCity;
  int? selectedNeighborhood;
  LatLng? currentPosition;
  bool _mapReady = false;
  String currentAddress = "Getting location...";
  String? city;
  List<NeighborhoodModel> neighborhoods = [];
  double? lat;
  double? lng;

  @override
  void initState() {
    super.initState();
    _setupInitialData();
  }

  Future<void> _initializeLocation() async {
    final LocationData? location = await locationService.getCurrentLocation();
    if (location != null && mounted) {
      setState(() {
        currentPosition = LatLng(location.latitude!, location.longitude!);
        currentAddress = "${location.latitude}, ${location.longitude}";
        lat = location.latitude;
        lng = location.longitude;
      });
      _updateCameraPosition();
    }
  }

  Future<void> _updateCameraPosition() async {
    if (currentPosition != null && _mapReady) {
      _mapController.move(currentPosition!, 15); // Increased zoom for better UX
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    locationService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AddressCubit(),
      child: Scaffold(
        appBar: CustomAppBar(
          context,
          titleText: AppLocaleKey.addNewAddress.tr(),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
          child: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Container(
                margin: EdgeInsets.all(5),
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColor.lightGreyColor),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppLocaleKey.map.tr(),
                      style: AppTextStyle.text14_600,
                    ),
                    SizedBox(height: 10.h),
                    _buildMapSection(),
                    SizedBox(height: 10.h),
                    CustomTextField(
                      title: AppLocaleKey.locationName.tr(),
                      validator: ValidationMethods.validateEmptyField,
                      controller: titleController,
                      hintText: AppLocaleKey.address.tr(),
                      onChanged: (String value) => {},
                    ),
                    SizedBox(height: 15.h),
                    _buildLocationSelectors(),
                    SizedBox(height: 15.h),
                  ],
                ),
              ),
            ),
          ),
        ),
        bottomNavigationBar: _buildBottomActions(),
      ),
    );
  }

  Widget _buildLocationSelectors() {
    return BlocConsumer<AddressCubit, AddressState>(
      listener: (BuildContext context, AddressState state) {
        if (state is AddressError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      builder: (BuildContext context, AddressState state) {
        final AddressCubit addressCubit = context.read<AddressCubit>();
        return Column(
          children: [
            // CustomSingleSelect(
            //   title: AppLocaleKey.city.tr(),
            //   hintText: city ?? AppLocaleKey.cityHint.tr(),
            //   hintStyle: city != null ? AppTextStyle.textFormStyle : AppTextStyle.hintStyle,
            //   value: city == null ? selectedCity : null,
            //   items: addressCubit.citys
            //       .map((e) => CustomSelectItem(
            //             name: e.title ?? "",
            //             value: e.id,
            //           ))
            //       .toList(),
            //   onChanged: (v) {
            //     if (v != null) {
            //       context.read<AddressCubit>().getneighborhoods(v);
            //       setState(() {
            //         this.city = null;
            //         selectedCity = v;

            //         selectedNeighborhood = null;
            //       });
            //     }
            //   },
            // ),
            // SizedBox(height: 15.h),
            CustomSingleSelect(
              title: AppLocaleKey.neighborhood.tr(),
              hintText: AppLocaleKey.cityHint.tr(),
              apiResponse: addressCubit.neighborhoodsResponse,
              value: selectedNeighborhood,
              suffixIcon: Icon(
                Icons.arrow_drop_down,
                size: 25,
                color: AppColor.blackColor,
              ),
              items: neighborhoods.isNotEmpty
                  ? neighborhoods
                      .map((e) => CustomSelectItem(
                            name: e.title ?? "",
                            value: e.id,
                          ))
                      .toList()
                  : addressCubit.neighborhoods
                      .map((e) => CustomSelectItem(
                            name: e.title ?? "",
                            value: e.id,
                          ))
                      .toList(),
              onChanged: (v) {
                if (v != null) {
                  setState(() {
                    selectedNeighborhood = v;
                  });
                }
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildMapSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: SizedBox(
            height: 200.h,
            child: FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                initialCenter: currentPosition ?? const LatLng(24.7136, 46.6753),
                initialZoom: 20,
                onTap: (tapPosition, point) {
                  NavigatorMethods.pushNamed(
                    context,
                    MapScreen.routeName,
                    arguments: MapScreenArgs(
                      initialLat: this.lat,
                      initialLng: this.lng,
                      onLocationSelected: (newLat, newLng, newCity, newLocality) {
                        if (newLat == this.lat && newLng == this.lng) return;

                        final bool cityChanged = newCity != this.city;

                        setState(() {
                          this.lat = newLat;
                          this.lng = newLng;
                          this.city = newCity;
                          this.currentAddress = newLocality;
                          this.currentPosition = LatLng(newLat, newLng);
                          if (cityChanged) {
                            this.selectedNeighborhood = null;
                            this.neighborhoods = [];
                          }
                        });

                        if (cityChanged && newCity.isNotEmpty) {
                          context.read<AddressCubit>().getneighborhoodsByName(newCity, (list) {
                            setState(() => this.neighborhoods = list);
                          });
                        }
                        _updateCameraPosition();
                      },
                    ),
                  );
                },
                onMapReady: () => _mapReady = true,
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.futuretec.hawiahplus',
                  keepBuffer: 2,
                  panBuffer: 1,
                  tileProvider: CancellableNetworkTileProvider(),
                ),
                if (currentPosition != null)
                  MarkerLayer(
                    markers: [
                      Marker(
                        point: currentPosition!,
                        width: 40,
                        height: 40,
                        child: Image.asset(
                          AppImages.pinImage,
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
        SizedBox(height: 10.h),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
          decoration: BoxDecoration(
            color: const Color(0xffF9F9F9),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: const Color(0xffEEEEEE)),
          ),
          child: Row(
            children: [
              Icon(Icons.location_on, color: AppColor.mainAppColor, size: 20),
              SizedBox(width: 8.w),
              Expanded(
                child: Text(
                  currentAddress,
                  style: AppTextStyle.textFormStyle.copyWith(fontSize: 13.sp),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBottomActions() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomButton(
              text: AppLocaleKey.saveTitle.tr(),
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  _saveAddress();
                }
              },
            ),
            SizedBox(height: 10.h),
            CustomButton(
              color: AppColor.secondAppColor,
              text: AppLocaleKey.cancel.tr(),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _saveAddress() {
    if (currentPosition == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select a location on the map")),
      );
      return;
    }

    if (selectedNeighborhood == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select a neighborhood")),
      );
      return;
    }

    context.read<AddressCubit>().storeAddress(
          title: titleController.text,
          latitude: currentPosition!.latitude,
          longitude: currentPosition!.longitude,
          neighborhoodId: selectedNeighborhood!,
          onSuccess: () {
            Navigator.pop(context);
            widget.args.onAddressAdded();
          },
        );
  }

  void safeLocationSelected(double lat, double lng, String city, String locality) {
    if (!mounted) return;

    setState(() {
      currentPosition = LatLng(lat, lng); // Create new instance
      currentAddress = locality;
      this.lat = lat;
      this.lng = lng;
      _updateCameraPosition();
    });
  }

  void _setupInitialData() {
    // نستخدم Future.delayed لأننا بحاجة للوصول لـ context في initState لاستخدام الـ Cubit
    Future.delayed(Duration.zero, () async {
      final args = widget.args;
      if (args.lat != null && args.lng != null) {
        setState(() {
          lat = args.lat;
          lng = args.lng;
          city = args.city;
          currentAddress = args.locality ?? "";
          currentPosition = LatLng(lat!, lng!);
        });

        // 2. جلب الأحياء فوراً بناءً على المدينة القادمة من الخريطة
        if (city != null && city!.isNotEmpty) {
          context.read<AddressCubit>().getneighborhoodsByName(city!, (list) {
            setState(() {
              neighborhoods = list;
            });
          });
        }
        _updateCameraPosition();
      } else {
        // إذا لم تأتِ بيانات، نجلب الموقع الحالي فقط في هذه الحالة
        await _initializeLocation();
      }
    });
  }
}
