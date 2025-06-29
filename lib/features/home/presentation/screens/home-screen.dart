import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hawiah_client/features/home/presentation/screens/home-new-order-screen.dart';

import '../controllers/home-cubit/home-cubit.dart';
import '../controllers/home-cubit/home-state.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset(
              "assets/icons/profile_company_icon.png",
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
                  "شركة الأوائل المحدودة",
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
      body: BlocConsumer<HomeCubit, HomeState>(
        builder: (BuildContext context, HomeState state) {
          final homeCubit = HomeCubit.get(context);
          final transportationCategoriesList =
              homeCubit.transportationCategoriesList;
          return Container(
            margin: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              children: [
                ClipRRect(
                    borderRadius: BorderRadius.circular(20.r),
                    child: Image.asset("assets/images/banner_image.PNG")),
                SizedBox(height: 10.h),
                Container(
                  height: 0.30.sh,
                  child: GridView.builder(
                    shrinkWrap: true, scrollDirection: Axis.horizontal,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, // 4 columns
                      crossAxisSpacing: 10.w, // Space between columns
                      mainAxisSpacing: 10.h, // Space between rows
                      childAspectRatio:
                          1.5, // Adjust this to change the size of grid items
                    ),
                    itemBuilder: (context, index) => GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const HomeNewOrderScreen()));
                      },
                      child: Container(
                        alignment: Alignment.center,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Image.asset(
                              transportationCategoriesList[index].logo,
                              height: 70.h,
                              width: 70.w,
                              fit: BoxFit.fill,
                            ),
                            SizedBox(height: 5.h),
                            Text(
                              transportationCategoriesList[index].title,
                              style: TextStyle(
                                  fontSize: 13.sp, color: Color(0xff3A3A3A)),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                    itemCount:
                        transportationCategoriesList.length, // Number of items
                  ),
                ),
                Spacer(),
                ClipRRect(
                    borderRadius: BorderRadius.circular(20.r),
                    child:
                        Image.asset("assets/images/order_barcode_image.png")),
              ],
            ),
          );
        },
        listener: (BuildContext context, HomeState state) {},
      ),
    );
  }
}
