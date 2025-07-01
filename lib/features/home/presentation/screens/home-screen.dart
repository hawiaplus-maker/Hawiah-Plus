import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hawiah_client/core/custom_widgets/custom_image/custom_network_image.dart';
import 'package:hawiah_client/features/home/presentation/screens/home-new-order-screen.dart';
import 'package:hawiah_client/features/profile/presentation/cubit/cubit_profile.dart';
import 'package:hawiah_client/features/setting/cubit/setting_cubit.dart';
import 'package:hawiah_client/features/setting/cubit/setting_state.dart';

import '../controllers/home-cubit/home-cubit.dart';
import '../controllers/home-cubit/home-state.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    context.read<HomeCubit>().getCategories();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final profile = context.read<ProfileCubit>().user;
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CustomNetworkImage(
              radius: 30,
              fit: BoxFit.fill,
              imageUrl: profile.image,
              height: 40.h,
              width: 40.w,
            ),
            SizedBox(
              width: 10.w,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "welcome_2".tr(),
                  style: TextStyle(fontSize: 12.sp, color: Color(0xffA9A9AA)),
                ),
                Text(
                  profile.name,
                  style: TextStyle(fontSize: 14.sp, color: Color(0xff19104E)),
                ),
              ],
            ),
            Spacer(),
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Color(0xffF5F5FF), width: 1),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Icon(Icons.notifications, size: 26, color: Colors.blue),
                  Positioned(
                    top: 0,
                    right: 0,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          children: [
            SizedBox(
              height: 10.h,
            ),
            SliderWidgets(),
            SizedBox(height: 10.h),
            BlocBuilder<HomeCubit, HomeState>(builder: (context, state) {
              final homeCubit = HomeCubit.get(context);
              return Expanded(
                flex: 3,
                child: ListView.builder(
                  shrinkWrap: false, scrollDirection: Axis.vertical,
                  itemBuilder: (context, index) => GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const HomeNewOrderScreen()));
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
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Image.network(
                              homeCubit.categorieS?.message?[index].image ?? "",
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
                            SizedBox(height: 5.h),
                            Text(
                              homeCubit.categorieS?.message?[index].title ?? "",
                              style: TextStyle(
                                  fontSize: 14.sp, color: Color(0xff3A3A3A)),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  itemCount:
                      homeCubit.categorieS?.message?.length, // Number of items
                ),
              );
            }),
            SizedBox(height: 10.h),
            // ClipRRect(
            //     borderRadius: BorderRadius.circular(20.r),
            //     child: Image.asset("assets/images/order_barcode_image.png")),
          ],
        ),
      ),
    );
  }
}

class SliderWidgets extends StatefulWidget {
  const SliderWidgets({
    super.key,
  });

  @override
  State<SliderWidgets> createState() => _SliderWidgetsState();
}

class _SliderWidgetsState extends State<SliderWidgets> {
  @override
  void initState() {
    super.initState();
    context.read<SettingCubit>().getsetting();
  }

  Widget build(BuildContext context) {
    final langCode = context.locale.languageCode; // 'ar' أو 'en'
    final imagePath = langCode == 'ar'
        ? context.read<SettingCubit>().setting?.sliderImage?.ar
        : context.read<SettingCubit>().setting?.sliderImage?.en;

    final fullImageUrl = "https://hawia-sa.com/$imagePath";
    return BlocBuilder<SettingCubit, SettingState>(builder: (context, state) {
      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey, width: 1),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: CustomNetworkImage(
                  imageUrl: fullImageUrl,
                  height: 200.h,
                  width: double.infinity,
                )),
          ],
        ),
      );
    });
  }
}
