import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hawiah_client/core/custom_widgets/custom_button.dart';
import 'package:hawiah_client/core/locale/app_locale_key.dart';
import 'package:hawiah_client/core/theme/app_colors.dart';
import 'package:hawiah_client/core/theme/app_text_style.dart';
import 'package:hawiah_client/features/order/presentation/model/orders_model.dart';
import 'package:url_launcher/url_launcher.dart';

class InvoiceAndContractButtonsWidget extends StatelessWidget {
  const InvoiceAndContractButtonsWidget({
    super.key,
    required this.ordersData,
  });

  final Data ordersData;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (ordersData.invoice != null)
          _buildPdfButton(
            context,
            label: AppLocaleKey.downloadPDF.tr(),
            url: ordersData.invoice!,
            backgroundColor: const Color(0xff1A3C98),
            textColor: Colors.white,
          ),
        const SizedBox(height: 10),
        if (ordersData.contract != null)
          _buildPdfButton(
            context,
            label: AppLocaleKey.downloadThePDFContract.tr(),
            url: ordersData.contract!,
            backgroundColor: Colors.white,
            textColor: const Color(0xff1A3C98),
            borderSide: const BorderSide(color: Color(0xff1A3C98)),
          ),
      ],
    );
  }

  Widget _buildPdfButton(
    BuildContext context, {
    required String label,
    required String url,
    required Color backgroundColor,
    required Color textColor,
    BorderSide? borderSide,
  }) {
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(16)),
      child: CustomButton(
        text: label,
        onPressed: () => _showPdfOptionsBottomSheet(context, url),
        color: backgroundColor,
        style: AppTextStyle.buttonStyle.copyWith(
          color: textColor,
        ),
        borderRadius: BorderRadius.circular(10),
        borderColor: AppColor.mainAppColor,
      ),
    );
  }

  void _showPdfOptionsBottomSheet(BuildContext context, String pdfUrl) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              AppLocaleKey.chooseAction.tr(),
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            _buildOptionTile(
              icon: Icons.remove_red_eye,
              title: AppLocaleKey.viewInvoice.tr(),
              context: context,
              pdfUrl: pdfUrl,
              launchMode: LaunchMode.inAppWebView,
            ),
            const Divider(),
            _buildOptionTile(
              icon: Icons.download,
              title: AppLocaleKey.downloadInvoice.tr(),
              context: context,
              pdfUrl: pdfUrl,
              launchMode: LaunchMode.externalApplication,
            ),
            const SizedBox(height: 10),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(AppLocaleKey.cancel.tr(), style: AppTextStyle.text16_600),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionTile({
    required IconData icon,
    required String title,
    required BuildContext context,
    required String pdfUrl,
    required LaunchMode launchMode,
  }) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title, style: AppTextStyle.text16_600),
      onTap: () async {
        Navigator.pop(context);
        final uri = Uri.parse(pdfUrl);

        if (await canLaunchUrl(uri)) {
          await launchUrl(
            uri,
            mode: launchMode,
            webViewConfiguration: const WebViewConfiguration(enableJavaScript: true),
          );
        } else {
          Fluttertoast.showToast(msg: AppLocaleKey.invoiceCannotBeDisplayed.tr());
        }
      },
    );
  }
}
