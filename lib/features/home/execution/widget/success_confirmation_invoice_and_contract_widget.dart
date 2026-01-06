import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hawiah_client/core/images/app_images.dart';
import 'package:hawiah_client/core/locale/app_locale_key.dart';
import 'package:hawiah_client/features/home/execution/widget/doc_action_card.dart';
import 'package:hawiah_client/features/home/presentation/model/doc_model.dart';
import 'package:hawiah_client/features/order/presentation/model/order_details_model.dart';
import 'package:url_launcher/url_launcher.dart';

class SuccessConfirmationInvoiceAndContractWidget extends StatelessWidget {
  final OrderDetailsModel ordersModel;

  const SuccessConfirmationInvoiceAndContractWidget({
    super.key,
    required this.ordersModel,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: DocumentActionCard(
            image: AppImages.invoiceImage,
            title: AppLocaleKey.invoice.tr(),
            subtitle: "",
            downloadText: AppLocaleKey.downloadInvoice.tr(),
            pdfUrl: ordersModel.invoice ?? "",
            actions: [
              DocumentAction(
                icon: Icons.remove_red_eye,
                title: AppLocaleKey.viewInvoice.tr(),
                launchMode: LaunchMode.externalApplication,
              ),
              DocumentAction(
                icon: Icons.download,
                title: AppLocaleKey.downloadInvoice.tr(),
                launchMode: LaunchMode.externalApplication,
              ),
            ],
          ),
        ),
        const SizedBox(width: 20),
        Expanded(
          child: DocumentActionCard(
            image: AppImages.contractImage,
            title: AppLocaleKey.contract.tr(),
            subtitle: "",
            downloadText: AppLocaleKey.downloadContract.tr(),
            pdfUrl: ordersModel.contract ?? "",
            actions: [
              DocumentAction(
                icon: Icons.remove_red_eye,
                title: AppLocaleKey.viewContract.tr(),
                launchMode: LaunchMode.externalApplication,
              ),
              DocumentAction(
                icon: Icons.download,
                title: AppLocaleKey.downloadContract.tr(),
                launchMode: LaunchMode.externalApplication,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
