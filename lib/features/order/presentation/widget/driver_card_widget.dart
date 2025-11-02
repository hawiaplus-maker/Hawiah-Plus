import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hawiah_client/core/custom_widgets/custom_button.dart';
import 'package:hawiah_client/core/images/app_images.dart';
import 'package:hawiah_client/core/locale/app_locale_key.dart';
import 'package:hawiah_client/core/networking/urls.dart';
import 'package:hawiah_client/core/theme/app_colors.dart';
import 'package:hawiah_client/core/theme/app_text_style.dart';
import 'package:hawiah_client/core/utils/navigator_methods.dart';
import 'package:hawiah_client/features/chat/presentation/screens/single-chat-screen.dart';
import 'package:hawiah_client/features/order/presentation/model/orders_model.dart';
import 'package:hawiah_client/features/profile/presentation/cubit/cubit_profile.dart';

class DriverCardWidget extends StatelessWidget {
  const DriverCardWidget({
    super.key,
    required this.ordersData,
  });

  final Data ordersData;

  @override
  Widget build(BuildContext context) {
    final vehicle = ordersData.vehicles?.isNotEmpty == true ? ordersData.vehicles!.first : null;
    final driverName = ordersData.driver ?? '';

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          _buildDriverInfo(driverName, vehicle),
          SizedBox(height: 16.h),
          _buildMessageButton(context, driverName),
        ],
      ),
    );
  }


  Widget _buildDriverInfo(String driverName, dynamic vehicle) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(top: 10.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(driverName, style: AppTextStyle.text16_700),
                if (vehicle != null) ...[
                  SizedBox(height: 10.h),
                  Text(
                    "${vehicle.plateLetters} ${vehicle.plateNumbers}",
                    style: AppTextStyle.text16_700,
                  ),
                  SizedBox(height: 10.h),
                  Text(
                    "${vehicle.carModel} ${vehicle.carType} ${vehicle.carBrand}",
                    style: AppTextStyle.text14_600.copyWith(color: const Color(0xff545454)),
                  ),
                ],
              ],
            ),
          ),
        ),
        Image.asset(AppImages.hawiahDriver, height: 100, width: 100),
      ],
    );
  }

  ///  Message button section
  Widget _buildMessageButton(BuildContext context, String driverName) {
    return CustomButton(
      width: MediaQuery.of(context).size.width / 2.5,
      text: AppLocaleKey.sendMessage.tr(),
      style: AppTextStyle.text14_500,
      color: AppColor.lightGreyColor,
      suffixIcon: Image.asset(AppImages.send, height: 30.h, width: 30.w),
      onPressed: () => _navigateToChat(context, driverName),
    );
  }

  ///  Navigation logic
  void _navigateToChat(BuildContext context, String driverName) {
    final profileCubit = context.read<ProfileCubit>();

    NavigatorMethods.pushNamed(
      context,
      SingleChatScreen.routeName,
      arguments: SingleChatScreenArgs(
        onMessageSent: () {},
        receiverId: ordersData.driverId.toString(),
        receiverType: "driver",
        receiverName: driverName,
        receiverImage: Urls.testUserImage,
        senderId: profileCubit.user!.id.toString(),
        senderType: "user",
        orderId: ordersData.id.toString(),
      ),
    );
  }
}
