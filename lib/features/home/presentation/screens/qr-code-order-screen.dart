import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hawiah_client/core/custom_widgets/global-elevated-button-widget.dart';
import 'package:hawiah_client/features/home/presentation/screens/driver-details-order-screen.dart';
import 'package:hawiah_client/features/layout/presentation/screens/layout-screen.dart';

class QrCodeOrderScreen extends StatelessWidget {
  const QrCodeOrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("order_details".tr()), // Translated title
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          children: [
            // QR code image with responsive size
            Image.asset(
              "assets/icons/qr_code_here_logo.png",
              height: 0.20.sh, // 20% of screen height
              width: 0.70.sw, // 70% of screen width
            ),
            SizedBox(height: 20.h),
            Column(
              children: [
                CustomListTile(
                  title: "العقد",
                  subtitle: "تحميل العقد",
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: Colors.black54,
                  ),
                  onTap: () {
                    // Handle the onTap action here (e.g., navigate to another screen)
                  },
                ),
                Divider(
                  color: Color(0xffA4A4A4),
                ),
                CustomListTile(
                  title: "المندوب",
                  subtitle: "عبدالله علي",
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: Colors.black54,
                  ),
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) =>  DriverDetailsOrderScreen()));
                  },
                ),
                Divider(
                  color: Color(0xffA4A4A4),
                ),
                CustomListTile(
                  title: "الحالة",
                  subtitle: "جاري التحضير",
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: Colors.black54,
                  ),
                  onTap: () {
                    // Handle onTap for the third item
                  },
                ),
              ],
            ),
            Spacer(),
            // Continue Button
            Container(
              margin: EdgeInsets.symmetric(vertical: 20.h, horizontal: 20.w),
              alignment: Alignment.topCenter,
              child: GlobalElevatedButton(
                label: "cancel_order".tr(),
                onPressed: () {
                  Navigator.pushAndRemoveUntil<void>(
                context,
                MaterialPageRoute<void>(
                  builder: (BuildContext context) => const LayoutScreen(),
                ),
                (route) => false,
              );
                },
                backgroundColor: Colors.white,
                textColor: Colors.red,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                borderRadius: BorderRadius.circular(10),

                fixedWidth: 0.80.sw, // 80% of the screen width
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomListTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget trailing;
  final VoidCallback onTap;

  const CustomListTile({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.trailing,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        title,
        style: TextStyle(fontSize: 15.sp),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(fontSize: 15.sp, color: Color(0xff007AFF)),
      ),
      trailing: Container(
        padding: EdgeInsets.all(2),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Color(0xffEDEEFF),
        ),
        child: trailing,
      ),
      onTap: onTap,
    );
  }
}
