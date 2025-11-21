import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hawiah_client/core/custom_widgets/custom-text-field-widget.dart';
import 'package:hawiah_client/core/custom_widgets/custom_button.dart';
import 'package:hawiah_client/core/images/app_images.dart';
import 'package:hawiah_client/core/locale/app_locale_key.dart';
import 'package:hawiah_client/core/theme/app_colors.dart';
import 'package:hawiah_client/core/theme/app_text_style.dart';
import 'package:hawiah_client/core/utils/validation_methods.dart';
import 'package:hawiah_client/features/order/presentation/order-cubit/order-cubit.dart';

class CouponeWidget extends StatefulWidget {
  const CouponeWidget({
    super.key,
  });

  @override
  State<CouponeWidget> createState() => _CouponeWidgetState();
}

class _CouponeWidgetState extends State<CouponeWidget> {
  final controller = TextEditingController();
  final _formkey = GlobalKey<FormState>();
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColor.lightGreyColor),
      ),
      child: Form(
        key: _formkey,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              flex: 2,
              child: CustomTextField(
                controller: controller,
                title: AppLocaleKey.discountCoupon.tr(),
                hintText: AppLocaleKey.enterDiscountCoupon.tr(),
                validator: ValidationMethods.validateEmptyField,
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              flex: 1,
              child: CustomButton(
                height: 45,
                radius: 5,
                prefixIcon: Image.asset(AppImages.copunImage, height: 20, width: 20),
                color: AppColor.secondAppColor,
                text: AppLocaleKey.apply.tr(),
                style: AppTextStyle.text14_600.copyWith(color: AppColor.whiteColor, height: -0.5),
                onPressed: () {
                  if (_formkey.currentState!.validate()) {
                    context.read<OrderCubit>().applyCoupon(
                          code: controller.text,
                          onSuccess: () {},
                        );
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
