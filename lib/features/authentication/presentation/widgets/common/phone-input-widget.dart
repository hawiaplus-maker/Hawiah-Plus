import 'package:country_picker/country_picker.dart';
import 'package:easy_localization/easy_localization.dart' as es;
import 'package:flutter/material.dart';
import 'package:hawiah_client/core/custom_widgets/custom-text-field-widget.dart';
import 'package:hawiah_client/core/locale/app_locale_key.dart';
import 'package:hawiah_client/core/utils/country_code_methods.dart';
import 'package:hawiah_client/core/utils/validation_methods.dart';
import 'package:hawiah_client/features/authentication/presentation/controllers/auth-cubit/auth-cubit.dart';

class PhoneInputWidget extends StatelessWidget {
  const PhoneInputWidget({super.key, this.controller,  this.isReadOnly=false});
  final TextEditingController? controller;
  final bool isReadOnly;
  @override
  Widget build(BuildContext context) {
    Country _country = CountryCodeMethods.getByCode('966');

    final authCubit = AuthCubit.get(context);

    return CustomTextField(
      validator: (v) => ValidationMethods.validatePhone(v, country: _country),
      controller: controller,
      title: AppLocaleKey.phoneNumber.tr(),
      keyboardType: TextInputType.phone,
      hintText: AppLocaleKey.phoneHint.tr(),
      readOnly: isReadOnly,
      onChanged: (value) {
        authCubit.phoneController.text = value;
      },
    );
  }
}
