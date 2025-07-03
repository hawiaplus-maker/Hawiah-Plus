import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hawiah_client/core/custom_widgets/global-elevated-button-widget.dart';
import 'package:hawiah_client/features/home/presentation/screens/qr-code-order-screen.dart';
import 'package:hawiah_client/core/theme/app_colors.dart';
class PaymentScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Icon(Icons.arrow_back, color: Colors.black),
        title: Text(
          "وسيلة الدفع",
          style: TextStyle(color: Colors.black, fontSize: 20),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Order Summary Section
            Container(
              decoration: BoxDecoration(
                color: Color(0xffFCFCFC),
                borderRadius: BorderRadius.circular(8),
              ),
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  buildSummaryRow("سعر الطلب", "1000 ريال",
                      isBold: false, fontSize: 13),
                  buildSummaryRow("مصاريف التوصيل", "100 ريال",
                      isBold: false, fontSize: 13),
                  buildSummaryRow("ضريبة القيمة المضافة (15%)", "150 ريال",
                      isBold: false, fontSize: 13),
                  Divider(),
                  buildSummaryRow("الإجمالي الصافي", "1250 ريال",
                      isBold: true, fontSize: 14),
                ],
              ),
            ),
            SizedBox(height: 24),
            // Payment Methods Section
            Text(
              "الدفع بواسطة",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            buildPaymentOption(
              context,
              title: "دفع إلكتروني",
              icon: Row(
                children: [
                  Image.asset('assets/icons/mastercard_logo.png', height: 24),
                  SizedBox(width: 8),
                  Image.asset('assets/icons/visa_logo.png', height: 24),
                ],
              ),
              isSelected: true,
            ),
            buildPaymentOption(
              context,
              title: "مدى باي",
              icon:
                  Image.asset('assets/icons/mada_payment_logo.png', height: 24),
            ),
            buildPaymentOption(
              context,
              title: "آبل باي",
              icon: Image.asset('assets/icons/apple_pay_logo.png', height: 24),
            ),
            Spacer(),
            // Continue Button
            Container(
              margin: EdgeInsets.symmetric(vertical: 20.h, horizontal: 20.w),
              alignment: Alignment.topCenter,
              child: GlobalElevatedButton(
                label: "continue_payment".tr(),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => QrCodeOrderScreen()));
                },
                backgroundColor: AppColor.mainAppColor,
                textColor: Colors.white,
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

  Widget buildSummaryRow(String title, String value,
      {bool isBold = false, double fontSize = 16}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildPaymentOption(BuildContext context,
      {required String title, required Widget icon, bool isSelected = false}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      decoration: BoxDecoration(
        color: isSelected ? Colors.green.shade50 : Colors.white,
        border: Border.all(
          color: isSelected ? Colors.green : Colors.grey.shade300,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          if (isSelected)
            Icon(
              Icons.check_circle,
              color: Color(0xff5FFF9F),
            ),
          SizedBox(width: 16),
          Text(
            title,
            style: TextStyle(fontSize: 16),
          ),
          Spacer(),
          icon,
        ],
      ),
    );
  }
}
