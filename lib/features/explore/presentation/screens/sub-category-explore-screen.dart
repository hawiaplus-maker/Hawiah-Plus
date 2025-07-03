import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hawiah_client/core/custom_widgets/global-elevated-button-widget.dart';
import 'package:hawiah_client/features/home/presentation/screens/home-details-order-screen.dart';
import 'package:hawiah_client/core/theme/app_colors.dart';
import '../controllers/explore-flow-cubit.dart';
import '../controllers/explore-flow-state.dart';

class SubCategoryExploreScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<ExploreFlowCubit, ExploreFlowState>(
        listener: (BuildContext context, state) {},
        builder: (BuildContext context, Object? state) {
          final exploreFlowCubit = ExploreFlowCubit.get(context);
          return Stack(
            children: [
              // Map background (you can use Google Maps or a placeholder)
              Positioned.fill(
                child: Image.asset(
                  "assets/images/map_design.png",
                  fit: BoxFit.fill,
                ),
              ),
              Align(
                alignment: Alignment.topCenter,
                child: AppBar(
                  backgroundColor: Colors.transparent,
                  actions: [
                    IconButton(
                      icon: Container(
                        margin: EdgeInsets.symmetric(horizontal: 10),
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.black,
                          size: 16,
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    )
                  ],
                ),
              ),

              // Bottom Sheet
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: 0.5.sh,
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(20)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Vehicle options
                      Container(
                        width: 0.40.sw,
                        padding: EdgeInsets.symmetric(horizontal: 10.w),
                        decoration: BoxDecoration(
                          color: Color(
                              0xFFF9F9F9), // Set background color to #F9F9F9
                          borderRadius: BorderRadius.circular(
                              40.0), // Optional: Add rounded corners
                        ),
                        child: DropdownButton<String>(
                          isExpanded: true,
                          underline: SizedBox.shrink(),
                          value: exploreFlowCubit.selectedCategoryExplore ??
                              exploreFlowCubit.categoriesExplore[0],
                          icon: Container(
                              padding: EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color(0xffEDEEFF),
                              ),
                              child: Icon(Icons.arrow_drop_down)),
                          onChanged: (String? newValue) {
                            exploreFlowCubit.changeCategoryExplore(newValue);
                          },
                          items: exploreFlowCubit.categoriesExplore
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value.tr()),
                            );
                          }).toList(),
                        ),
                      ),

                      // Address input
                      Expanded(
                        child: ListView.builder(
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                exploreFlowCubit.changeCar(
                                    exploreFlowCubit.carList[index].title);
                              },
                              child: Container(
                                margin: EdgeInsets.symmetric(vertical: 10.h),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10.w, vertical: 10.h),
                                decoration: BoxDecoration(
                                    color: Color(0xFFFCFCFC),
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                      color: exploreFlowCubit.selectedCar ==
                                              exploreFlowCubit
                                                  .carList[index].title
                                          ? Color(0xff5FFF9F)
                                          : Colors.transparent,
                                    )),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Image.asset(
                                          exploreFlowCubit.carList[index].logo,
                                          height: 70.h,
                                          width: 70.w,
                                          fit: BoxFit.fill,
                                        ),
                                        SizedBox(width: 10.w),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment
                                              .start, // Align children to the start (left)
                                          children: [
                                            Text(
                                              exploreFlowCubit
                                                  .carList[index].title,
                                              style: TextStyle(
                                                fontSize: 15
                                                    .sp, // Adjust the font size
                                                fontWeight: FontWeight
                                                    .bold, // Bold the title
                                                color:
                                                    Colors.black, // Text color
                                              ),
                                            ),
                                            SizedBox(
                                                height:
                                                    5), // Space between the title and the options
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment
                                                  .start, // Align items to the start (left)
                                              children: exploreFlowCubit
                                                  .carList[index].sizes
                                                  .map((buildSize) {
                                                return Container(
                                                  margin: EdgeInsets.symmetric(
                                                      horizontal: 2.h),
                                                  child: Text(
                                                    buildSize.tr(),
                                                    style: TextStyle(
                                                        fontSize: 12,
                                                        color: Colors.black),
                                                  ),
                                                );
                                              }).toList(),
                                            ),
                                            SizedBox(
                                                height:
                                                    10), // Space between the options and the next line
                                            // على بعُد 2.5 كم
                                            RichText(
                                              text: TextSpan(
                                                children: [
                                                  TextSpan(
                                                    text: "distance".tr(),
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      color: Colors
                                                          .black, // Regular text color
                                                    ),
                                                  ),
                                                  TextSpan(
                                                    text: exploreFlowCubit
                                                        .carList[index]
                                                        .distanceFromLocation
                                                        .toString(),
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      fontWeight: FontWeight
                                                          .bold, // Make "2.5" bold
                                                      color: Colors
                                                          .blue, // Set color to blue for the number
                                                    ),
                                                  ),
                                                  TextSpan(
                                                    text: "distance_unit".tr(),
                                                    style: TextStyle(
                                                      fontSize: 10,
                                                      color: Colors
                                                          .black, // Regular text color
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment
                                          .start, // Centers the content vertically
                                      crossAxisAlignment: CrossAxisAlignment
                                          .start, // Centers the content horizontally
                                      children: [
                                        Text(
                                          "price_start_from".tr(),
                                          style: TextStyle(
                                            fontSize:
                                                10, // Adjust the font size as needed
                                            fontWeight: FontWeight
                                                .bold, // Bold the text if needed
                                            color: Colors
                                                .black, // Adjust the color if needed
                                          ),
                                        ),
                                        SizedBox(height: 5),
                                        RichText(
                                            text: TextSpan(children: [
                                          TextSpan(
                                            text: "per_day".tr(),
                                            style: TextStyle(
                                              fontSize: 10,
                                              color: Colors
                                                  .black, // Regular text color
                                            ),
                                          ),
                                          TextSpan(text: " "),
                                          TextSpan(
                                            text: exploreFlowCubit
                                                .carList[index].pricePerDay
                                                .toString(),
                                            style: TextStyle(
                                                fontSize: 10,
                                                color: Colors.black,
                                                fontWeight: FontWeight
                                                    .bold // Regular text color
                                                ),
                                          ),
                                        ])),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            );
                          },
                          itemCount: exploreFlowCubit.carList.length,
                        ),
                      ),
                      SizedBox(height: 16),
                      // Next button
                      Container(
                        alignment: Alignment.bottomCenter,
                        child: GlobalElevatedButton(
                          label: "next".tr(),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        HomeDetailsOrderScreen()));
                          },
                          backgroundColor: AppColor.mainAppColor,
                          textColor: Colors.white,
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 12),
                          borderRadius: BorderRadius.circular(10),
                          fixedWidth: 0.80, // 80% of the screen width
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
