import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hawiah_client/core/custom_widgets/api_response_widget.dart';
import 'package:hawiah_client/core/custom_widgets/custom_app_bar.dart';
import 'package:hawiah_client/core/images/app_images.dart';
import 'package:hawiah_client/core/locale/app_locale_key.dart';
import 'package:hawiah_client/core/theme/app_text_style.dart';
import 'package:hawiah_client/features/setting/cubit/setting_cubit.dart';
import 'package:hawiah_client/features/setting/cubit/setting_state.dart';
import 'package:url_launcher/url_launcher.dart';

class SupportScreen extends StatefulWidget {
  const SupportScreen({super.key});

  @override
  State<SupportScreen> createState() => _SupportScreenState();
}

class _SupportScreenState extends State<SupportScreen> {
  @override
  void initState() {
    context.read<SettingCubit>().initialSetting();
    context.read<SettingCubit>().getsetting();
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        context,
        titleText: AppLocaleKey.support.tr(),
      ),
      body: ApiResponseWidget(
        apiResponse: context.watch<SettingCubit>().settingResponse,
        onReload: () => context.read<SettingCubit>().getsetting(),
        isEmpty: false,
        child: Container(
          margin: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 16,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  AppLocaleKey.canContactUs.tr(),
                  style: AppTextStyle.text16_700,
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "email".tr(),
                  style: AppTextStyle.text18_700,
                ),
              ),
              BlocBuilder<SettingCubit, SettingState>(
                builder: (context, state) {
                  final setting = context.read<SettingCubit>().setting;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: GestureDetector(
                          onTap: () => _launchURL(setting?.email, isEmail: true),
                          child: Container(
                            height: 80,
                            width: double.infinity,
                            margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100.withValues(alpha: .5),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  context.read<SettingCubit>().setting?.email ??
                                      "info@HAWIA.com,sa",
                                  style: AppTextStyle.text18_700,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          AppLocaleKey.socialMedia.tr(),
                          style: AppTextStyle.text18_700,
                        ),
                      ),
                      Container(
                        height: 80,
                        margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100.withValues(alpha: .5),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            GestureDetector(
                              onTap: () => _launchURL(setting?.whatsApp ?? "", isWhatsapp: true),
                              child: Image.asset(AppImages.whatsapp, height: 40),
                            ),
                            GestureDetector(
                              onTap: () => _launchURL(setting?.facebook ?? ""),
                              child: Image.asset(AppImages.facebookIcon, height: 40),
                            ),
                            GestureDetector(
                              onTap: () => _launchURL(setting?.twitter ?? ""),
                              child: Image.asset(AppImages.twitter, height: 40),
                            ),
                            GestureDetector(
                              onTap: () => _launchURL(setting?.linkedIn ?? ""),
                              child: Image.asset(AppImages.linkedin, height: 40),
                            ),
                            GestureDetector(
                              onTap: () => _launchURL(setting?.instagram),
                              child: Image.asset(AppImages.instagram, height: 40),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      Center(
                        child: Text(
                          AppLocaleKey.communicateWith.tr(),
                          style: AppTextStyle.text16_700,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      Center(
                        child: Text(
                          AppLocaleKey.twentyFourHoursADay.tr(),
                          style: AppTextStyle.text16_700,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _launchURL(String? url, {bool isWhatsapp = false, bool isEmail = false}) async {
    if (url == null || url.isEmpty) return;

    Uri uri;

    if (isWhatsapp) {
      uri = Uri.parse("https://wa.me/${url.replaceAll('+', '').replaceAll(' ', '')}");
    } else if (isEmail) {
      uri = Uri.parse("mailto:$url");
    } else {
      uri = Uri.parse(url);
    }

    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw 'Could not launch $url';
    }
  }
}
