import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PersonProfileTap extends StatelessWidget {
  final String title;
  final String logo;
  final VoidCallback onTap;
  final bool isLastItem;
  final Color color;

  const PersonProfileTap({
    Key? key,
    required this.title,
    required this.logo,
    required this.onTap,
    this.isLastItem = false,
    this.color = Colors.black,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Column(
            children: [
              Image.asset(logo, height: 40.h, width: 35.w),
              SizedBox(height: 5.h),
              Text(
                title,
                style: TextStyle(fontSize: 13.sp, color: color),
              ),
            ],
          ),
          if (!isLastItem)
            Container(
              margin: EdgeInsets.symmetric(horizontal: 10.w),
              height: 50,
              child: VerticalDivider(
                thickness: 0.5,
                width: 20,
                color: Colors.grey,
              ),
            ),
        ],
      ),
    );
  }
}
