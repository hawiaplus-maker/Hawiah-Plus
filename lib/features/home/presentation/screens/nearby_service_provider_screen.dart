import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hawiah_client/core/custom_widgets/api_response_widget.dart';
import 'package:hawiah_client/core/custom_widgets/custom_app_bar.dart';
import 'package:hawiah_client/core/custom_widgets/custom_image/custom_network_image.dart';
import 'package:hawiah_client/core/images/app_images.dart';
import 'package:hawiah_client/core/locale/app_locale_key.dart';
import 'package:hawiah_client/core/theme/app_colors.dart';
import 'package:hawiah_client/core/theme/app_text_style.dart';
import 'package:hawiah_client/core/utils/navigator_methods.dart';
import 'package:hawiah_client/features/home/presentation/model/show_categories_model.dart';
import 'package:hawiah_client/features/home/presentation/screens/request_hawia_screen.dart';
import 'package:hawiah_client/features/location/presentation/model/address_model.dart';
import 'package:hawiah_client/features/order/presentation/order-cubit/order-cubit.dart';
import 'package:hawiah_client/features/order/presentation/order-cubit/order-state.dart';

class NearbyServiceProviderArguments {
  final int catigoryId;
  final int serviceProviderId;
  final AddressModel address;
  final ShowCategoriesModel showCategoriesModel;
  NearbyServiceProviderArguments({
    required this.catigoryId,
    required this.serviceProviderId,
    required this.address,
    required this.showCategoriesModel,
  });
}

class NearbyServiceProviderScreen extends StatelessWidget {
  static const routeName = '/nearby-service-provider';

  final NearbyServiceProviderArguments args;
  const NearbyServiceProviderScreen({super.key, required this.args});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => OrderCubit()
        ..getNearbyProviders(
          serviceProviderId: args.serviceProviderId,
          addressId: args.address.id!,
          onBadRequest: () {
            Navigator.pop(context);
          },
        ),
      child: Scaffold(
        appBar: CustomAppBar(
          context,
          titleText: AppLocaleKey.chooseServiceProvider.tr(),
        ),
        body: BlocBuilder<OrderCubit, OrderState>(
          builder: (context, state) {
            final prviders = context.read<OrderCubit>();
            return ApiResponseWidget(
              apiResponse: prviders.nearbyServiceProviderResponse,
              onReload: () => prviders.getNearbyProviders(
                  serviceProviderId: args.serviceProviderId,
                  addressId: args.address.id!),
              isEmpty: prviders.nearbyServiceProvider.isEmpty,
              child: ListView.builder(
                itemCount: prviders.nearbyServiceProvider.length,
                itemBuilder: (context, index) =>
                    _buildCardWidget(context, prviders, index),
              ),
            );
          },
        ),
      ),
    );
  }

  Card _buildCardWidget(BuildContext context, OrderCubit prviders, int index) {
    return Card(
      color: AppColor.whiteColor,
      elevation: 7,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 10),
        child: ListTile(
          onTap: () {
            NavigatorMethods.pushNamed(context, RequistHawiaScreen.routeName,
                arguments: RequistHawiaScreenArgs(
                    address: args.address,
                    catigoryId: args.catigoryId,
                    serviceProviderId: args.serviceProviderId,
                    nearbyServiceProviderModel:
                        prviders.nearbyServiceProvider[index],
                    showCategoriesModel: args.showCategoriesModel));
          },
          leading: CustomNetworkImage(
            imageUrl: "",
            imagePlaceHolder: AppImages.truckImage,
          ),
          title: Text(
            prviders.nearbyServiceProvider[index].serviceProviderName ?? "",
            style: AppTextStyle.text16_700,
          ),
          subtitle: Text(
            AppLocaleKey.days.tr(args: [
              prviders.nearbyServiceProvider[index].duration.toString(),
            ]),
            style: AppTextStyle.text14_400,
          ),
          trailing: Text(
            AppLocaleKey.sar.tr(
                args: [prviders.nearbyServiceProvider[index].dailyPrice ?? ""]),
            style: AppTextStyle.text14_400,
          ),
        ),
      ),
    );
  }
}
