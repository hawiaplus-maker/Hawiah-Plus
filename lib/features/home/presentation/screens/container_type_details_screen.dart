import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hawiah_client/core/custom_widgets/custom_app_bar.dart';
import 'package:hawiah_client/core/custom_widgets/custom_image/custom_network_image.dart';
import 'package:hawiah_client/core/custom_widgets/no_data_widget.dart';
import 'package:hawiah_client/core/images/app_images.dart';
import 'package:hawiah_client/core/locale/app_locale_key.dart';
import 'package:hawiah_client/core/theme/app_colors.dart';
import 'package:hawiah_client/core/theme/app_text_style.dart';
import 'package:hawiah_client/core/utils/navigator_methods.dart';
import 'package:hawiah_client/features/home/presentation/model/container_types_model.dart';
import 'package:hawiah_client/features/location/presentation/screens/choose_address_screen.dart';

class ContainerTypeDetailsScreen extends StatelessWidget {
  const ContainerTypeDetailsScreen({super.key, required this.flow});

  final ContainerFlowModel flow;

  String _title() {
    if (flow.isCleaning) return AppLocaleKey.cleaningContracts.tr();
    if (flow.type.toLowerCase() == 'projects')
      return AppLocaleKey.projects.tr();
    return flow.name;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(context, titleText: _title(), centerTitle: true),
      body: flow.containers.isEmpty
          ? const Center(child: NoDataWidget())
          : ListView.separated(
              padding: EdgeInsets.all(16.w),
              itemCount: flow.containers.length,
              separatorBuilder: (_, __) => SizedBox(height: 10.h),
              itemBuilder: (context, index) =>
                  _ContainerCard(container: flow.containers[index]),
            ),
    );
  }
}

class _ContainerCard extends StatelessWidget {
  const _ContainerCard({required this.container});

  final ContainerItemModel container;

  @override
  Widget build(BuildContext context) {
    final size = [container.size, container.sizeUnit]
        .where((part) => part.isNotEmpty)
        .join(' ');

    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () => NavigatorMethods.pushNamed(
        context,
        ChooseAddressScreen.routeName,
        arguments: ChooseAddressScreenArgs(serviceProviderId: container.id),
      ),
      child: Card(
        elevation: 1,
        color: AppColor.whiteColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: EdgeInsets.all(12.w),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: CustomNetworkImage(
                  imageUrl: container.image,
                  imagePlaceHolder: AppImages.hawiahImage,
                  height: 90.w,
                  width: 90.w,
                  fit: BoxFit.contain,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(container.title,
                        style: AppTextStyle.text14_500, maxLines: 2),
                    if (size.isNotEmpty) ...[
                      SizedBox(height: 4.h),
                      Text(size,
                          style: AppTextStyle.text12_500
                              .copyWith(color: AppColor.greyColor)),
                    ],
                    if (container.measurements.isNotEmpty) ...[
                      SizedBox(height: 4.h),
                      Text(
                        container.measurements,
                        style: AppTextStyle.text10_400
                            .copyWith(color: AppColor.greyColor),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                    if (container.price.isNotEmpty) ...[
                      SizedBox(height: 4.h),
                      Text(
                        AppLocaleKey.sar.tr(args: [container.price]),
                        style: AppTextStyle.text12_500
                            .copyWith(color: AppColor.mainAppColor),
                      ),
                    ],
                    if (container.description.isNotEmpty) ...[
                      SizedBox(height: 6.h),
                      Text(
                        container.description,
                        style: AppTextStyle.text10_400
                            .copyWith(color: AppColor.greyColor),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
              SizedBox(width: 8.w),
              Icon(Icons.arrow_forward_ios,
                  size: 14.w, color: AppColor.greyColor),
            ],
          ),
        ),
      ),
    );
  }
}
