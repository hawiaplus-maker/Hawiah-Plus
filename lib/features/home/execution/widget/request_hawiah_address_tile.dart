import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hawiah_client/core/images/app_images.dart';
import 'package:hawiah_client/features/home/execution/widget/request_hawiah_info_container.dart';
import 'package:hawiah_client/features/location/presentation/model/address_model.dart';

class RequestHawiahAddressTile extends StatelessWidget {
  final AddressModel address;
  const RequestHawiahAddressTile({super.key, required this.address});

  @override
  Widget build(BuildContext context) {
    return RequestHawiahInfoContainer(
      icon: AppImages.locationIcon,
      child: Text(
        "${address.title ?? ""} - ${address.city ?? ""} - ${address.neighborhood ?? ""}",
        style: TextStyle(fontSize: 14.sp),
      ),
    );
  }
}
