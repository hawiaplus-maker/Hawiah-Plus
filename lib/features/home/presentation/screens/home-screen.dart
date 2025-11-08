import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hawiah_client/core/custom_widgets/custom_app_bar.dart';
import 'package:hawiah_client/core/hive/hive_methods.dart';
import 'package:hawiah_client/features/home/presentation/controllers/home-cubit/home-cubit.dart';
import 'package:hawiah_client/features/home/presentation/widgets/home_app_bar_title.dart';
import 'package:hawiah_client/features/home/presentation/widgets/home_bottom_floating_order_widget.dart';
import 'package:hawiah_client/features/home/presentation/widgets/home_categories_list_widget.dart';
import 'package:hawiah_client/features/home/presentation/widgets/home_slider_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // final homeCubit = context.read<HomeCubit>();
    // if (homeCubit.categories.isEmpty) {
    //   homeCubit.getCategories();
    // }
     
  }

  Widget build(BuildContext context) {
    return Scaffold(
        extendBody: true,
        appBar: CustomAppBar(
          context,
          height: 80,
          leadingWidth: 0,
          leading: SizedBox.shrink(),
          title: HomeAppBarTitle(),
        ),
        body: Container(
          margin: EdgeInsets.symmetric(horizontal: 20.w),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 10.h),
                const HomeSliderWidgets(),
                SizedBox(height: 10.h),
                HomeCategoriesListWidget(),
                SizedBox(height: 10.h),
              ],
            ),
          ),
        ),
        bottomNavigationBar: HomeBottomFloatingOrderCardWidget());
  }
}
