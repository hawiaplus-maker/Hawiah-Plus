import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hawiah_client/core/custom_widgets/custom_app_bar.dart';
import 'package:hawiah_client/core/custom_widgets/custom_image/custom_network_image.dart';
import 'package:hawiah_client/core/images/app_images.dart';
import 'package:hawiah_client/core/locale/app_locale_key.dart';
import 'package:hawiah_client/core/theme/app_colors.dart';
import 'package:hawiah_client/core/theme/app_text_style.dart';
import 'package:hawiah_client/core/utils/date_methods.dart';
import 'package:hawiah_client/features/order/presentation/functions/show-feedback-bottom-sheet.dart';
import 'package:hawiah_client/features/order/presentation/model/orders_model.dart';
import 'package:hawiah_client/features/order/presentation/widget/custom_list_item.dart';
import 'package:url_launcher/url_launcher.dart';
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
      appBar: CustomAppBar(
        context,
        titleText: AppLocaleKey.orderDetails.tr(),
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
                                  text: AppLocaleKey.orderNumber.tr(),
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
                      label: AppLocaleKey.reOrder.tr(),
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
                          AppLocaleKey.delegateEvaluation.tr(),
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
                    title: AppLocaleKey.askPrice.tr(),
                    subtitle:
                        "${totalPrice.toStringAsFixed(2)} ${AppLocaleKey.sarr.tr()}",
                  ),
                  SizedBox(height: 20),
                  CustomListItem(
                    title: AppLocaleKey.valueAdded.tr(),
                    subtitle:
                        "${vat.toStringAsFixed(2)} ${AppLocaleKey.sarr.tr()}",
                  ),
                  SizedBox(height: 10),
                  Divider(),
                  SizedBox(height: 10),
                  CustomListItem(
                    title: AppLocaleKey.netTotal.tr(),
                    subtitle:
                        "${netTotal.toStringAsFixed(2)} ${AppLocaleKey.sarr.tr()}",
                  ),
                  SizedBox(height: 60.0),
                  Container(
                    alignment: Alignment.bottomCenter,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: GlobalElevatedButton(
                      label: AppLocaleKey.downloadPDF.tr(),
                      onPressed: () {
                        final invoiceUrl = ordersDate.invoice;
                        if (invoiceUrl != null) {
                          _showPdfOptionsBottomSheet(invoiceUrl,
                              context: context);
                        } else {
                          Fluttertoast.showToast(
                              msg: AppLocaleKey.invoiceCannotBeDisplayed.tr());
                        }
                      },
                      backgroundColor: Color(0xff1A3C98),
                      textColor: Colors.white,
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      borderRadius: BorderRadius.circular(10),
                      fixedWidth: 0.80,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10.0),
            Container(
              alignment: Alignment.bottomCenter,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
              ),
              child: GlobalElevatedButton(
                label: AppLocaleKey.downloadThePDFContract.tr(),
                onPressed: () {
                  final invoiceUrl = ordersDate.contract;
                  if (invoiceUrl != null) {
                    _showPdfOptionsBottomSheet(invoiceUrl, context: context);
                  } else {
                    Fluttertoast.showToast(
                        msg: AppLocaleKey.invoiceCannotBeDisplayed.tr());
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
            SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  void _showPdfOptionsBottomSheet(String pdfUrl,
      {required BuildContext context}) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                AppLocaleKey.chooseAction.tr(),
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              ListTile(
                leading: Icon(Icons.remove_red_eye),
                title: Text(
                  AppLocaleKey.viewInvoice.tr(),
                  style: AppTextStyle.text16_600,
                ),
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
                    Fluttertoast.showToast(
                        msg: AppLocaleKey.invoiceCannotBeDisplayed.tr());
                  }
                },
              ),
              Divider(),
              ListTile(
                leading: Icon(Icons.download),
                title: Text(
                  AppLocaleKey.downloadInvoice.tr(),
                  style: AppTextStyle.text16_600,
                ),
                onTap: () async {
                  Navigator.pop(context);
                  if (await canLaunchUrl(Uri.parse(pdfUrl))) {
                    await launchUrl(
                      Uri.parse(pdfUrl),
                      mode: LaunchMode.externalApplication,
                    );
                  } else {
                    Fluttertoast.showToast(
                        msg: AppLocaleKey.invoiceCannotBeDisplayed.tr());
                  }
                },
              ),
              SizedBox(height: 10),
              TextButton(
                child: Text(AppLocaleKey.cancel.tr()),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
        );
      },
    );
  }
}
