// add_new_location_screen.dart
import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hawiah_client/core/custom_widgets/api_response_widget.dart';
import 'package:hawiah_client/core/custom_widgets/custom-text-field-widget.dart';
import 'package:hawiah_client/core/custom_widgets/custom_app_bar.dart';
import 'package:hawiah_client/core/custom_widgets/custom_select/custom_select_item.dart';
import 'package:hawiah_client/core/custom_widgets/custom_select/custom_single_select.dart';
import 'package:hawiah_client/core/custom_widgets/global-elevated-button-widget.dart';
import 'package:hawiah_client/core/images/app_images.dart';
import 'package:hawiah_client/core/locale/app_locale_key.dart';
import 'package:hawiah_client/core/theme/app_colors.dart';
import 'package:hawiah_client/core/utils/navigator_methods.dart';
import 'package:hawiah_client/core/utils/validation_methods.dart';
import 'package:hawiah_client/features/location/presentation/cubit/address_cubit.dart';
import 'package:hawiah_client/features/location/presentation/cubit/address_state.dart';
import 'package:hawiah_client/features/location/presentation/screens/map_screen.dart';
import 'package:hawiah_client/features/location/service/location_service.dart';
import 'package:location/location.dart';

class AddNewLocationScreen extends StatefulWidget {
  static const String routeName = '/addNewLocation';

  const AddNewLocationScreen({super.key});

  @override
  State<AddNewLocationScreen> createState() => _AddNewLocationScreenState();
}

class _AddNewLocationScreenState extends State<AddNewLocationScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController titleController = TextEditingController();
  final LocationService locationService = LocationService();
  final Completer<GoogleMapController> mapController = Completer();

  int? selectedCity;
  int? selectedNeighborhood;
  LatLng? currentPosition;
  String currentAddress = "Getting location...";

  @override
  void initState() {
    super.initState();
    _initializeLocation();
  }

  Future<void> _initializeLocation() async {
    final LocationData? location = await locationService.getCurrentLocation();
    if (location != null && mounted) {
      setState(() {
        currentPosition = LatLng(location.latitude!, location.longitude!);
        currentAddress = "${location.latitude}, ${location.longitude}";
      });
      _updateCameraPosition();
    }
  }

  Future<void> _updateCameraPosition() async {
    if (currentPosition != null) {
      final GoogleMapController controller = await mapController.future;
      controller.animateCamera(
        CameraUpdate.newLatLng(currentPosition!),
      );
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
      create: (BuildContext context) => AddressCubit()..getcitys(),
      child: Scaffold(
        appBar: CustomAppBar(
          context,
          titleText: AppLocaleKey.addNewAddress.tr(),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLocaleKey.currentAddress.tr(),
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 15.sp,
                    ),
                  ),
                  SizedBox(height: 10.h),
                  _buildCurrentAddress(),
                  SizedBox(height: 10.h),
                  CustomTextField(
                    validator: ValidationMethods.validateEmptyField,
                    controller: titleController,
                    labelText: AppLocaleKey.address.tr(),
                    onChanged: (String value) => {},
                  ),
                  SizedBox(height: 20.h),
                  _buildLocationSelectors(),
                  SizedBox(height: 20.h),
                  _buildMapSection(),
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: _buildBottomActions(),
      ),
    );
  }

  Widget _buildCurrentAddress() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xffF9F9F9),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xffF9F9F9)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            AppImages.locationMapIcon,
            height: 20,
            width: 20,
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Text(
              currentAddress,
              style: TextStyle(
                color: Colors.black,
                fontSize: 15.sp,
              ),
            ),
          ),
        ],
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
        return ApiResponseWidget(
          loadingWidget: const SizedBox(),
          apiResponse: addressCubit.citysResponse,
          onReload: () => addressCubit.getcitys(),
          isEmpty: addressCubit.citys.isEmpty,
          child: Column(
            children: [
              CustomSingleSelect(
                hintText: AppLocaleKey.city.tr(),
                value: selectedCity,
                items: addressCubit.citys
                    .map((e) => CustomSelectItem(
                          name: e.title ?? "",
                          value: e.id,
                        ))
                    .toList(),
                onChanged: (v) {
                  if (v != null) {
                    context.read<AddressCubit>().getneighborhoods(v);
                    setState(() {
                      selectedCity = v;
                      selectedNeighborhood = null;
                    });
                  }
                },
              ),
              SizedBox(height: 20.h),
              CustomSingleSelect(
                hintText: AppLocaleKey.neighborhood.tr(),
                apiResponse: addressCubit.neighborhoodsResponse,
                value: selectedNeighborhood,
                items: addressCubit.neighborhoods
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
          ),
        );
      },
    );
  }

  Widget _buildMapSection() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: SizedBox(
        height: 300.h,
        child: GoogleMap(
          onMapCreated: (GoogleMapController controller) {
            mapController.complete(controller);
          },
          onTap: (LatLng argument) async {
            NavigatorMethods.pushNamed(context, MapScreen.routeName,
                arguments: MapScreenArgs(
              onLocationSelected: (lat, lng, locality) {
                safeLocationSelected(lat, lng, locality);
              },
            ));

            _updateCameraPosition();
          },
          initialCameraPosition: CameraPosition(
            target: currentPosition ?? const LatLng(24.7136, 46.6753),
            zoom: 12,
          ),
          markers: currentPosition != null
              ? <Marker>{
                  Marker(
                    markerId: const MarkerId("currentLocation"),
                    position: currentPosition!,
                  ),
                }
              : <Marker>{},
        ),
      ),
    );
  }

  Widget _buildBottomActions() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Row(
        //   crossAxisAlignment: CrossAxisAlignment.center,
        //   mainAxisAlignment: MainAxisAlignment.center,
        //   children: [
        //     Image.asset(
        //       "assets/icons/check_icon.png",
        //       height: 20,
        //       width: 20,
        //     ),
        //     SizedBox(width: 10.w),
        //     Text(
        //       "جعل هذا العنوان عنواني الإفتراضي",
        //       style: TextStyle(
        //         color: Colors.black,
        //         fontSize: 15.sp,
        //       ),
        //     ),
        //   ],
        // ),
        SizedBox(height: 20.h),
        GlobalElevatedButton(
          label: "إضافة العنوان",
          onPressed: () {
            if (formKey.currentState!.validate()) {
              _saveAddress();
            }
          },
          backgroundColor: AppColor.mainAppColor,
          textColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          borderRadius: BorderRadius.circular(10),
          fixedWidth: 0.80,
        ),
        SizedBox(height: 20.h),
      ],
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
          onSuccess: () => Navigator.pop(context),
        );
  }

  void safeLocationSelected(double lat, double lng, String locality) {
    if (!mounted) return;

    setState(() {
      currentPosition = LatLng(lat, lng); // Create new instance
      currentAddress = locality;
      _updateCameraPosition();
    });
  }
}

// Additional strongly typed models
