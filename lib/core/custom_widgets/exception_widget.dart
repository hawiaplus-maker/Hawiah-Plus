import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hawiah_client/core/custom_widgets/custom_button.dart';
import 'package:hawiah_client/core/extension/context_extension.dart';
import 'package:hawiah_client/core/images/app_images.dart';
import 'package:hawiah_client/core/theme/app_colors.dart';
import 'package:hawiah_client/core/theme/app_theme.dart';



class ExceptionWidget extends StatelessWidget {
  final Axis axis;
  final String? message;
  final void Function()? onReload;
  const ExceptionWidget({
    super.key,
    this.axis = Axis.vertical,
    this.message,
    this.onReload,
  });

  @override
  Widget build(BuildContext context) {
    switch (axis) {
      case Axis.horizontal:
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          decoration: BoxDecoration(
            color: AppColor.mainAppColor.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(7),
          ),
          child: IntrinsicHeight(
            child: Row(
              children: [
                SvgPicture.asset(
                  AppImages.exceptionImage,
                  colorFilter: ColorFilter.mode(
                    AppTheme.getByTheme(
                      light: Colors.black,
                      dark: Colors.white,
                    ),
                    BlendMode.srcIn,
                  ),
                  width: 40,
                  height: 40,
                  fit: BoxFit.contain,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    message ??
                        context.apiTr(ar: "حدث خطأ", en: "An error occurred"),
                    style: TextStyle(
                      color: AppTheme.getByTheme(
                        light: Colors.black,
                        dark: Colors.white,
                      ),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.justify,
                  ),
                ),
                const SizedBox(width: 10),
                IconButton(
                  onPressed: onReload,
                  icon: SvgPicture.asset(
                    AppImages.refreshIcon,
                    colorFilter: ColorFilter.mode(
                      AppTheme.getByTheme(
                        light: Colors.black,
                        dark: Colors.white,
                      ),
                      BlendMode.srcIn,
                    ),
                    width: 25,
                    height: 25,
                    fit: BoxFit.contain,
                  ),
                ),
              ],
            ),
          ),
        );

      case Axis.vertical:
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
          decoration: BoxDecoration(
            color: AppColor.mainAppColor.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(7),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SvgPicture.asset(
                AppImages.errorIcon,
                colorFilter: ColorFilter.mode(
                  AppTheme.getByTheme(light: Colors.black, dark: Colors.white),
                  BlendMode.srcIn,
                ),
                width: 80,
                height: 80,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 10),
              Text(
                message ??
                    context.apiTr(ar: "حدث خطأ", en: "An error occurred"),
                style: TextStyle(
                  color: AppTheme.getByTheme(
                    light: Colors.black,
                    dark: Colors.white,
                  ),
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              CustomButton(
                text: context.apiTr(ar: "إعادة تحميل", en: "Reload"),
                width: MediaQuery.of(context).size.width * 0.5,
                prefixIcon: SvgPicture.asset(
                  AppImages.refreshIcon,
                  colorFilter: ColorFilter.mode(
                    AppColor.buttonTextColor,
                    BlendMode.srcIn,
                  ),
                  width: 20,
                  height: 20,
                  fit: BoxFit.contain,
                ),
                height: 40,
                onPressed: onReload,
              ),
            ],
          ),
        );
    }
  }
}
