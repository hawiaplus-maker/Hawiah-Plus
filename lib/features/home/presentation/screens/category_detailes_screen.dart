import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hawiah_client/core/custom_widgets/custom_app_bar.dart';
import 'package:hawiah_client/core/custom_widgets/custom_image/custom_network_image.dart';
import 'package:hawiah_client/core/custom_widgets/custom_loading/custom_loading.dart';
import 'package:hawiah_client/core/utils/navigator_methods.dart';
import 'package:hawiah_client/features/location/presentation/screens/choose_address_screen.dart';

import '../controllers/home-cubit/home-cubit.dart';
import '../controllers/home-cubit/home-state.dart';

class CategoryDetailesScreen extends StatefulWidget {
  const CategoryDetailesScreen({super.key, required this.id});
  final int id;

  @override
  State<CategoryDetailesScreen> createState() => _CategoryDetailesScreenState();
}

class _CategoryDetailesScreenState extends State<CategoryDetailesScreen> {
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
              return Center(child: Text("no_data".tr()));
            }
            return Container(
              margin: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            NavigatorMethods.pushNamed(
                                context, ChooseAddressScreen.routeName,
                                arguments: ChoooseAddressScreenArgs(
                                  showCategoriesModel:homeCubit.showCategories! ,
                                  catigoryId: widget.id,
                                  serviceProviderId: homeCubit.showCategories
                                          ?.message?.services?[index].id ??
                                      0,
                                ));
                            // Navigator.push(
                            //     context,
                            //     MaterialPageRoute(
                            //         builder: (context) =>
                            //             HomeDetailsOrderScreen(
                            //               title: homeCubit
                            //                       .showCategories
                            //                       ?.message
                            //                       ?.services?[index]
                            //                       .title ??
                            //                   "",
                            //             )));
                          },
                          child: Card(
                            elevation: 5,
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Container(
                              margin: EdgeInsets.symmetric(
                                  horizontal: 10.w, vertical: 10.h),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CustomNetworkImage(
                                    imageUrl: homeCubit.showCategories?.message
                                            ?.services?[index].image ??
                                        "",
                                    height: 70.h,
                                    width: 70.w,
                                    fit: BoxFit.fill,
                                  ),
                                  SizedBox(width: 20.h),
                                  Text(
                                    homeCubit.showCategories?.message
                                            ?.services?[index].title ??
                                        "",
                                    style: TextStyle(
                                        fontSize: 14.sp,
                                        color: Color(0xff3A3A3A)),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                      itemCount:
                          homeCubit.showCategories?.message?.services?.length ??
                              0,
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
