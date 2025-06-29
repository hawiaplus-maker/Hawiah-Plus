import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool notificationsEnabled = true;
  bool isDayMode = true;

  @override
  Widget build(BuildContext context) {
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
                leading: Image.asset("assets/icons/notfication_2_icon.png",
                    height: 25.h, width: 25.w, fit: BoxFit.fill),
                title: Text(
                  'التنبيهات',
                  style: TextStyle(fontSize: 18),
                ),
                trailing: Switch(
                  activeColor: Colors.white, // Red when active
                  inactiveThumbColor: Colors.red, // Blue when inactive
                  activeTrackColor:
                      Color(0xff32D74B), // Green track when active
                  inactiveTrackColor:
                      Color(0xffF5F6FF), // Orange track when inactive

                  value: notificationsEnabled,
                  onChanged: (value) {
                    setState(() {
                      notificationsEnabled = value;
                    });
                  },
                )),
            Divider(),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Image.asset("assets/icons/light_mode_icon.png",
                  height: 25.h, width: 25.w, fit: BoxFit.fill),
              title: Text(
                isDayMode ? 'الوضع النهاري' : 'الوضع الليلي',
                style: TextStyle(fontSize: 18),
              ),
              trailing: SizedBox(
                width: 100, // Adjust the width as needed
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      'الليلي',
                      style: TextStyle(fontSize: 14),
                    ),
                    SizedBox(width: 8), // Add spacing between text and icon
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
