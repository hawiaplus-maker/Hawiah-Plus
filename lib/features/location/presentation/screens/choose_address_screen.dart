import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hawiah_client/core/custom_widgets/api_response_widget.dart';
import 'package:hawiah_client/core/custom_widgets/custom_app_bar.dart';
import 'package:hawiah_client/core/custom_widgets/custom_button.dart';
import 'package:hawiah_client/core/custom_widgets/no_data_widget.dart';
import 'package:hawiah_client/core/hive/hive_methods.dart';
import 'package:hawiah_client/core/images/app_images.dart';
import 'package:hawiah_client/core/locale/app_locale_key.dart';
import 'package:hawiah_client/core/theme/app_colors.dart';
import 'package:hawiah_client/core/utils/common_methods.dart';
import 'package:hawiah_client/core/utils/navigator_methods.dart';
import 'package:hawiah_client/features/authentication/presentation/dialog/unauthenticated_dialog.dart';
import 'package:hawiah_client/features/home/execution/screen/nearby_service_provider_screen.dart';
import 'package:hawiah_client/features/home/presentation/widgets/location-item-widget.dart';
import 'package:hawiah_client/features/location/presentation/cubit/address_cubit.dart';
import 'package:hawiah_client/features/location/presentation/cubit/address_state.dart';
import 'package:hawiah_client/features/location/presentation/screens/map_screen.dart';

class ChooseAddressScreenArgs {
  final int serviceProviderId;

  ChooseAddressScreenArgs({required this.serviceProviderId});
}

class ChooseAddressScreen extends StatefulWidget {
  static const String routeName = "choose-location-screen";
  final ChooseAddressScreenArgs args;
  const ChooseAddressScreen({super.key, required this.args});

  @override
  State<ChooseAddressScreen> createState() => _ChooseAddressScreenState();
}

class _ChooseAddressScreenState extends State<ChooseAddressScreen> {
  bool isVesetor = false;
  int? addressId;
  @override
  initState() {
    super.initState();
    if (HiveMethods.isVisitor() || HiveMethods.getToken() == null) {
      isVesetor = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        NavigatorMethods.showAppDialog(context, UnauthenticatedDialog());
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return isVesetor
        ? Scaffold(
            appBar: CustomAppBar(
              context,
              titleText: "choose_address".tr(),
            ),
            body: Center(child: NoDataWidget()),
          )
        : BlocProvider(
            create: (BuildContext context) => AddressCubit()..getaddresses(),
            child: BlocBuilder<AddressCubit, AddressState>(builder: (context, state) {
              AddressCubit addressCubit = context.read<AddressCubit>();
              if (addressId == null && addressCubit.addresses.isNotEmpty) {
                addressId = addressCubit.addresses.first.id;
              }

              return Scaffold(
                appBar: CustomAppBar(
                  context,
                  titleText: "choose_address".tr(),
                  actions: [
                    IconButton(
                        onPressed: () {
                          NavigatorMethods.pushNamed(context, MapScreen.routeName,
                              arguments: MapScreenArgs(
                            onLocationSelected: (lat, lng, city, fullAddress) {
                              addressCubit.getaddresses();
                            },
                          ));
                        },
                        icon: SvgPicture.asset(
                          AppImages.mapPinPlusIcon,
                          colorFilter: ColorFilter.mode(AppColor.secondAppColor, BlendMode.srcIn),
                        ))
                  ],
                ),
                body: ApiResponseWidget(
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
                          color: AppColor.secondAppColor,
                          text: "add_new_address".tr(),
                          prefixIcon: SvgPicture.asset(AppImages.mapPinPlusIcon),
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
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: addressCubit.addresses.length,
                            itemBuilder: (context, index) {
                              return LocationItemWidget(
                                imagePath: AppImages.addressLocationIcon,
                                title: addressCubit.addresses[index].title ?? "",
                                address: "${addressCubit.addresses[index].neighborhood ?? ""}",
                                isSelected: addressId == addressCubit.addresses[index].id,
                                onTap: () {
                                  addressId = addressCubit.addresses[index].id;
                                  setState(() {});
                                },
                              );
                            }),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              // CustomButton(
                              //   color: AppColor.secondAppColor,
                              //   text: "add_new_address".tr(),
                              //   prefixIcon: SvgPicture.asset(AppImages.mapPinPlusIcon),
                              //   onPressed: () => NavigatorMethods.pushNamed(
                              //       context, AddNewLocationScreen.routeName,
                              //       arguments: AddNewLocationScreenArgs(
                              //     onAddressAdded: () {
                              //       addressCubit.getaddresses();
                              //     },
                              //   )),
                              // ),
                              SizedBox(
                                height: 10,
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                bottomNavigationBar: addressCubit.addresses.isEmpty == true
                    ? SizedBox()
                    : Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: SafeArea(
                          bottom: true,
                          child: CustomButton(
                            text: "confirm_address".tr(),
                            onPressed: () {
                              if (addressId == null) {
                                return CommonMethods.showError(
                                    message: AppLocaleKey.youHaveToChooseAddress.tr());
                              } else {
                                // Find the address with the matching ID
                                final selectedAddress = addressCubit.addresses.firstWhere(
                                  (address) => address.id == addressId,
                                  orElse: () => addressCubit.addresses.first,
                                );

                                NavigatorMethods.pushNamed(
                                  context,
                                  NearbyServiceProviderScreen.routeName,
                                  arguments: NearbyServiceProviderArguments(
                                      serviceProviderId: widget.args.serviceProviderId,
                                      addressId: selectedAddress.id!,
                                      latitude:
                                          double.tryParse(selectedAddress.latitude ?? "") ?? 0.0,
                                      longitude:
                                          double.tryParse(selectedAddress.longitude ?? "") ?? 0.0),
                                );
                              }
                            },
                          ),
                        ),
                      ),
              );
            }),
          );
  }
}
