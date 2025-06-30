import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hawiah_client/core/custom_widgets/global-elevated-button-widget.dart';
import 'package:hawiah_client/features/home/presentation/widgets/location-item-widget.dart';
import 'package:hawiah_client/features/location/presentation/screens/add-new-location-screen.dart';
import 'package:hawiah_client/features/location/presentation/screens/location-map-screen.dart';

class ChooseLocationScreen extends StatelessWidget {
  const ChooseLocationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("choose_address".tr()),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                LocationItemWidget(
                  imagePath: 'assets/images/my_location_image.png',
                  title: "موقعي الحالي",
                  address: "شارع الملك عمر بن عبد العزيز, RUQA 1523",
                  isSelected: true,
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => LocationScreen()));
                  },
                ),
                LocationItemWidget(
                  imagePath: 'assets/images/my_location_image.png',
                  title: "add_new_address".tr(),
                  address: "",
                  isSelected: false,
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddNewLocationScreen(),
                      )),
                ),
                // Add more LocationItem widgets as needed
              ],
            ),
          ),
          // Container for the button
          Container(
            margin: EdgeInsets.symmetric(vertical: 20.h, horizontal: 20.w),
            alignment: Alignment.topCenter,
            child: GlobalElevatedButton(
              label: "confirm_address".tr(),
              onPressed: () {
                Navigator.pop(context);
              },
              backgroundColor: Color(0xff2D01FE),
              textColor: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              borderRadius: BorderRadius.circular(10),
              fixedWidth: 0.80.sw, // 80% of the screen width
            ),
          ),
        ],
      ),
    );
  }
}
