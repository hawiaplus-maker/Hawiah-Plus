import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hawiah_client/core/custom_widgets/custom_image/custom_network_image.dart';
import 'package:hawiah_client/core/theme/app_colors.dart';
import 'package:hawiah_client/core/utils/navigator_methods.dart';
import 'package:hawiah_client/features/authentication/presentation/controllers/auth-cubit/auth-cubit.dart';
import 'package:hawiah_client/features/authentication/presentation/controllers/auth-cubit/auth-state.dart';
import 'package:hawiah_client/features/authentication/presentation/screens/login-screen.dart';
import 'package:hawiah_client/features/chat/presentation/screens/chat-screen.dart';
import 'package:hawiah_client/features/location/presentation/screens/all_addresses_screen.dart';
import 'package:hawiah_client/features/order/presentation/screens/orders-screen.dart';
import 'package:hawiah_client/features/profile/presentation/cubit/cubit_profile.dart';
import 'package:hawiah_client/features/profile/presentation/screens/faq-screen.dart';
import 'package:hawiah_client/features/profile/presentation/screens/language-screen.dart';
import 'package:hawiah_client/features/profile/presentation/screens/privacy-policy-screen.dart';
import 'package:hawiah_client/features/profile/presentation/screens/setting-screen.dart';
import 'package:hawiah_client/features/profile/presentation/screens/terms-and-conditions.dart';
import 'package:hawiah_client/features/profile/presentation/screens/user_profile_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    // final profile = context.read<ProfileCubit>().user;
    return Scaffold(
      appBar: AppBar(
        title: Text("الملف الشخصي"),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {},
            icon: Image.asset(
              "assets/icons/notfication_icon.png",
            ),
            constraints: BoxConstraints(maxWidth: 40.w, maxHeight: 40.h),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Row(
                  children: [
                    CustomNetworkImage(
                      imageUrl: "profile.image",
                      height: 70.h,
                      width: 70.w,
                      radius: 45,
                      fit: BoxFit.contain,
                    ),
                    SizedBox(
                      width: 10.w,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          context.read<ProfileCubit>().user.name,
                          style:
                              TextStyle(fontSize: 16.sp, color: Colors.black),
                        ),
                        Text(
                          context.read<ProfileCubit>().user.email,
                          style: TextStyle(
                              fontSize: 12.sp, color: Color(0xffB5B5B5)),
                        ),
                      ],
                    ),
                    Spacer(),
                    GestureDetector(
                      onTap: () {
                        Navigator.push<void>(
                            context,
                            MaterialPageRoute<void>(
                              builder: (BuildContext context) => UserProfile(),
                            ));
                      },
                      child: Container(
                        child: Row(
                          children: [
                            Image.asset(
                              "assets/icons/edit_icon.png",
                              height: 15.h,
                              width: 15.w,
                            ),
                            SizedBox(
                              width: 5.w,
                            ),
                            Text(
                              "تعديل",
                              style: TextStyle(
                                  fontSize: 16.sp,
                                  color: AppColor.mainAppColor,
                                  decoration: TextDecoration.underline),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10.h,
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 40.w,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    PersonProfileTap(
                        title: "الطلبات",
                        logo: "assets/icons/box_icon.png",
                        onTap: () {
                          Navigator.push<void>(
                              context,
                              MaterialPageRoute<void>(
                                builder: (BuildContext context) =>
                                    const OrdersScreen(),
                              ));
                        }),
                    PersonProfileTap(
                        title: "العقود",
                        logo: "assets/icons/order_icon.png",
                        onTap: () {}),
                    PersonProfileTap(
                        title: "المحادثات",
                        logo: "assets/icons/chat_icon.png",
                        onTap: () {
                          Navigator.push<void>(
                            context,
                            MaterialPageRoute<void>(
                              builder: (BuildContext context) => ChatScreen(),
                            ),
                          );
                        }),
                    PersonProfileTap(
                        title: "المفضلة",
                        logo: "assets/icons/favorite_icon.png",
                        color: Color(0xffEA4335),
                        onTap: () {},
                        isLastItem: true),
                  ],
                ),
              ),
              SizedBox(
                height: 10.h,
              ),
              Container(
                color: Color(0xffF9F9F9),
                height: 15.h,
              ),
              SizedBox(
                height: 10.h,
              ),
              PersonProfileListTile(
                  title: "العناوين",
                  logo: "assets/icons/personal_location_icon.png",
                  onTap: () {
                    NavigatorMethods.pushNamed(
                        context, AllAddressesScreen.routeName);
                  }),
              PersonProfileListTile(
                  title: "كوبونات الخصم",
                  logo: "assets/icons/coupon_icon.png",
                  onTap: () {}),
              PersonProfileListTile(
                  title: "دعوة صديق",
                  logo: "assets/icons/person_invite_icon.png",
                  isHaveLine: false,
                  onTap: () {}),
              SizedBox(
                height: 10.h,
              ),
              Container(
                color: Color(0xffF9F9F9),
                height: 15.h,
              ),
              SizedBox(
                height: 10.h,
              ),
              PersonProfileListTile(
                  title: "الدعم",
                  logo: "assets/icons/call_us_icon.png",
                  onTap: () {}),
              PersonProfileListTile(
                  title: "الأسئلة الشائعة",
                  logo: "assets/icons/qestions_icon.png",
                  onTap: () {
                    Navigator.push<void>(
                      context,
                      MaterialPageRoute<void>(
                        builder: (BuildContext context) => const FaqScreen(),
                      ),
                    );
                  }),
              PersonProfileListTile(
                  title: "لغة التطبيق",
                  logo: "assets/icons/language_icon.png",
                  trailing: Row(
                    children: [
                      Text(
                        "العربية",
                      ),
                      SizedBox(
                        width: 5.w,
                      ),
                      Image.asset("assets/icons/flag_saudi_arabia_icon.png",
                          height: 25.h, width: 25.w),
                    ],
                  ),
                  onTap: () {
                    Navigator.push<void>(
                      context,
                      MaterialPageRoute<void>(
                        builder: (BuildContext context) =>
                            const LanguageScreen(),
                      ),
                    );
                  }),
              PersonProfileListTile(
                  title: "الإعدادات",
                  logo: "assets/icons/setting_icon.png",
                  onTap: () {
                    Navigator.push<void>(
                      context,
                      MaterialPageRoute<void>(
                        builder: (BuildContext context) => SettingsScreen(),
                      ),
                    );
                  }),
              PersonProfileListTile(
                  title: "سياسة الخصوصية",
                  logo: "assets/icons/shield_keyhole_icon.png",
                  onTap: () {
                    Navigator.push<void>(
                      context,
                      MaterialPageRoute<void>(
                        builder: (BuildContext context) =>
                            PrivacyPolicyScreen(),
                      ),
                    );
                  }),
              PersonProfileListTile(
                  title: "الشروط والأحكام",
                  logo: "assets/icons/shield_check_icon.png",
                  onTap: () {
                    Navigator.push<void>(
                      context,
                      MaterialPageRoute<void>(
                        builder: (BuildContext context) =>
                            TermsAndConditionsScreen(),
                      ),
                    );
                  }),
              BlocConsumer<AuthCubit, AuthState>(
                builder: (context, state) {
                  return InkWell(
                    onTap: () {
                      AuthCubit.get(context).logout();
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 20.w, vertical: 10.h),
                      child: Row(children: [
                        Image.asset("assets/icons/sign_out_icon.png",
                            height: 30.h, width: 30.w),
                        SizedBox(
                          width: 10.w,
                        ),
                        Text(
                          "تسجيل خروج",
                          style:
                              TextStyle(fontSize: 14.sp, color: Colors.black),
                        ),
                      ]),
                    ),
                  );
                },
                listener: (BuildContext context, state) {
                  if (state is AuthError) {
                    Fluttertoast.showToast(
                      msg: state.message,
                      toastLength: Toast.LENGTH_LONG,
                      gravity: ToastGravity.BOTTOM,
                      backgroundColor: Colors.redAccent,
                      textColor: Colors.black,
                      fontSize: 16.0,
                    );
                  }
                  if (state is AuthSuccess) {
                    Fluttertoast.showToast(
                      msg: state.message,
                      toastLength: Toast.LENGTH_LONG,
                      gravity: ToastGravity.BOTTOM,
                      backgroundColor: Colors.green,
                      textColor: Colors.white,
                      fontSize: 16.0,
                    );
                    Navigator.pushAndRemoveUntil<void>(
                      context,
                      MaterialPageRoute<void>(
                        builder: (BuildContext context) => const LoginScreen(),
                      ),
                      (route) => false,
                    );
                  } else if (state is AuthError) {
                    Fluttertoast.showToast(
                      msg: state.message,
                      toastLength: Toast.LENGTH_LONG,
                      gravity: ToastGravity.BOTTOM,
                      backgroundColor: Colors.redAccent,
                      textColor: Colors.white,
                      fontSize: 16.0,
                    );
                  }
                },
              ),
              SizedBox(
                height: 70.h,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget PersonProfileTap(
      {required String title,
      required String logo,
      bool isLastItem = false,
      required VoidCallback onTap,
      Color color = Colors.black}) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Column(
            children: [
              Image.asset(logo, height: 40.h, width: 35.w),
              Text(
                title,
                style: TextStyle(fontSize: 13.sp, color: color),
              ),
            ],
          ),
          isLastItem == false
              ? Container(
                  alignment: Alignment.centerRight,
                  margin: EdgeInsets.symmetric(horizontal: 10.w),
                  height: 50,
                  child: VerticalDivider(
                    thickness: 0.5,
                    width: 20,
                    color: Colors.grey,
                  ),
                )
              : SizedBox.shrink(),
        ],
      ),
    );
  }

  Widget PersonProfileListTile(
      {required String title,
      required String logo,
      required VoidCallback onTap,
      Widget? trailing,
      bool isHaveLine = true}) {
    return GestureDetector(
        onTap: onTap,
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
              child: Row(children: [
                Row(
                  children: [
                    Image.asset(logo, height: 30.h, width: 30.w),
                    SizedBox(
                      width: 10.w,
                    ),
                    Text(
                      title,
                      style: TextStyle(fontSize: 14.sp, color: Colors.black),
                    ),
                  ],
                ),
                Spacer(),
                trailing == null
                    ? Icon(
                        Icons.arrow_forward_ios,
                        size: 20.sp,
                        color: Color(0xffA6A6A6),
                      )
                    : trailing,
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
