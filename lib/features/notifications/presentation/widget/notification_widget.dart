import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:hawiah_client/core/images/app_images.dart';
import 'package:hawiah_client/core/theme/app_colors.dart';
import 'package:hawiah_client/core/theme/app_text_style.dart';
import 'package:hawiah_client/features/notifications/model/notifications_model.dart';

class NotificationWidget extends StatelessWidget {
  const NotificationWidget({super.key, required this.item});

  final Datum item;
  @override
  Widget build(BuildContext context) {
    final locale = context.locale.languageCode;
    final title = locale == 'ar' ? item.title?.ar : item.title?.en;
    final message = locale == 'ar' ? item.message?.ar : item.message?.en;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: ListTile(
        title: Row(
          children: [
            Text(
              title ?? "-----------",
              style: AppTextStyle.text16_700,
            ),
            Gap(10.w),
            Text(
              _formatRelativeTime(item.createdAt),
              style: AppTextStyle.text12_400.copyWith(
                color: AppColor.textGrayColor,
              ),
            ),
          ],
        ),
        subtitle: Text(
          message ?? "-----------",
          style: AppTextStyle.text14_400.copyWith(
            color: AppColor.textGrayColor,
          ),
        ),
        trailing: GestureDetector(
          onTap: () {},
          child: SvgPicture.asset(
            AppImages.trash,
            height: 24,
            width: 24,
          ),
        ),
      ),
    );
  }

  String _formatRelativeTime(DateTime? date) {
    if (date == null) return '';
    final now = DateTime.now();
    final diff = now.difference(date);

    if (diff.inSeconds < 60) return 'الآن';
    if (diff.inMinutes < 60) return 'منذ ${diff.inMinutes} دقيقة';
    if (diff.inHours < 24) return 'منذ ${diff.inHours} ساعة';
    if (diff.inDays == 1) return 'أمس';
    if (diff.inDays < 7) return 'منذ ${diff.inDays} أيام';
    return DateFormat('yyyy/MM/dd').format(date);
  }
}
