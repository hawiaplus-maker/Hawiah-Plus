import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hawiah_client/features/home/presentation/screens/home-details-order-screen.dart';

import '../controllers/home-cubit/home-cubit.dart';
import '../controllers/home-cubit/home-state.dart';

class HomeNewOrderScreen extends StatelessWidget {
  const HomeNewOrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("new_request".tr()),
          centerTitle: true,
        ),
        body: BlocConsumer<HomeCubit, HomeState>(
          builder: (BuildContext context, HomeState state) {
            final homeCubit = HomeCubit.get(context);
            final transportationCategoriesList =
                homeCubit.transportationCategoriesList;
            return Container(
              margin: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                children: [
                  TextFormField(
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      hintText: "search".tr(),
                      hintStyle: TextStyle(
                          color: Color(0xff979797),
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w400),
                      filled: true, // Set background color
                      fillColor:
                          Color(0xFFF9F9F9), // Set background color to #F9F9F9
                      border: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(40.0), // Apply border radius
                        borderSide: BorderSide
                            .none, // Remove border side for regular border
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(40.0), // Apply border radius
                        borderSide: BorderSide
                            .none, // Remove border side for enabled state
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(40.0), // Apply border radius
                        borderSide: BorderSide
                            .none, // Remove border side for focused state
                      ),
                      suffixIcon: Icon(
                        Icons.search,
                        color:
                            Color(0xFF2D01FE), // Change icon color to #2D01FE
                        size: 25,
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 10.h),
                    height: 0.15.sh,
                    child: ListView.builder(
                      itemBuilder: (context, index) {
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Image.asset(
                              transportationCategoriesList[index].logo,
                              height: 70.h,
                              width: 70.w,
                              fit: BoxFit.fill,
                            ),
                            SizedBox(height: 5.h),
                            Text(
                              transportationCategoriesList[index].title,
                              style: TextStyle(
                                  fontSize: 13.sp, color: Color(0xff3A3A3A)),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        );
                      },
                      itemCount: transportationCategoriesList.length,
                      scrollDirection: Axis.horizontal,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
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
                          value: homeCubit.selectedCategory ??
                              homeCubit.categories[0],
                          icon: Container(
                              padding: EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color(0xffEDEEFF),
                              ),
                              child: Icon(Icons.arrow_drop_down)),
                          onChanged: (String? newValue) {
                            homeCubit.changeCategory(newValue);
                          },
                          items: homeCubit.categories
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value.tr()),
                            );
                          }).toList(),
                        ),
                      ),
                      Text("${"result".tr()} 120",
                          style: TextStyle(fontSize: 13.sp))
                    ],
                  ),
                  SizedBox(height: 10.h),
                  Expanded(
                    child: ListView.builder(
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        HomeDetailsOrderScreen()));
                          },
                          child: Container(
                            margin: EdgeInsets.symmetric(vertical: 10.h),
                            padding: EdgeInsets.symmetric(
                                horizontal: 10.w, vertical: 10.h),
                            decoration: BoxDecoration(
                              color: Color(0xFFFCFCFC),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Image.asset(
                                      homeCubit.carList[index].logo,
                                      height: 70.h,
                                      width: 70.w,
                                      fit: BoxFit.fill,
                                    ),
                                    SizedBox(width: 10.w),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment
                                          .start, // Align children to the start (left)
                                      children: [
                                        // حاوية مباني with size options
                                        Text(
                                          homeCubit.carList[index].title,
                                          style: TextStyle(
                                            fontSize:
                                                15.sp, // Adjust the font size
                                            fontWeight: FontWeight
                                                .bold, // Bold the title
                                            color: Colors.black, // Text color
                                          ),
                                        ),
                                        SizedBox(
                                            height:
                                                5), // Space between the title and the options
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment
                                              .start, // Align items to the start (left)
                                          children: homeCubit
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
                                                text: homeCubit.carList[index]
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
                                        text: homeCubit
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
                      itemCount: homeCubit.carList.length,
                    ),
                  )
                ],
              ),
            );
          },
          listener: (BuildContext context, HomeState state) {},
        ));
  }
}
