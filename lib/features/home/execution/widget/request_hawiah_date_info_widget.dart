import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hawiah_client/features/home/execution/widget/request_hawiah_info_container.dart';

class RequestHawiahDateTile extends StatelessWidget {
  final String icon;
  final String text;
  const RequestHawiahDateTile({super.key, required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return RequestHawiahInfoContainer(
      icon: icon,
      child: Text(
        text,
        style: TextStyle(fontSize: 14.sp),
      ),
    );
  }
}
