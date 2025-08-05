import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hawiah_client/core/custom_widgets/custom_app_bar.dart';
import 'package:hawiah_client/core/custom_widgets/custom_button.dart';
import 'package:hawiah_client/core/custom_widgets/custom_image/custom_network_image.dart';
import 'package:hawiah_client/core/images/app_images.dart';
import 'package:hawiah_client/core/networking/urls.dart';
import 'package:hawiah_client/core/theme/app_colors.dart';
import 'package:hawiah_client/core/theme/app_text_style.dart';
import 'package:hawiah_client/core/utils/date_methods.dart';
import 'package:hawiah_client/core/utils/navigator_methods.dart';
import 'package:hawiah_client/features/chat/presentation/screens/single-chat-screen.dart';
import 'package:hawiah_client/features/order/presentation/model/orders_model.dart';
import 'package:hawiah_client/features/order/presentation/screens/extend-time-order-screen.dart';
import 'package:hawiah_client/features/order/presentation/widget/custom_list_item.dart';
import 'package:hawiah_client/features/profile/presentation/cubit/cubit_profile.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/custom_widgets/global-elevated-button-widget.dart';

class CurrentOrderScreen extends StatelessWidget {
  const CurrentOrderScreen({
    Key? key,
    required this.ordersDate,
  }) : super(key: key);
  final Data ordersDate;
  @override
  Widget build(BuildContext context) {
    final double totalPrice = double.tryParse(ordersDate.totalPrice ?? "0") ?? 0;
    final double vat = totalPrice * 0.15;
    final double netTotal = totalPrice + vat;
    return Scaffold(
      appBar: CustomAppBar(
        context,
        titleText: 'تفاصيل الطلب',
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
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
                              Flexible(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(15.0),
                                  child: CustomNetworkImage(
                                    imageUrl: ordersDate.image ?? "",
                                    fit: BoxFit.fill,
                                    height: 60.h,
                                    width: 60.w,
                                  ),
                                ),
                              ),
                              SizedBox(width: 10),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
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
                                            color: AppColor.blackColor.withValues(alpha: 0.7),
                                          ),
                                        ),
                                        TextSpan(
                                          text: ordersDate.referenceNumber ?? '',
                                          style: AppTextStyle.text16_500.copyWith(
                                            color: AppColor.blackColor.withValues(alpha: 0.7),
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
                        ),
                        Card(
                          color: AppColor.whiteColor,
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                            child: Text(ordersDate.otp.toString(), style: AppTextStyle.text18_700),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
                    child: Row(
                      children: [
                        Flexible(
                          child: CustomButton(
                            prefixIcon: Image.asset(
                              AppImages.refreshCw,
                              height: 20.0,
                              width: 20.0,
                              color: Colors.white,
                            ),
                            color: AppColor.mainAppColor,
                            text: 'إعادة الطلب ',
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ExtendTimeOrderScreen(
                                    orderId: ordersDate.id ?? 0,
                                    duration: ordersDate.duration ?? 0,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(width: 30),
                        Flexible(
                          child: CustomButton(
                            color: Colors.transparent,
                            prefixIcon: Image.asset(
                              AppImages.trendDown,
                              height: 20.0,
                              width: 20.0,
                              color: Colors.red,
                            ),
                            child: Text(
                              'إفراغ الحاوية',
                              style: AppTextStyle.text16_600.copyWith(
                                color: AppColor.redColor,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            SizedBox(height: 16.0),
            Container(
              padding: const EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 10.h),
                            Text(
                              ordersDate.driver ?? "",
                              style: AppTextStyle.text16_700,
                            ),
                            SizedBox(
                              height: 10.h,
                            ),
                            if ((ordersDate.vehicles?.isNotEmpty ?? false))
                              Text(
                                " ${ordersDate.vehicles!.first.plateLetters} ${ordersDate.vehicles!.first.plateNumbers}",
                                style: AppTextStyle.text16_700,
                              ),
                            SizedBox(
                              height: 10.h,
                            ),
                            if (ordersDate.vehicles?.isNotEmpty == true)
                              Text(
                                "${ordersDate.vehicles!.first.carModel} ${ordersDate.vehicles!.first.carType} ${ordersDate.vehicles!.first.carBrand}",
                                style: AppTextStyle.text14_600.copyWith(color: Color(0xff545454)),
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
                    onTap: () {
                      NavigatorMethods.pushNamed(context, SingleChatScreen.routeName,
                          arguments: SingleChatScreenArgs(
                              onMessageSent: () {},
                              reciverId: ordersDate.driverId.toString(),
                              reciverType: "driver",
                              reciverName: "محمد",
                              reciverImage: Urls.testUserImage,
                              senderId: context.read<ProfileCubit>().user.id.toString(),
                              senderType: "user",
                              orderId: ordersDate.id.toString()));
                    },
                    child: Container(
                      height: 50.h,
                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: Color(0xffEEEEEE),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "إرسال رسالة ....",
                            style: AppTextStyle.text14_500,
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          Image.asset(
                            AppImages.send,
                            height: 30.h,
                            width: 30.w,
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 10.h),
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
                        color: Color(0xffD9D9D9),
                        shape: BoxShape.circle,
                      ),
                      child: Image.asset(
                        AppImages.phone,
                        height: 30.h,
                        width: 30.w,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text("تواصل مع السائق", style: TextStyle(fontSize: 12.sp))
                  ],
                ),
                Column(
                  children: [
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Color(0xffD9D9D9),
                        shape: BoxShape.circle,
                      ),
                      child: Image.asset(
                        AppImages.support,
                        height: 30.h,
                        width: 30.w,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text("تواصل مع الدعم", style: TextStyle(fontSize: 12.sp))
                  ],
                )
              ],
            ),
            SizedBox(height: 60.0),
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
                  SizedBox(height: 50.0),
                  if (ordersDate.invoice != null)
                    Container(
                      alignment: Alignment.bottomCenter,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: GlobalElevatedButton(
                        label: "تحميل الفاتورة PDF",
                        onPressed: () {
                          final invoiceUrl = ordersDate.invoice;
                          if (invoiceUrl != null) {
                            _showPdfOptionsBottomSheet(invoiceUrl, context: context);
                          } else {
                            Fluttertoast.showToast(msg: 'الفاتورة غير متوفرة');
                          }
                        },
                        backgroundColor: Color(0xff1A3C98),
                        textColor: Colors.white,
                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        borderRadius: BorderRadius.circular(10),
                        fixedWidth: 0.80,
                      ),
                    ),
                ],
              ),
            ),
            SizedBox(height: 10.0),
            if (ordersDate.contract != null)
              Container(
                alignment: Alignment.bottomCenter,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: GlobalElevatedButton(
                  label: "تحميل العقد PDF",
                  onPressed: () {
                    final invoiceUrl = ordersDate.contract;
                    if (invoiceUrl != null) {
                      _showPdfOptionsBottomSheet(invoiceUrl, context: context);
                    } else {
                      Fluttertoast.showToast(msg: 'الفاتورة غير متوفرة');
                    }
                  },
                  backgroundColor: Colors.white,
                  textColor: Color(0xff1A3C98),
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  borderRadius: BorderRadius.circular(10),
                  fixedWidth: 0.80,
                  side: BorderSide(color: Color(0xff1A3C98)),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _showPdfOptionsBottomSheet(String pdfUrl, {required BuildContext context}) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'اختر الإجراء',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              ListTile(
                leading: Icon(Icons.remove_red_eye),
                title: Text('عرض الفاتورة'),
                onTap: () async {
                  Navigator.pop(context);
                  if (await canLaunchUrl(Uri.parse(pdfUrl))) {
                    await launchUrl(
                      Uri.parse(pdfUrl),
                      mode: LaunchMode.inAppWebView,
                      webViewConfiguration: WebViewConfiguration(
                        enableJavaScript: true,
                      ),
                    );
                  } else {
                    Fluttertoast.showToast(msg: 'لا يمكن عرض الفاتورة');
                  }
                },
              ),
              Divider(),
              ListTile(
                leading: Icon(Icons.download),
                title: Text('تحميل الفاتورة'),
                onTap: () async {
                  Navigator.pop(context);
                  if (await canLaunchUrl(Uri.parse(pdfUrl))) {
                    await launchUrl(
                      Uri.parse(pdfUrl),
                      mode: LaunchMode.externalApplication,
                    );
                  } else {
                    Fluttertoast.showToast(msg: 'لا يمكن تحميل الفاتورة');
                  }
                },
              ),
              SizedBox(height: 10),
              TextButton(
                child: Text('إلغاء'),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
        );
      },
    );
  }
}
