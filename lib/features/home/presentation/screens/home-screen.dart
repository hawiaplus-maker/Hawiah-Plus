import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hawiah_client/core/custom_widgets/custom_app_bar.dart';
import 'package:hawiah_client/core/locale/app_locale_key.dart';
import 'package:hawiah_client/core/theme/app_colors.dart';
import 'package:hawiah_client/core/theme/app_text_style.dart';
import 'package:hawiah_client/features/home/presentation/controllers/home-categories-cubit/home-categories-cubit.dart';
import 'package:hawiah_client/features/home/presentation/controllers/home-services-cubit/home-services-cubit.dart';
import 'package:hawiah_client/features/home/presentation/controllers/home-sliders-cubit/home-sliders-cubit.dart';
import 'package:hawiah_client/features/home/presentation/widgets/best_seller_list_widget.dart';
import 'package:hawiah_client/features/home/presentation/widgets/home_app_bar_title.dart';
import 'package:hawiah_client/features/home/presentation/widgets/home_categories_list_widget.dart';
import 'package:hawiah_client/features/home/presentation/widgets/home_slider_widget.dart';
import 'package:hawiah_client/injection_container.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColor.mainAppColor.withAlpha(0),
              AppColor.mainAppColor.withAlpha(5),
              AppColor.mainAppColor.withAlpha(15),
              AppColor.mainAppColor.withAlpha(15),
              AppColor.mainAppColor.withAlpha(35),
            ],
          ),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          extendBody: true,
          appBar: CustomAppBar(
            context,
            height: 80,
            leadingWidth: 0,
            leading: SizedBox.shrink(),
            title: HomeAppBarTitle(),
          ),
          body: MultiBlocProvider(
            providers: [
              BlocProvider(create: (context) => sl<HomeSlidersCubit>()),
              BlocProvider(create: (context) => sl<HomeCategoriesCubit>()),
              BlocProvider(create: (context) => sl<HomeServicesCubit>()),
            ],
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 10),
                      const HomeSliderWidgets(),
                      SizedBox(height: 20),
                      HomeCategoriesListWidget(),
                      SizedBox(height: 15),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                        child: Text(AppLocaleKey.bestseller.tr(), style: AppTextStyle.text18_500),
                      ),
                      BestsellerListWidget(),
                    ],
                  ),
                );
              },
            ),
          ),
        ));
  }
}
