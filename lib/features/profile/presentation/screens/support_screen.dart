import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hawiah_client/core/images/app_images.dart';
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
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'الدعم ',
          style: AppTextStyle.text20_700,
        ),
        centerTitle: true,
      ),
      body: Container(
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
                'يمكنك الان التواصل معنا من خلال',
                style: AppTextStyle.text16_700,
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'البريد الالكتروني',
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
                          margin: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 16),
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
                        'وسائل التواصل الاجتماعي',
                        style: AppTextStyle.text18_700,
                      ),
                    ),
                    Container(
                      height: 80,
                      margin: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 16),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100.withValues(alpha: .5),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          GestureDetector(
                            onTap: () => _launchURL(setting?.whatsApp ?? "",
                                isWhatsapp: true),
                            child: Image.asset(AppImages.whatsapp, height: 40),
                          ),
                          GestureDetector(
                            onTap: () => _launchURL(setting?.facebook ?? ""),
                            child:
                                Image.asset(AppImages.facebookIcon, height: 40),
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
                        ' سعداء لتواصل معكم والرد علي جميع \n رسائكم',
                        style: AppTextStyle.text16_700,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Center(
                      child: Text(
                        'يوميا علي مدار الل 24 ساعة',
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
    );
  }

  Future<void> _launchURL(String? url,
      {bool isWhatsapp = false, bool isEmail = false}) async {
    if (url == null || url.isEmpty) return;

    Uri uri;

    if (isWhatsapp) {
      uri = Uri.parse(
          "https://wa.me/${url.replaceAll('+', '').replaceAll(' ', '')}");
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
