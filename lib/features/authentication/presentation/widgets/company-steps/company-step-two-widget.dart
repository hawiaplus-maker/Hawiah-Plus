import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hawiah_client/core/custom_widgets/custom-text-field-widget.dart';
import 'package:hawiah_client/core/theme/app_colors.dart';
class CompanyStepTwo extends StatelessWidget {
  final String commercialRegistrationNumber;
  final String taxNumber;
  final String municipalLicense;
  final String transportLicense;
  final ValueChanged<String> onCommercialRegistrationChanged;
  final ValueChanged<String> onTaxNumberChanged;
  final ValueChanged<String> onMunicipalLicenseChanged;
  final ValueChanged<String> onTransportLicenseChanged;

  const CompanyStepTwo({
    Key? key,
    required this.commercialRegistrationNumber,
    required this.taxNumber,
    required this.municipalLicense,
    required this.transportLicense,
    required this.onCommercialRegistrationChanged,
    required this.onTaxNumberChanged,
    required this.onMunicipalLicenseChanged,
    required this.onTransportLicenseChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomTextField(
          labelText: "commercial_registration_number".tr(),
          hintText: "commercial_registration_number".tr(),
          initialValue: commercialRegistrationNumber,
          keyboardType: TextInputType.number,
          onChanged: onCommercialRegistrationChanged,
        ),
        SizedBox(height: 8),
        AttachmentField(label: "commercial_registration_image".tr()),
        SizedBox(height: 10),
        CustomTextField(
          labelText: "tax_number".tr(),
          hintText: "tax_number".tr(),
          initialValue: taxNumber,
          keyboardType: TextInputType.number,
          onChanged: onTaxNumberChanged,
        ),
        SizedBox(height: 8),
        AttachmentField(label: "tax_number_image".tr()),
        SizedBox(height: 10),
        CustomTextField(
          labelText: "municipal_license".tr(),
          hintText: "municipal_license".tr(),
          initialValue: municipalLicense,
          keyboardType: TextInputType.number,
          onChanged: onMunicipalLicenseChanged,
        ),
        SizedBox(height: 8),
        AttachmentField(label: "municipal_license".tr()),
        SizedBox(height: 10),
        CustomTextField(
          labelText: "transport_license".tr(),
          hintText: "transport_license".tr(),
          initialValue: transportLicense,
          keyboardType: TextInputType.number,
          onChanged: onTransportLicenseChanged,
        ),
        SizedBox(height: 8),
        AttachmentField(label: "transport_license".tr()),
      ],
    );
  }
}

class AttachmentField extends StatelessWidget {
  final String label;

  const AttachmentField({Key? key, required this.label}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.grey[50],
      ),
      child: Row(
        children: [
          Image.asset(
            "assets/icons/attach_image.png",
            height: 30.h,
            width: 30.w,
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 10.w),
            height: 5,
            width: 5,
            decoration:
                BoxDecoration(shape: BoxShape.circle, color: Colors.grey),
          ),
          Text(
            label,
            style: TextStyle(color: Colors.grey, fontSize: 14),
          ),
          Spacer(),
          TextButton(
            onPressed: () {},
            child: Text(
              "attachment".tr(),
              style: TextStyle(
                  color: AppColor.mainAppColor,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
