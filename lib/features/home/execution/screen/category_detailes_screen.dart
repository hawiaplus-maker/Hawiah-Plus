import 'package:easy_localization/easy_localization.dart';
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
  const CategoryDetailsScreen({super.key, required this.id});
  final int id;

  @override
  State<CategoryDetailsScreen> createState() => _CategoryDetailsScreenState();
}

class _CategoryDetailsScreenState extends State<CategoryDetailsScreen> {
  @override
  void initState() {
    context.read<HomeCubit>().getshowCategories(widget.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(
          context,
          titleText: "new_request".tr(),
        ),
        body: BlocConsumer<HomeCubit, HomeState>(
          builder: (BuildContext context, HomeState state) {
            final homeCubit = HomeCubit.get(context);
            if (homeCubit.showCategories == null) {
              return Center(child: CustomLoading());
            }
            if (homeCubit.showCategories?.message?.services?.isEmpty ?? true) {
              return Center(child: NoDataWidget());
            }
            return Container(
              margin: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemBuilder: (context, index) {
                        return CategoryCardWidget(
                            homeCubit: homeCubit, widget: widget, index: index);
                      },
                      itemCount: homeCubit.showCategories?.message?.services?.length ?? 0,
                    ),
                  )
                ],
              ),
            );
          },
          listener: (BuildContext context, HomeState state) {},
        ));
  }
}
