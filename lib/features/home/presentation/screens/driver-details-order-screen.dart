import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hawiah_client/core/custom_widgets/global-elevated-button-widget.dart';
import 'package:hawiah_client/features/layout/presentation/screens/layout-screen.dart';
import 'package:hawiah_client/core/theme/app_colors.dart';
class DriverDetailsOrderScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Map background (you can use Google Maps or a placeholder)
          Positioned.fill(
            child: Image.asset(
              "assets/images/map_design.png",
              fit: BoxFit.fill,
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: AppBar(
              backgroundColor: Colors.transparent,
              actions: [
                IconButton(
                  icon: Container(
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.black,
                      size: 16,
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                )
              ],
            ),
          ),

          // Bottom Sheet
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 0.5.sh,
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "عبدالله علي",
                                style: TextStyle(
                                    fontSize: 15.sp, color: Color(0xff545454)),
                              ),
                              Text(
                                "س ل س - 2 5 1 7",
                                style: TextStyle(
                                    fontSize: 18.sp, color: Colors.black),
                              ),
                              Text(
                                "مرسيدس بنز أكتروس",
                                style: TextStyle(
                                    fontSize: 15.sp, color: Color(0xff545454)),
                              ),
                              Row(
                                children: [
                                  Text(
                                    "5.0",
                                    style: TextStyle(
                                        fontSize: 15.sp,
                                        color: Color(0xff35363F)),
                                  ),
                                  Icon(
                                    Icons.star,
                                    color: Color(0xffFCAF23),
                                    size: 15,
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                        Image.asset(
                          "assets/images/driver_image.PNG",
                          height: 0.2.sh,
                          width: 0.2.sw,
                        )
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: Color(0xffEEEEEE),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text("إرسال رسالة ...."),
                        Image.asset(
                          "assets/icons/send_message_icon.png",
                          height: 30.h,
                          width: 30.w,
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: [
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 10),
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Color(0xffEEEEEE),
                              shape: BoxShape.circle,
                            ),
                            child: Image.asset(
                              "assets/icons/call_us_icon.png",
                              height: 30.h,
                              width: 30.w,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text("تواصل مع الدعم",
                              style: TextStyle(fontSize: 12.sp))
                        ],
                      ),
                      Column(
                        children: [
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 10),
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Color(0xffEEEEEE),
                              shape: BoxShape.circle,
                            ),
                            child: Image.asset(
                              "assets/icons/phone_driver_icon.png",
                              height: 30.h,
                              width: 30.w,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text("تواصل مع السائق",
                              style: TextStyle(fontSize: 12.sp))
                        ],
                      )
                    ],
                  ),
                  Spacer(),
                  Container(
                    alignment: Alignment.bottomCenter,
                    child: GlobalElevatedButton(
                      label: "back_order".tr(),
                      onPressed: () {
                        Navigator.pushAndRemoveUntil<void>(
                          context,
                          MaterialPageRoute<void>(
                            builder: (BuildContext context) =>
                                const LayoutScreen(),
                          ),
                          (route) => false,
                        );
                      },
                      backgroundColor: AppColor.mainAppColor,
                      textColor: Colors.white,
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      borderRadius: BorderRadius.circular(10),
                      fixedWidth: 0.80, // 80% of the screen width
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
