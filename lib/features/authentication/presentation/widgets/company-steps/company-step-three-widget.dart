import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CompanyStepThree extends StatelessWidget {
  const CompanyStepThree({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
         Image.asset(
                "assets/images/complete_company_profile_image.PNG",
                height: 0.40.sh,
                width: 0.70.sw,
              ),
        Container(
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
              Text(
                "contract_title".tr(),
                style: TextStyle(color: Colors.grey, fontSize: 14),
              ),
              Text(
                "الأوائل",
                style: TextStyle(color: Colors.grey, fontSize: 14),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 10.w),
                height: 5,
                width: 5,
                decoration: BoxDecoration(
                    shape: BoxShape.circle, color: Colors.grey),
              ),
              Text(
                "contract_download".tr(),
                style: TextStyle(color: Color(0xff2D01FE), fontSize: 14),
              ),
              Spacer(),
              TextButton(
                onPressed: () {},
                child: Text(
                  "attachment".tr(),
                  style: TextStyle(
                      color: Color(0xff2D01FE),
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 20.h),
        Container(
          width: 0.75.sw,
          child: Text(
            "service_description".tr(),
            textAlign: TextAlign.center,
            style: TextStyle(color: Color(0xffB8B8B8), fontSize: 15.sp),
          ),
        ),
       
      ],
    );
  }
}
