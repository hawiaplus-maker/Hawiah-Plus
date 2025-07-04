import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hawiah_client/core/custom_widgets/custom_image/custom_network_image.dart';
import 'package:hawiah_client/core/images/app_images.dart';
import 'package:hawiah_client/core/theme/app_colors.dart';
import 'package:hawiah_client/core/theme/app_text_style.dart';
import 'package:hawiah_client/core/utils/date_methods.dart';
import 'package:hawiah_client/features/order/presentation/functions/show-feedback-bottom-sheet.dart';
import 'package:hawiah_client/features/order/presentation/model/orders_model.dart';
import 'package:hawiah_client/features/order/presentation/widget/custom_list_item.dart';

import '../../../../core/custom_widgets/global-elevated-button-widget.dart';

class OldOrderScreen extends StatelessWidget {
  const OldOrderScreen({Key? key, required this.ordersDate}) : super(key: key);
  @override
  final Data ordersDate;
  Widget build(BuildContext context) {
    final double totalPrice =
        double.tryParse(ordersDate.totalPrice ?? "0") ?? 0;
    final double vat = totalPrice * 0.15;
    final double netTotal = totalPrice + vat;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'تفاصيل الطلب',
          style: AppTextStyle.text20_700,
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_sharp,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
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
                  Row(
                    children: [
                      // Vehicle Image
                      CustomNetworkImage(
                        imageUrl: ordersDate.image ?? "",
                        fit: BoxFit.fill,
                        height: 60.h,
                        width: 60.w,
                      ),
                      SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 10),
                          Text(
                            ordersDate.product ?? "",
                            style: AppTextStyle.text16_700,
                          ),
                          SizedBox(height: 5.h),
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: ' طلب رقم:',
                                  style: AppTextStyle.text16_600.copyWith(
                                    color: AppColor.blackColor
                                        .withValues(alpha: 0.7),
                                  ),
                                ),
                                TextSpan(
                                  text: ordersDate.referenceNumber ?? '',
                                  style: AppTextStyle.text16_500.copyWith(
                                    color: AppColor.blackColor
                                        .withValues(alpha: 0.7),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 5.h),
                          Text(
                            DateMethods.formatToFullData(
                              DateTime.tryParse(ordersDate.createdAt ?? "") ??
                                  DateTime.now(),
                            ),
                            style: AppTextStyle.text16_600.copyWith(
                              color: AppColor.blackColor.withValues(alpha: 0.3),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 10.h),
                  Container(
                    margin:
                        EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
                    child: GlobalElevatedButton(
                      icon: Image.asset(
                        AppImages.refreshCw,
                        height: 20.0,
                        width: 20.0,
                        color: Colors.white,
                      ),
                      label: "إعادة الطلب",
                      onPressed: () {},
                      backgroundColor: AppColor.mainAppColor,
                      textColor: Colors.white,
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      borderRadius: BorderRadius.circular(12),
                      fixedWidth: 0.70, // 80% of the screen width
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
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              ordersDate.driver ?? "",
                              style: AppTextStyle.text14_600,
                            ),
                            Text(
                              "س ل س - 2 5 1 7",
                              style: AppTextStyle.text16_700,
                            ),
                            Text(
                              "مرسيدس بنز أكتروس",
                              style: AppTextStyle.text14_600
                                  .copyWith(color: Color(0xff545454)),
                            ),
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
                  GestureDetector(
                    onTap: () => showFeedbackBottomSheet(context),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          "assets/icons/like_icon.png",
                          height: 20.0,
                          width: 20.0,
                          color: Color(0xff1A3C98),
                        ),
                        SizedBox(width: 8.0),
                        Text(
                          "تقييم المندوب",
                          style: AppTextStyle.text16_600.copyWith(
                            color: Color(0xff1A3C98),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            SizedBox(height: 8.0),
            Container(
              child: Column(
                children: [
                  CustomListItem(
                    title: 'سعر الطلب',
                    subtitle: "${totalPrice.toStringAsFixed(2)} ريال",
                  ),
                  SizedBox(height: 20),
                  CustomListItem(
                    title: 'ضريبة القيمة المضافة (15%)',
                    subtitle: "${vat.toStringAsFixed(2)} ريال",
                  ),
                  SizedBox(height: 10),
                  Divider(),
                  SizedBox(height: 10),
                  CustomListItem(
                    title: 'الإجمالي الصافي',
                    subtitle: "${netTotal.toStringAsFixed(2)} ريال",
                  ),
                  SizedBox(height: 60.0),
                  Container(
                    alignment: Alignment.bottomCenter,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: GlobalElevatedButton(
                      label: "تحميل الفاتورة PDF",
                      onPressed: () {},
                      backgroundColor: Color(0xff1A3C98),
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
            SizedBox(height: 10.0),
          ],
        ),
      ),
    );
  }
}
