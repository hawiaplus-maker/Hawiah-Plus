import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hawiah_client/core/custom_widgets/custom_app_bar.dart';
import 'package:hawiah_client/core/custom_widgets/custom_loading/custom_loading.dart';
import 'package:hawiah_client/core/custom_widgets/no_data_widget.dart';
import 'package:hawiah_client/features/home/execution/widget/category_card_widget.dart';

import '../../presentation/controllers/home-cubit/home-cubit.dart';
import '../../presentation/controllers/home-cubit/home-state.dart';

class CategoryDetailsScreen extends StatefulWidget {
  const CategoryDetailsScreen({
    super.key,
    required this.id,
  });

  final int id;

  @override
  State<CategoryDetailsScreen> createState() => _CategoryDetailsScreenState();
}

class _CategoryDetailsScreenState extends State<CategoryDetailsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<HomeCubit>().getshowCategories(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        final cubit = HomeCubit.get(context);
        final data = cubit.showCategories?.message;

        final services = data?.services ?? [];

        return Scaffold(
          appBar: CustomAppBar(
            context,
            titleText: data?.title ?? "",
            centerTitle: true,
          ),
          body: Builder(
            builder: (_) {
              if (cubit.showCategories == null) {
                return const Center(child: CustomLoading());
              }

              final services = data?.services ?? [];

              if (services.isEmpty) {
                return const Center(child: NoDataWidget());
              }

              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
                child: GridView.builder(
                  itemCount: services.length,
                  gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 200.w,
                    crossAxisSpacing: 10.w,
                    mainAxisSpacing: 10.h,
                    childAspectRatio: .53,
                  ),
                  itemBuilder: (context, index) {
                    return CategoryCardWidget(
                      homeCubit: cubit,
                      widget: widget,
                      index: index,
                    );
                  },
                ),
              );
            },
          ),
        );
      },
    );
  }
}
