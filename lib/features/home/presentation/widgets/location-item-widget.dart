import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart'; // If you're using ScreenUtil

class LocationItemWidget extends StatelessWidget {
  final String imagePath;
  final String title;
  final String address;
  final bool isSelected;
  final void Function()? onTap;
  const LocationItemWidget({
    Key? key,
    required this.imagePath,
    required this.title,
    required this.address,
    this.onTap,
    this.isSelected = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.all(16),
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Color(0xffFAFBFF),
          border: Border.all(
              color: isSelected ? Color(0xff5FFF9F) : Color(0xffFAFBFF)),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              imagePath, // Path to the image asset
              height: 70.h, // You can adjust the size with ScreenUtil
              width: 70.w, // You can adjust the size with ScreenUtil
            ),
            Container(
              width: 0.5.sw, // This takes half the screen width
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    address,
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
            Spacer(),
            isSelected
                ? Icon(
                    Icons.check_circle,
                    color: Color(0xff5FFF9F),
                  )
                : SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}
