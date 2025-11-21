import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hawiah_client/core/custom_widgets/app_bottom_sheet.dart';
import 'package:hawiah_client/core/locale/app_locale_key.dart';
import 'package:hawiah_client/core/theme/app_colors.dart';
import 'package:hawiah_client/core/theme/app_text_style.dart';
import 'package:hawiah_client/core/utils/navigator_methods.dart';
import 'package:hawiah_client/features/home/presentation/model/doc_model.dart';
import 'package:url_launcher/url_launcher.dart';

class DocumentActionCard extends StatelessWidget {
  final String image;
  final String title;
  final String subtitle;
  final String downloadText;
  final String pdfUrl;
  final List<DocumentAction> actions;

  const DocumentActionCard({
    super.key,
    required this.image,
    required this.title,
    required this.subtitle,
    required this.downloadText,
    required this.pdfUrl,
    required this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => NavigatorMethods.showAppBottomSheet(
        context,
        AppBottomSheet(
          title: "",
          children: [
            Text(
              AppLocaleKey.chooseAction.tr(),
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ...actions.map((a) => _buildOptionTile(a, context)).toList(),
            const SizedBox(height: 10),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(AppLocaleKey.cancel.tr()),
            ),
          ],
        ),
      ),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColor.lightMainAppColor.withAlpha(80)),
        ),
        child: Column(
          children: [
            Image.asset(image, height: 40),
            Text(title, style: AppTextStyle.text14_500),
            Text(
              subtitle,
              style: AppTextStyle.text14_400.copyWith(color: AppColor.greyTextColor),
            ),
            const SizedBox(height: 5),
            SizedBox(
              width: double.infinity,
              child: Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                color: AppColor.mainAppColor,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: Center(
                    child: Text(
                      downloadText,
                      style: AppTextStyle.text12_500.copyWith(color: AppColor.whiteColor),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildOptionTile(DocumentAction action, BuildContext context) {
    return ListTile(
      leading: Icon(action.icon),
      title: Text(action.title),
      onTap: () async {
        Navigator.pop(context);

        final uri = Uri.parse(pdfUrl);

        if (await canLaunchUrl(uri)) {
          await launchUrl(
            uri,
            mode: action.launchMode,
            webViewConfiguration: const WebViewConfiguration(enableJavaScript: true),
          );
        } else {
          Fluttertoast.showToast(msg: AppLocaleKey.invoiceCannotBeDisplayed.tr());
        }
      },
    );
  }
}
