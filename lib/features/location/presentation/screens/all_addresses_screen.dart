import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hawiah_client/core/custom_widgets/api_response_widget.dart';
import 'package:hawiah_client/core/custom_widgets/custom_app_bar.dart';
import 'package:hawiah_client/core/custom_widgets/custom_button.dart';
import 'package:hawiah_client/core/custom_widgets/no_data_widget.dart';
import 'package:hawiah_client/core/images/app_images.dart';
import 'package:hawiah_client/core/locale/app_locale_key.dart';
import 'package:hawiah_client/core/theme/app_colors.dart';
import 'package:hawiah_client/core/utils/navigator_methods.dart';
import 'package:hawiah_client/features/authentication/presentation/screens/register-screen.dart';
import 'package:hawiah_client/features/authentication/presentation/screens/validate_mobile_screen.dart';
import 'package:hawiah_client/features/home/presentation/widgets/location-item-widget.dart';
import 'package:hawiah_client/features/location/presentation/cubit/address_cubit.dart';
import 'package:hawiah_client/features/location/presentation/cubit/address_state.dart';
import 'package:hawiah_client/features/location/presentation/screens/location-map-screen.dart';
import 'package:hawiah_client/features/location/presentation/screens/map_screen.dart';
import 'package:hawiah_client/features/profile/presentation/cubit/cubit_profile.dart';
import 'package:hawiah_client/features/profile/presentation/cubit/state_profile.dart';
import 'package:latlong2/latlong.dart';

class AllAddressesScreen extends StatelessWidget {
  static const routeName = '/all-addresses-screen';
  const AllAddressesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AddressCubit()
        ..initialaddresses()
        ..getaddresses(),
      child: Scaffold(
        extendBody: true,
        appBar: CustomAppBar(
          context,
          titleText: AppLocaleKey.addresses.tr(),
        ),
        body: BlocBuilder<ProfileCubit, ProfileState>(builder: (context, state) {
          if (state is ProfileUnAuthorized) {
            unAuthorizedDialog(context);
            return const SizedBox.shrink();
          }

          return BlocBuilder<AddressCubit, AddressState>(builder: (BuildContext context, state) {
            AddressCubit addressCubit = context.read<AddressCubit>();
            if (addressCubit.addressesResponse == []) {
              addressCubit.getaddresses();
            }

            return ApiResponseWidget(
              apiResponse: addressCubit.addressesResponse,
              onReload: () => addressCubit.getaddresses(),
              isEmpty: addressCubit.addresses.isEmpty,
              emptyWidget: ListView(
                children: [
                  SizedBox(
                    height: 100.h,
                  ),
                  NoDataWidget(
                    message: AppLocaleKey.noAddresses.tr(),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: CustomButton(
                      text: "add_new_address".tr(),
                      onPressed: () {
                        NavigatorMethods.pushNamed(context, MapScreen.routeName,
                            arguments: MapScreenArgs(
                          onLocationSelected: (lat, lng, city, fullAddress) {
                            addressCubit.getaddresses();
                          },
                        ));
                      },
                    ),
                  ),
                ],
              ),
              child: ListView.builder(
                itemCount: addressCubit.addresses.length + 1, // Add 1 for extra item
                itemBuilder: (context, index) {
                  // Render addresses for existing indices
                  if (index < addressCubit.addresses.length) {
                    return LocationItemWidget(
                      imagePath: AppImages.addressLocationIcon,
                      title: addressCubit.addresses[index].title ?? "",
                      address: "${addressCubit.addresses[index].neighborhood ?? ""}",
                      isSelected: false,
                      onTap: () {
                        NavigatorMethods.pushNamed(context, LocationScreen.routeName,
                            arguments: LocationScreenArgs(
                              onLocationSelected: (latLng, locality) {
                                addressCubit.updateAddress(
                                  addressId: addressCubit.addresses[index].id ?? 0,
                                  latitude: latLng.latitude,
                                  longitude: latLng.longitude,
                                  title: locality ?? addressCubit.addresses[index].title ?? "",
                                  onSuccess: () {
                                    addressCubit.initialaddresses();
                                    addressCubit.getaddresses();
                                  },
                                );
                              },
                              initialLatLng: LatLng(
                                  double.tryParse(
                                          addressCubit.addresses[index].latitude ?? "0.0") ??
                                      0.0,
                                  double.tryParse(
                                          addressCubit.addresses[index].longitude ?? "0.0") ??
                                      0.0),
                            ));
                      },
                    );
                  } else {
                    return Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CustomButton(
                              height: 60,
                              color: AppColor.secondAppColor,
                              prefixIcon: SvgPicture.asset(AppImages.mapPinPlusIcon),
                              text: "add_new_address".tr(),
                              onPressed: () => NavigatorMethods.pushNamed(
                                      context, MapScreen.routeName, arguments: MapScreenArgs(
                                    onLocationSelected: (lat, lng, city, fullAddress) {
                                      addressCubit.getaddresses();
                                    },
                                  ))),
                          const SizedBox(height: 10),
                          CustomButton(
                              height: 60,
                              text: AppLocaleKey.continueing.tr(),
                              onPressed: () => Navigator.pop(context)),
                        ],
                      ),
                    );
                  }
                },
              ),
            );
          });
        }),
      ),
    );
  }

  Future<Null> unAuthorizedDialog(BuildContext context) {
    return Future.microtask(() {
      NavigatorMethods.showAppDialog(
        context,
        AlertDialog(
          content: Text(AppLocaleKey.pleaselog.tr(),
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => const RegisterScreen()));
              },
              child: Text(
                AppLocaleKey.newRegistration.tr(),
                style: const TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xff2204AE)),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => const ValidateMobileScreen()));
              },
              child: Text(
                "login".tr(),
                style: const TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xff2204AE)),
              ),
            ),
          ],
        ),
      );
    });
  }
}
