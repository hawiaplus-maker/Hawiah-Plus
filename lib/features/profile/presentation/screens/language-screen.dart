import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LanguageScreen extends StatelessWidget {
  const LanguageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'لغة التطبيق',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          languageItem(
            title: 'العربية',
            logo: 'assets/icons/flag_saudi_arabia_icon.png',
            onTap: () {},
          ),
          languageItem(
              title: 'English',
              logo: 'assets/icons/flag_united_kingdom_icon.png',
              onTap: () {},
              isHaveLine: false),
        ],
      ),
    );
  }

  Widget languageItem(
      {required String title,
      required String logo,
      bool isHaveLine = true,
      required VoidCallback onTap,
      Color color = Colors.black}) {
    return GestureDetector(
        onTap: onTap,
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
              child: Row(children: [
                Image.asset(
                  logo,
                  height: 40.h,
                  width: 40.w,
                ),
                SizedBox(
                  width: 10.w,
                ),
                Text(
                  title,
                  style: TextStyle(fontSize: 14.sp, color: color),
                ),
                Spacer(),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 20.sp,
                  color: Color(0xffA6A6A6),
                )
              ]),
            ),
            isHaveLine == true
                ? Divider(
                    color: Colors.grey,
                    thickness: 0.5,
                  )
                : SizedBox.shrink()
          ],
        ));
  }
}
