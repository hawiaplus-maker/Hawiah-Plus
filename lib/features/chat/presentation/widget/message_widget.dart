import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:hawiah_client/core/custom_widgets/custom_image/custom_network_image.dart';
import 'package:hawiah_client/core/theme/app_colors.dart';
import 'package:hawiah_client/core/theme/app_text_style.dart';
import 'package:hawiah_client/core/utils/date_methods.dart';
import 'package:hawiah_client/features/chat/model/chat_model.dart';
import 'package:hawiah_client/features/profile/presentation/cubit/cubit_profile.dart';
import 'package:provider/provider.dart';

class MessageWidget extends StatelessWidget {
  const MessageWidget({super.key, required this.message});
  final ChatMessageModel message;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection:
          int.tryParse(message.senderId.toString()) == context.read<ProfileCubit>().user!.id
              ? TextDirection.rtl
              : TextDirection.ltr,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Gap(10.h),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomNetworkImage(
                imageUrl: context.read<ProfileCubit>().user!.image,
                fit: BoxFit.fill,
                height: 50,
                width: 50,
                radius: 30,
              ),
              SizedBox(width: 5.w),
              Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 15,
                ),
                decoration: BoxDecoration(
                    color: int.tryParse(message.senderId.toString()) ==
                            context.read<ProfileCubit>().user!.id
                        ? AppColor.mainAppColor
                        : AppColor.whiteColor,
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(24),
                      bottomLeft: Radius.circular(
                        int.tryParse(message.senderId.toString()) ==
                                context.read<ProfileCubit>().user!.id
                            ? 10
                            : 0,
                      ),
                      bottomRight: Radius.circular(
                        int.tryParse(message.senderId.toString()) ==
                                context.read<ProfileCubit>().user!.id
                            ? 20
                            : 0,
                      ),
                    ),
                    boxShadow: [
                      int.tryParse(message.senderId.toString()) ==
                              context.read<ProfileCubit>().user!.id
                          ? BoxShadow()
                          : BoxShadow(
                              color: AppColor.lightGreyColor,
                              spreadRadius: 5,
                              blurRadius: 7,
                              offset: const Offset(0, 3),
                            ),
                    ]),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      message.message ?? "",
                      maxLines: 5,
                      style: int.tryParse(message.senderId.toString()) ==
                              context.read<ProfileCubit>().user!.id
                          ? AppTextStyle.text14_500.copyWith(color: AppColor.whiteColor)
                          : AppTextStyle.text14_500,
                    ),
                    Text(
                      DateMethods.formatToTime(message.timeStamp),
                      style: int.tryParse(message.senderId.toString()) ==
                              context.read<ProfileCubit>().user!.id
                          ? AppTextStyle.text12_400.copyWith(color: AppColor.whiteColor)
                          : AppTextStyle.text12_400.copyWith(
                              color: AppColor.textSecondaryColor,
                            ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class TrianglePainter extends CustomPainter {
  TrianglePainter({this.color});
  final Color? color;
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color ?? Colors.white // Change color as needed
      ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(0, size.height);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(TrianglePainter oldDelegate) {
    return false;
  }
}

class MeTrianglePainter extends CustomPainter {
  MeTrianglePainter({this.color});
  final Color? color;
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color ?? Colors.white // Change color as needed
      ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(0, 0);
    path.lineTo(0, size.height);
    path.lineTo(size.width, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(MeTrianglePainter oldDelegate) {
    return false;
  }
}
