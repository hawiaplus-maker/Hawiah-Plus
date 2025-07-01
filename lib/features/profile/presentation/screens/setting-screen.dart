import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hawiah_client/core/theme/cubit/app_theme_cubit.dart';
import 'package:hawiah_client/core/theme/theme_enum.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool notificationsEnabled = true;

  @override
  Widget build(BuildContext context) {
    final appThemeCubit = context.watch<AppThemeCubit>();
    final isLightMode = appThemeCubit.theme == ThemeEnum.light;

    return Scaffold(
      appBar: AppBar(
        title: Text('الإعدادات'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Image.asset(
                "assets/icons/notfication_2_icon.png",
                height: 25.h,
                width: 25.w,
                fit: BoxFit.fill,
              ),
              title: Text(
                'التنبيهات',
                style: TextStyle(fontSize: 18),
              ),
              trailing: Switch(
                activeColor: Colors.white,
                inactiveThumbColor: Colors.red,
                activeTrackColor: Color(0xff32D74B),
                inactiveTrackColor: Color(0xffF5F6FF),
                value: notificationsEnabled,
                onChanged: (value) {
                  setState(() {
                    notificationsEnabled = value;
                  });
                },
              ),
            ),
            Divider(),
            ListTile(
              onTap: () {
                appThemeCubit.theme = isLightMode
                    ? ThemeEnum.dark
                    : ThemeEnum.light; 
              },
              contentPadding: EdgeInsets.zero,
              leading: Image.asset(
                "assets/icons/light_mode_icon.png",
                height: 25.h,
                width: 25.w,
                fit: BoxFit.fill,
              ),
              title: Text(
                isLightMode ? 'الوضع النهاري' : 'الوضع الليلي',
                style: TextStyle(fontSize: 18),
              ),
              trailing: SizedBox(
                width: 100,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      'الليلي',
                      style: TextStyle(fontSize: 14),
                    ),
                    SizedBox(width: 8),
                    Icon(Icons.arrow_forward_ios_rounded),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
