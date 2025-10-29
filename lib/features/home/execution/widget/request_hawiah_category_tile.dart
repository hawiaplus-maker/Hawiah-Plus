import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hawiah_client/features/home/execution/widget/request_hawiah_info_container.dart';

class RequestHawiahCategoryTile extends StatelessWidget {
  final String icon;
  final String title;
  const RequestHawiahCategoryTile({super.key, required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    return RequestHawiahInfoContainer(
      icon: icon,
      child: Text(
        title,
        style: TextStyle(
          fontSize: 16.sp,
          fontWeight: FontWeight.w500,
          color: Colors.black,
        ),
      ),
    );
  }
}
