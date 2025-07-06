import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hawiah_client/core/custom_widgets/api_response_widget.dart';
import 'package:hawiah_client/core/custom_widgets/custom_app_bar.dart';
import 'package:hawiah_client/core/custom_widgets/custom_button.dart';
import 'package:hawiah_client/core/images/app_images.dart';
import 'package:hawiah_client/core/locale/app_locale_key.dart';
import 'package:hawiah_client/core/utils/navigator_methods.dart';
import 'package:hawiah_client/features/home/presentation/widgets/location-item-widget.dart';
import 'package:hawiah_client/features/location/presentation/cubit/address_cubit.dart';
import 'package:hawiah_client/features/location/presentation/cubit/address_state.dart';
import 'package:hawiah_client/features/location/presentation/screens/add-new-location-screen.dart';
import 'package:hawiah_client/features/location/presentation/screens/location-map-screen.dart';

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
        appBar: CustomAppBar(
          context,
          titleText: AppLocaleKey.addresses.tr(),
        ),
        body: BlocBuilder<AddressCubit, AddressState>(
          builder: (BuildContext context, state) {
            AddressCubit addressCubit = context.read<AddressCubit>();
            return ApiResponseWidget(
              apiResponse: addressCubit.addressesResponse,
              onReload: () => addressCubit.getaddresses(),
              isEmpty: addressCubit.addresses.isEmpty,
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                        itemCount: addressCubit.addresses.length,
                        itemBuilder: (context, index) {
                          return LocationItemWidget(
                            imagePath: AppImages.addressLocationIcon,
                            title: addressCubit.addresses[index].title ?? "",
                            address:
                                "${addressCubit.addresses[index].city ?? ""} - ${addressCubit.addresses[index].neighborhood ?? ""}",
                            isSelected: false,
                            onTap: () {
                              NavigatorMethods.pushNamed(
                                  context, LocationScreen.routeName,
                                  arguments: LocationScreenArgs(
                                    onLocationSelected: (latLng) {
                                      addressCubit.updateAddress(
                                        addressId:
                                            addressCubit.addresses[index].id ??
                                                0,
                                        latitude: latLng.latitude,
                                        longitude: latLng.longitude,
                                        neighborhoodId: 5,
                                        title: addressCubit
                                                .addresses[index].title ??
                                            "",
                                        onSuccess: () {
                                          addressCubit.initialaddresses();
                                          addressCubit.getaddresses();
                                        },
                                      );
                                    },
                                    initialLatLng: LatLng(
                                        double.tryParse(addressCubit
                                                    .addresses[index]
                                                    .latitude ??
                                                "0.0") ??
                                            0.0,
                                        double.tryParse(addressCubit
                                                    .addresses[index]
                                                    .longitude ??
                                                "0.0") ??
                                            0.0),
                                  ));
                            },
                          );
                        }),
                  ),
                ],
              ),
            );
          },
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(16.0),
          child: CustomButton(
            text: "add_new_address".tr(),
            onPressed: () {
              NavigatorMethods.pushNamed(
                  context, AddNewLocationScreen.routeName);
            },
          ),
        ),
      ),
    );
  }
}
