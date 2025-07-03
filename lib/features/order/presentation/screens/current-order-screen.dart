import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hawiah_client/features/home/presentation/screens/qr-code-order-screen.dart';
import 'package:hawiah_client/features/order/presentation/screens/extend-time-order-screen.dart';
import 'package:hawiah_client/core/theme/app_colors.dart';
import '../../../../core/custom_widgets/global-elevated-button-widget.dart';

class CurrentOrderScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('تفاصيل الطلب'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              // Vehicle Image
                              Image.asset(
                                'assets/images/car_image.png', // Replace with your image path
                                width: 60,
                                height: 60,
                              ),
                              SizedBox(width: 10),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "حاوية طبية",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    "صغيرة",
                                    style: TextStyle(
                                      color: Colors.black54,
                                      fontSize: 14,
                                    ),
                                  ),
                                  Text(
                                    'طلب رقم: 123652145',
                                    style: TextStyle(
                                      fontSize: 14.0,
                                      color: Colors.black54,
                                    ),
                                  ),
                                  Text(
                                    "12 نوفمبر, 2024",
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const QrCodeOrderScreen(),
                              ),
                            );
                          },
                          child: Column(
                            children: [
                              Image.asset("assets/icons/qr_example.png",
                                  height: 40.0, width: 40.0),
                              SizedBox(height: 4.0),
                              Text('باركود الطلب',
                                  style: TextStyle(fontSize: 13.0)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin:
                        EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GlobalElevatedButton(
                          icon: Image.asset(
                            "assets/icons/twenty_four_icon.png",
                            height: 20.0,
                            width: 20.0,
                          ),
                          label: "تمديد المدة",
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const ExtendTimeOrderScreen(),
                              ),
                            );
                          },
                          backgroundColor: AppColor.mainAppColor,
                          textColor: Colors.white,
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 12),
                          borderRadius: BorderRadius.circular(20),
                          fixedWidth: 0.40, // 80% of the screen width
                        ),
                        GlobalElevatedButton(
                          icon: Image.asset(
                            "assets/icons/unlink_svgrepo_icon.png",
                            height: 20.0,
                            width: 20.0,
                            color: Colors.red,
                          ),
                          label: "إفراغ الحاوية",
                          onPressed: () {},
                          backgroundColor: Colors.white,
                          textColor: Colors.red,
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 12),
                          borderRadius: BorderRadius.circular(20),
                          fixedWidth: 0.40, // 80% of the screen width
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            SizedBox(height: 16.0),
            Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(8.0),
              ),
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
                          style:
                              TextStyle(fontSize: 18.sp, color: Colors.black),
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
                                  fontSize: 15.sp, color: Color(0xff35363F)),
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
                    width: 0.35.sw,
                  )
                ],
              ),
            ),
            SizedBox(
              height: 5,
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
              height: 20.h,
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
                    Text("تواصل مع الدعم", style: TextStyle(fontSize: 12.sp))
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
                    Text("تواصل مع السائق", style: TextStyle(fontSize: 12.sp))
                  ],
                )
              ],
            ),
            SizedBox(height: 16.0),
            Divider(),
            Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Column(
                children: [
                  ListTile(
                    title: Text('سعر الطلب'),
                    trailing: Text('1000 ريال'),
                  ),
                  ListTile(
                    title: Text('مصاريف التوصيل'),
                    trailing: Text('100 ريال'),
                  ),
                  ListTile(
                    title: Text('ضريبة القيمة المضافة (15%)'),
                    trailing: Text('150 ريال'),
                  ),
                  Divider(),
                  ListTile(
                    title: Text(
                      'الإجمالي الصافي',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    trailing: Text(
                      '1250 ريال',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(height: 16.0),
                  Container(
                    alignment: Alignment.bottomCenter,
                    child: GlobalElevatedButton(
                      label: "تحميل الفاتورة PDF",
                      onPressed: () {},
                      backgroundColor: AppColor.mainAppColor,
                      textColor: Colors.white,
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      borderRadius: BorderRadius.circular(20),
                      fixedWidth: 0.80, // 80% of the screen width
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 8.0),
            Container(
              alignment: Alignment.bottomCenter,
              child: GlobalElevatedButton(
                label: "إلغاء الطلب",
                onPressed: () {},
                backgroundColor: Colors.white,
                textColor: Colors.red,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                borderRadius: BorderRadius.circular(20),
                fixedWidth: 0.80, // 80% of the screen width
              ),
            ),
          ],
        ),
      ),
    );
  }
}
