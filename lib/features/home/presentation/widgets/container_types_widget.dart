import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hawiah_client/core/custom_widgets/api_response_widget.dart';
import 'package:hawiah_client/core/custom_widgets/custom_loading/custom_shimmer.dart';
import 'package:hawiah_client/core/images/app_images.dart';
import 'package:hawiah_client/core/locale/app_locale_key.dart';
import 'package:hawiah_client/core/theme/app_colors.dart';
import 'package:hawiah_client/core/theme/app_text_style.dart';
import 'package:hawiah_client/features/home/presentation/controllers/home-cubit/home-cubit.dart';
import 'package:hawiah_client/features/home/presentation/controllers/home-cubit/home-state.dart';
import 'package:hawiah_client/features/home/presentation/model/container_types_model.dart';
import 'package:hawiah_client/features/home/presentation/screens/container_type_details_screen.dart';

class HomeContainerTypesWidget extends StatelessWidget {
  const HomeContainerTypesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        final cubit = context.read<HomeCubit>();
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(AppLocaleKey.containerTypes.tr(),
                  style: AppTextStyle.text18_500),
              SizedBox(height: 10.h),
              ApiResponseWidget(
                apiResponse: cubit.containerTypesResponse,
                onReload: () => cubit.getContainerTypes(),
                isEmpty: cubit.containerTypes.isEmpty,
                loadingWidget: GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: 2,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10.w,
                    mainAxisSpacing: 10.h,
                    childAspectRatio: 1.25,
                  ),
                  itemBuilder: (_, __) => const CustomShimmer(radius: 12),
                ),
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: cubit.containerTypes.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10.w,
                    mainAxisSpacing: 10.h,
                    childAspectRatio: 1.25,
                  ),
                  itemBuilder: (context, index) =>
                      _ContainerFlowCard(flow: cubit.containerTypes[index]),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ContainerFlowCard extends StatelessWidget {
  const _ContainerFlowCard({required this.flow});

  final ContainerFlowModel flow;

  String _title() {
    if (flow.isCleaning) return AppLocaleKey.cleaningContracts.tr();
    if (flow.type.toLowerCase() == 'projects')
      return AppLocaleKey.projects.tr();
    return flow.name;
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ContainerTypeDetailsScreen(flow: flow),
        ),
      ),
      child: Card(
        elevation: 0,
        color: AppColor.whiteColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: EdgeInsets.all(12.w),
          child: Row(
            children: [
              Container(
                height: 48.w,
                width: 48.w,
                decoration: BoxDecoration(
                  color: AppColor.mainAppColor.withAlpha(18),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Image.asset(
                  AppImages.hawiahImage,
                  fit: BoxFit.contain,
                  height: 32.w,
                  width: 32.w,
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _title(),
                      style: AppTextStyle.text14_500,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      '${flow.containers.length} ${AppLocaleKey.containers.tr()}',
                      style: AppTextStyle.text10_400
                          .copyWith(color: AppColor.greyColor),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios,
                  size: 14.w, color: AppColor.greyColor),
            ],
          ),
        ),
      ),
    );
  }
}
