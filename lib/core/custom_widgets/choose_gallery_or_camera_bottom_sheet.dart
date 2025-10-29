import 'package:flutter/material.dart';
import 'package:hawiah_client/core/theme/app_colors.dart';

class ChooseGalleryOrCameraBottomSheet extends StatelessWidget {
  final void Function()? onCamera;
  final void Function()? onGallery;
  const ChooseGalleryOrCameraBottomSheet({
    super.key,
    this.onCamera,
    this.onGallery,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColor.popupColor,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 15),
          SizedBox(
            width: 40,
            child: Divider(color: AppColor.hintColor),
          ),
          const SizedBox(height: 15),
          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  // TextButton(
                  //   onPressed: onCamera,
                  //   child: Row(
                  //     children: [
                  //       SvgPicture.asset(
                  //         AppImages.cameraIcon,
                  //         colorFilter: ColorFilter.mode(
                  //           AppColor.mainAppColor,
                  //           BlendMode.srcIn,
                  //         ),
                  //       ),
                  //       const SizedBox(width: 5),
                  //       Text(
                  //         tr(AppLocaleKey.camera),
                  //         style: TextStyle(
                  //           fontSize: 15,
                  //           fontWeight: FontWeight.w400,
                  //           color: AppColor.textSecondaryColor,
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  Divider(
                    color: AppColor.hintColor,
                  ),
                  // TextButton(
                  //   onPressed: onGallery,
                  //   child: Row(
                  //     children: [
                  //       SvgPicture.asset(
                  //         AppImages.galleryIcon,
                  //         colorFilter: ColorFilter.mode(
                  //           AppColor.mainAppColor,
                  //           BlendMode.srcIn,
                  //         ),
                  //       ),
                  //       const SizedBox(width: 5),
                  //       Text(
                  //         tr(AppLocaleKey.gallery),
                  //         style: TextStyle(
                  //           fontSize: 15,
                  //           fontWeight: FontWeight.w400,
                  //           color: AppColor.textSecondaryColor,
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // ),

                  const SizedBox(height: 15),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
