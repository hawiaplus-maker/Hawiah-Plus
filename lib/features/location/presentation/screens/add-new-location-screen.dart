import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hawiah_client/core/custom_widgets/api_response_widget.dart';
import 'package:hawiah_client/core/custom_widgets/custom-text-field-widget.dart';
import 'package:hawiah_client/core/custom_widgets/custom_select/custom_select_item.dart';
import 'package:hawiah_client/core/custom_widgets/custom_select/custom_single_select.dart';
import 'package:hawiah_client/core/custom_widgets/global-elevated-button-widget.dart';
import 'package:hawiah_client/core/theme/app_colors.dart';
import 'package:hawiah_client/core/utils/navigator_methods.dart';
import 'package:hawiah_client/features/location/presentation/cubit/address_cubit.dart';
import 'package:hawiah_client/features/location/presentation/cubit/address_state.dart';
import 'package:hawiah_client/features/location/presentation/screens/map_screen.dart';

class AddNewLocationScreen extends StatefulWidget {
  const AddNewLocationScreen({super.key});

  @override
  State<AddNewLocationScreen> createState() => _AddNewLocationScreenState();
}

class _AddNewLocationScreenState extends State<AddNewLocationScreen> {
  int? selectedCity;
  int? selectedNeighborhood;
  double? latitude;
  double? longitude;
  String? address;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => AddressCubit()..getcitys(),
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              "إضافة عنوان جديد",
              style: TextStyle(color: Colors.black),
            ),
            centerTitle: true,
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "العنوان الحالي",
                    style: TextStyle(color: Colors.black, fontSize: 15.sp),
                  ),
                  SizedBox(height: 10.h),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    decoration: BoxDecoration(
                      color: Color(0xffF9F9F9),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Color(0xffF9F9F9)),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          "assets/icons/location_map_icon.png",
                          height: 20,
                          width: 20,
                        ),
                        SizedBox(width: 10.w),
                        Expanded(
                          child: Text(
                            "شارع الملك عمر بن عبد العزيز, RUQA 1523",
                            style:
                                TextStyle(color: Colors.black, fontSize: 15.sp),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10.h),
                  CustomTextField(
                    labelText: "العنوان",
                    hintText: "العنوان",
                    initialValue: "",
                    onChanged: (value) => {},
                  ),
                  SizedBox(height: 20.h),
                  BlocConsumer<AddressCubit, AddressState>(
                      listener: (context, state) {
                    if (state is AddressError) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(state.message)),
                      );
                    }
                  }, builder: (context, state) {
                    final address = BlocProvider.of<AddressCubit>(context);
                    return ApiResponseWidget(
                      loadingWidget: SizedBox(),
                      apiResponse: address.citysResponse,
                      onReload: () => address.getcitys(),
                      isEmpty: address.citys.isEmpty,
                      child: Column(
                        children: [
                          CustomSingleSelect(
                            hintText: "city",
                            value: selectedCity,
                            items: address.citys
                                .map((e) => CustomSelectItem(
                                      name: e.title ?? "",
                                      value: e.id,
                                    ))
                                .toList(),
                            onChanged: (v) {
                              context.read<AddressCubit>().getneighborhoods(v);
                              setState(() {
                                selectedCity = v;
                                selectedNeighborhood =
                                    null; // Reset neighborhood selection
                              });
                            },
                          ),
                          SizedBox(height: 20.h),
                          CustomSingleSelect(
                            hintText: "neighborhood",
                            apiResponse: address.neighborhoodsResponse,
                            value: selectedNeighborhood,
                            items: address.neighborhoods
                                .map((e) => CustomSelectItem(
                                      name: e.title ?? "",
                                      value: e.id,
                                    ))
                                .toList(),
                            onChanged: (v) {
                              setState(() {
                                selectedNeighborhood = v;
                              });
                            },
                          ),
                        ],
                      ),
                    );
                  }),
                  SizedBox(height: 20.h),
                  Container(
                    height: 300.h,
                    child: GoogleMap(
                      onTap: (argument) {
                        NavigatorMethods.pushNamed(context, MapScreen.routeName,
                            arguments: MapScreenArgs(
                              onLocationSelected: (lat, lng, locality) {},
                            ));
                      },
                      initialCameraPosition: CameraPosition(
                        target: LatLng(24.7136, 46.6753),
                        zoom: 12,
                      ),
                      markers: Set<Marker>.of([
                        Marker(
                          markerId: MarkerId("1"),
                          position: LatLng(24.7136, 46.6753),
                        ),
                      ]),
                    ),
                  ),
                ],
              ),
            ),
          ),
          bottomNavigationBar: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    "assets/icons/check_icon.png",
                    height: 20,
                    width: 20,
                  ),
                  SizedBox(width: 10.w),
                  Text(
                    "جعل هذا العنوان عنواني الإفتراضي",
                    style: TextStyle(color: Colors.black, fontSize: 15.sp),
                  ),
                ],
              ),
              SizedBox(height: 20.h),
              GlobalElevatedButton(
                label: "إضافة العنوان",
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                backgroundColor: AppColor.mainAppColor,
                textColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                borderRadius: BorderRadius.circular(10),
                fixedWidth: 0.80, // 80% of the screen width
              ),
              SizedBox(height: 20.h),
            ],
          ),
        ));
  }
}
