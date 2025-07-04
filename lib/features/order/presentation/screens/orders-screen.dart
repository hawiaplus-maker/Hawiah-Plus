import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hawiah_client/core/theme/app_colors.dart';
import 'package:hawiah_client/core/theme/app_text_style.dart';
import 'package:hawiah_client/features/order/presentation/screens/current-order-screen.dart';
import 'package:hawiah_client/features/order/presentation/screens/old-order-screen.dart';

import '../controllers/order-cubit/order-cubit.dart';
import '../controllers/order-cubit/order-state.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  @override
  int? orderStatus;
  void initState() {
    OrderCubit.get(context).getOrders(orderStatus ?? 1);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("الطلبات".tr(), style: AppTextStyle.text20_700),
        centerTitle: true,
      ),
      body: BlocConsumer<OrderCubit, OrderState>(
        builder: (BuildContext context, OrderState state) {
          final orderCubit = OrderCubit.get(context);
          bool isActive = orderCubit.isOrderCurrent;
          orderStatus = isActive ? 1 : 0;
          return Column(
            children: [
              Center(
                child: GestureDetector(
                  onTap: () {
                    orderCubit.changeOrderCurrent();
                    orderStatus = orderCubit.isOrderCurrent ? 1 : 0;
                    orderCubit.getOrders(orderStatus!);
                  },
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 100),
                    width: 0.9.sw,
                    height: 50.h,
                    decoration: BoxDecoration(
                      color: AppColor.selectedLightBlueColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Stack(
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20.w),
                            child: Text(
                              "انتهت",
                              style: TextStyle(
                                color: isActive ? Colors.grey : Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        // "حالية" Text
                        Align(
                          alignment: Alignment.centerRight,
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20.w),
                            child: Text(
                              "حالية",
                              style: TextStyle(
                                color: isActive ? Colors.white : Colors.grey,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        // Toggle Button
                        AnimatedAlign(
                          duration: Duration(milliseconds: 300),
                          alignment: isActive
                              ? Alignment.centerRight
                              : Alignment.centerLeft,
                          child: Container(
                            width: 0.40.sw,
                            height: 60,
                            decoration: BoxDecoration(
                              color: isActive
                                  ? AppColor.mainAppColor
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Center(
                              child: Text(
                                isActive ? "حالية" : "انتهت",
                                style: TextStyle(
                                  color: isActive ? Colors.white : Colors.black,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: orderCubit.orders?.data?.length,
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      onTap: () {
                        if (isActive) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => CurrentOrderScreen()));
                        } else {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => OldOrderScreen()));
                        }
                      },
                      child: Center(
                        child: Container(
                          padding: EdgeInsets.all(20),
                          margin: EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Left Section: "تفاصيل الطلب" with arrow

                              // Right Section: Order Details
                              Row(
                                children: [
                                  // Vehicle Image
                                  Image.asset(
                                    'assets/images/car_image.png', // Replace with your image path
                                    width: 60,
                                    height: 60,
                                  ),
                                  SizedBox(width: 10),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "حاوية طبية",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        "صغيرة",
                                        style: TextStyle(
                                          color: Colors.black54,
                                          fontSize: 14,
                                        ),
                                      ),
                                      Text(
                                        "12 نوفمبر, 2024",
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 13,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Text(
                                    "تفاصيل الطلب",
                                    style: TextStyle(
                                      color: AppColor.mainAppColor,
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(width: 5),
                                  Icon(Icons.arrow_forward_ios,
                                      color: AppColor.mainAppColor, size: 20),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
        listener: (BuildContext context, OrderState state) {},
      ),
    );
  }
}
