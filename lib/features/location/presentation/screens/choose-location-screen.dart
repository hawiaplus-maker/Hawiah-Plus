import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hawiah_client/core/custom_widgets/api_response_widget.dart';
import 'package:hawiah_client/core/custom_widgets/global-elevated-button-widget.dart';
import 'package:hawiah_client/core/images/app_images.dart';
import 'package:hawiah_client/core/theme/app_colors.dart';
import 'package:hawiah_client/core/theme/app_text_style.dart';
import 'package:hawiah_client/core/utils/navigator_methods.dart';
import 'package:hawiah_client/features/home/presentation/screens/home-details-order-screen.dart';
import 'package:hawiah_client/features/home/presentation/widgets/location-item-widget.dart';
import 'package:hawiah_client/features/location/presentation/cubit/address_cubit.dart';
import 'package:hawiah_client/features/location/presentation/cubit/address_state.dart';
import 'package:hawiah_client/features/location/presentation/model/address_model.dart';
import 'package:hawiah_client/features/location/presentation/screens/add-new-location-screen.dart';

class ChoooseLocationScreenArgs {
  final int catigoryId;
  final int serviceProviderId;

  ChoooseLocationScreenArgs(
      {required this.catigoryId, required this.serviceProviderId});
}

class ChooseLocationScreen extends StatefulWidget {
  static const String routeName = "choose-location-screen";
  final ChoooseLocationScreenArgs args;
  const ChooseLocationScreen({super.key, required this.args});

  @override
  State<ChooseLocationScreen> createState() => _ChooseLocationScreenState();
}

class _ChooseLocationScreenState extends State<ChooseLocationScreen> {
  AddressModel? address;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AddressCubit()
        ..initialaddresses()
        ..getaddresses(),
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(
              Icons.arrow_back_ios,
            ),
          ),
          title: Text(
            "choose_address".tr(),
            style: AppTextStyle.appBarStyle,
          ),
          centerTitle: true,
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
                            isSelected:
                                address == addressCubit.addresses[index],
                            onTap: () {
                              address = addressCubit.addresses[index];
                              setState(() {});
                              // Navigator.push(
                              //     context,
                              //     MaterialPageRoute(
                              //         builder: (context) => LocationScreen()));
                            },
                          );
                        }),
                  ),
                  LocationItemWidget(
                    imagePath: AppImages.addAddressImage,
                    isSVG: false,
                    title: "add_new_address".tr(),
                    address: "",
                    isSelected: false,
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddNewLocationScreen(),
                        )),
                  ),
                  // Container for the button
                  Container(
                    margin:
                        EdgeInsets.symmetric(vertical: 20.h, horizontal: 20.w),
                    alignment: Alignment.topCenter,
                    child: GlobalElevatedButton(
                      label: "confirm_address".tr(),
                      onPressed: () {
                        NavigatorMethods.pushNamed(
                          context,
                          HomeDetailsOrderScreen.routeName,
                          arguments: HomeDetailesOrderScreenArgs(
                              catigoryId: widget.args.catigoryId,
                              serviceProviderId: widget.args.serviceProviderId,
                              addressId: address?.id ?? 0),
                        );
                      },
                      backgroundColor: AppColor.mainAppColor,
                      textColor: Colors.white,
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      borderRadius: BorderRadius.circular(10),
                      fixedWidth: 0.80.sw, // 80% of the screen width
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
