import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hawiah_client/core/custom_widgets/global-elevated-button-widget.dart';
import 'package:hawiah_client/features/explore/presentation/screens/sub-category-explore-screen.dart';
import 'package:hawiah_client/features/location/presentation/screens/choose-location-screen.dart';

import '../controllers/explore-flow-cubit.dart';
import '../controllers/explore-flow-state.dart';

class ExploreScreen extends StatelessWidget {
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
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Vehicle options
                      Container(
                        height: 0.15.sh,
                        child: ListView.builder(
                          //shrinkWrap: true,
                          itemCount: exploreFlowCubit.categories.length,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            final category = exploreFlowCubit.categories[index];
                            return GestureDetector(
                              onTap: () {
                                exploreFlowCubit.changeCategory(category.title);
                              },
                              child: Container(
                                width: 0.28.sw,
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 8),
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color:
                                          exploreFlowCubit.selectedCategory ==
                                                  category.title
                                              ? Color(0xff5FFF9F)
                                              : Color(0xffEDEDED)),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Center(
                                      child: Image.asset(
                                        category.logo,
                                        height: 60.h,
                                        width: 60.w,
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                    SizedBox(height: 5.h),
                                    Text(
                                      category.title,
                                      style: TextStyle(
                                          fontSize: 13.sp,
                                          color: Color(0xff3A3A3A)),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),

                      // Address input
                      Row(
                        children: [
                          Image.asset(
                            "assets/icons/location_map_icon.png",
                            height: 20,
                            width: 20,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 10), // Adjust padding as needed
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color: Colors.grey, // Underline color
                                    width: 1.0, // Underline thickness
                                  ),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      "شارع الملك عمر بن عبد العزيز RUGA 1523",
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ChooseLocationScreen()));
                                    },
                                    child: Text("تغيير",
                                        style: TextStyle(color: Colors.blue)),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        alignment: Alignment.centerRight,
                        height: 40,
                        child: VerticalDivider(
                          thickness: 2,
                          width: 20,
                          color: Colors.grey,
                        ),
                      ),
                      Row(
                        children: [
                          Image.asset(
                            "assets/icons/arrow_away_icon.png",
                            height: 20,
                            width: 20,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 10), // Adjust padding as needed
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color: Colors.grey, // Underline color
                                    width: 1.0, // Underline thickness
                                  ),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      "المدينة المنورة, السعودية",
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () {},
                                    child: Text("إختيار",
                                        style: TextStyle(color: Colors.blue)),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      // Next button
                      Spacer(),
                      Container(
                        alignment: Alignment.bottomCenter,
                        child: GlobalElevatedButton(
                          label: "next".tr(),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    SubCategoryExploreScreen(),
                              ),
                            );
                          },
                          backgroundColor: Color(0xff2D01FE),
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
