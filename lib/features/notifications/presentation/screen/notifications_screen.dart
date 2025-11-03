import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:hawiah_client/core/custom_widgets/custom-text-field-widget.dart';
import 'package:hawiah_client/core/custom_widgets/custom_app_bar.dart';
import 'package:hawiah_client/core/images/app_images.dart';
import 'package:hawiah_client/core/locale/app_locale_key.dart';
import 'package:hawiah_client/core/theme/app_colors.dart';
import 'package:hawiah_client/core/theme/app_text_style.dart';
import 'package:hawiah_client/features/notifications/presentation/cubit/notifications_cubit.dart';
import 'package:hawiah_client/features/notifications/presentation/cubit/notifications_state.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    context.read<NotificationsCubit>().getnotifications();

    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text.toLowerCase();
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        context,
        appBarColor: AppColor.whiteColor,
        title: Text(
          AppLocaleKey.notifications.tr(),
          style: AppTextStyle.text16_400,
        ),
        centerTitle: true,
      ),
      body: BlocBuilder<NotificationsCubit, NotificationsState>(
        builder: (context, state) {
          final cubit = context.read<NotificationsCubit>();
          final notifications = cubit.setting?.notifications ?? [];
          final locale = context.locale.languageCode;

          final filteredNotifications = notifications.where((item) {
            final title = (locale == 'ar' ? item.title.ar : item.title.en).toLowerCase() ?? '';
            final message =
                (locale == 'ar' ? item.message.ar : item.message.en).toLowerCase() ?? '';
            return title.contains(_searchQuery) || message.contains(_searchQuery);
          }).toList();

          if (state is NotificationsLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is NotificationsUpdate) {
            if (notifications.isEmpty) return _buildEmptyState();

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8.0),
              child: Column(
                children: [
                  Material(
                    elevation: 4,
                    shadowColor: Colors.black26,
                    borderRadius: BorderRadius.circular(12),
                    child: CustomTextField(
                      controller: _searchController,
                      fillColor: Colors.white,
                      hintText: AppLocaleKey.search.tr(),
                      prefixIcon: Padding(
                        padding: const EdgeInsets.all(10),
                        child: SvgPicture.asset(
                          AppImages.search,
                          color: AppColor.mainAppColor,
                          height: 16,
                          width: 16,
                        ),
                      ),
                      suffixIcon: Padding(
                        padding: const EdgeInsets.all(11),
                        child: SvgPicture.asset(
                          AppImages.filter,
                          color: AppColor.mainAppColor,
                          height: 10,
                          width: 16,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Divider(thickness: 1, color: Colors.grey.shade300),
                  Expanded(
                    child: filteredNotifications.isEmpty
                        ? _buildEmptyState()
                        : ListView.builder(
                            itemCount: filteredNotifications.length,
                            itemBuilder: (context, index) {
                              final item = filteredNotifications[index];
                              final title = locale == 'ar' ? item.title.ar : item.title.en;
                              final message = locale == 'ar' ? item.message.ar : item.message.en;
                              return Padding(
                                padding: const EdgeInsets.symmetric(vertical: 10),
                                child: ListTile(
                                  title: Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          title ?? '',
                                          style: AppTextStyle.text16_700,
                                        ),
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
                                    message ?? '',
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
                            },
                          ),
                  ),
                ],
              ),
            );
          }

          return const SizedBox();
        },
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

  Widget _buildEmptyState() => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(AppImages.notification, height: 80, width: 80),
            const SizedBox(height: 16),
            Text(AppLocaleKey.noNotifications.tr(), style: AppTextStyle.text20_500),
          ],
        ),
      );
}
