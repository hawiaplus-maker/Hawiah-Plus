import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hawiah_client/core/custom_widgets/api_response_widget.dart';
import 'package:hawiah_client/core/custom_widgets/custom_app_bar.dart';
import 'package:hawiah_client/core/custom_widgets/custom_button.dart';
import 'package:hawiah_client/core/custom_widgets/no_data_widget.dart';
import 'package:hawiah_client/core/images/app_images.dart';
import 'package:hawiah_client/core/locale/app_locale_key.dart';
import 'package:hawiah_client/core/utils/common_methods.dart';
import 'package:hawiah_client/core/utils/navigator_methods.dart';
import 'package:hawiah_client/features/home/presentation/model/show_categories_model.dart';
import 'package:hawiah_client/features/home/presentation/screens/nearby_service_provider_screen.dart';
import 'package:hawiah_client/features/home/presentation/widgets/location-item-widget.dart';
import 'package:hawiah_client/features/location/presentation/cubit/address_cubit.dart';
import 'package:hawiah_client/features/location/presentation/cubit/address_state.dart';
import 'package:hawiah_client/features/location/presentation/model/address_model.dart';
import 'package:hawiah_client/features/location/presentation/screens/add-new-location-screen.dart';

class ChoooseAddressScreenArgs {
  final int catigoryId;
  final int serviceProviderId;
  final ShowCategoriesModel showCategoriesModel;

  ChoooseAddressScreenArgs(
      {required this.showCategoriesModel,
      required this.catigoryId,
      required this.serviceProviderId});
}

class ChooseAddressScreen extends StatefulWidget {
  static const String routeName = "choose-location-screen";
  final ChoooseAddressScreenArgs args;
  const ChooseAddressScreen({super.key, required this.args});

  @override
  State<ChooseAddressScreen> createState() => _ChooseAddressScreenState();
}

class _ChooseAddressScreenState extends State<ChooseAddressScreen> {
  AddressModel? address;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AddressCubit()
        ..initialaddresses()
        ..getaddresses(),
      child: BlocBuilder<AddressCubit, AddressState>(builder: (context, state) {
        AddressCubit addressCubit = context.read<AddressCubit>();
        return Scaffold(
          appBar: CustomAppBar(
            context,
            titleText: "choose_address".tr(),
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
                    text: "add_new_address".tr(),
                    onPressed: () {
                      NavigatorMethods.pushNamed(
                          context, AddNewLocationScreen.routeName,
                          arguments: AddNewLocationScreenArgs(
                        onAddressAdded: () {
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
                          address:
                              "${addressCubit.addresses[index].city ?? ""} - ${addressCubit.addresses[index].neighborhood ?? ""}",
                          isSelected: address == addressCubit.addresses[index],
                          onTap: () {
                            address = addressCubit.addresses[index];
                            setState(() {});
                          },
                        );
                      }),
                  LocationItemWidget(
                    imagePath: AppImages.addAddressImage,
                    isSVG: false,
                    title: "add_new_address".tr(),
                    address: "",
                    isSelected: false,
                    onTap: () => NavigatorMethods.pushNamed(
                        context, AddNewLocationScreen.routeName,
                        arguments: AddNewLocationScreenArgs(
                      onAddressAdded: () {
                        addressCubit.getaddresses();
                      },
                    )),
                  ),
                ],
              ),
            ),
          ),
          bottomNavigationBar: addressCubit.addresses.isEmpty == true
              ? SizedBox()
              : Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  child: CustomButton(
                    text: "confirm_address".tr(),
                    onPressed: () {
                      if (address == null) {
                        return CommonMethods.showError(
                            message: AppLocaleKey.youHaveToChooseAddress.tr());
                      } else {
                        NavigatorMethods.pushNamed(
                          context,
                          NearbyServiceProviderScreen.routeName,
                          arguments: NearbyServiceProviderArguments(
                              showCategoriesModel:
                                  widget.args.showCategoriesModel,
                              catigoryId: widget.args.catigoryId,
                              serviceProviderId: widget.args.serviceProviderId,
                              address: address!),
                        );
                      }
                    },
                  ),
                ),
        );
      }),
    );
  }
}
