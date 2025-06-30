
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hawiah_client/core/images/app_images.dart';
import 'package:hawiah_client/core/theme/app_colors.dart';
import 'package:hawiah_client/core/theme/app_text_style.dart';

class AppBottomSheet extends StatelessWidget {
  const AppBottomSheet(
      {super.key,
      required this.title,
      required this.children,
      this.isDark = false});
  final String title;
  final List<Widget> children;
  final bool? isDark;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      decoration: BoxDecoration(
        color: isDark == true
            ? AppColor.blackColor
            : AppColor.whiteColor,
        borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(36), topRight: Radius.circular(36)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Text(
                      title,
                      style: AppTextStyle.text16M_400.copyWith(
                        color: isDark == true
                            ? AppColor.whiteColor
                            : AppColor.blackColor,
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () => Navigator.pop,
                    child: Card(
                      elevation: 10,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      child: CircleAvatar(
                        radius: 20,
                        backgroundColor: isDark == true
                            ? AppColor.blackColor
                            : AppColor.whiteColor,
                        child: SvgPicture.asset(AppImages.closeIcon),
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              Divider(
                thickness: 0.7,
                color: AppColor.greyColor,
              ),
              const SizedBox(height: 15),
              ...children
            ],
          ),
        ),
      ),
    );
  }
}
