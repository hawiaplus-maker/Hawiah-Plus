import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hawiah_client/features/home/presentation/screens/home-details-order-screen.dart';

import '../controllers/home-cubit/home-cubit.dart';
import '../controllers/home-cubit/home-state.dart';

class HomeNewOrderScreen extends StatefulWidget {
  const HomeNewOrderScreen({super.key, required this.id});
  final int id;

  @override
  State<HomeNewOrderScreen> createState() => _HomeNewOrderScreenState();
}

class _HomeNewOrderScreenState extends State<HomeNewOrderScreen> {
  @override
  void initState() {
    context.read<HomeCubit>().getshowCategories(widget.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("new_request".tr()),
          centerTitle: true,
        ),
        body: BlocConsumer<HomeCubit, HomeState>(
          builder: (BuildContext context, HomeState state) {
            final homeCubit = HomeCubit.get(context);
            if (homeCubit.showCategories == null) {
              return Center(child: CircularProgressIndicator(strokeWidth: 2));
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
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        HomeDetailsOrderScreen(
                                          title: homeCubit
                                                  .showCategories
                                                  ?.message
                                                  ?.services?[index]
                                                  .title ??
                                              "",
                                        )));
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
                                  Image.network(
                                    homeCubit.showCategories?.message
                                            ?.services?[index].image ??
                                        "",
                                    height: 70.h,
                                    width: 70.w,
                                    fit: BoxFit.fill,
                                    loadingBuilder:
                                        (context, child, loadingProgress) {
                                      if (loadingProgress == null) return child;
                                      return SizedBox(
                                        height: 70.h,
                                        width: 70.w,
                                        child: Center(
                                          child: CircularProgressIndicator(
                                              strokeWidth: 2),
                                        ),
                                      );
                                    },
                                    errorBuilder: (context, error, stackTrace) {
                                      return Container(
                                        height: 70.h,
                                        width: 70.w,
                                        color: Colors.grey[100],
                                        child: Icon(Icons.broken_image,
                                            color: Colors.grey),
                                      );
                                    },
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
