import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:hawiah_client/core/custom_widgets/custom_image/zoom_image_screen.dart';
import 'package:hawiah_client/core/images/app_images.dart';
import 'package:hawiah_client/core/theme/app_colors.dart';
import 'package:hawiah_client/core/utils/navigator_methods.dart';

class CustomNetworkImage extends StatelessWidget {
  final String? imageUrl;
  final double? width;
  final double? height;
  final double radius;
  final BoxFit? fit;
  final bool hasZoom;
  final bool hasShadow;
  final Color? color;
  final String? imagePlaceHolder;

  const CustomNetworkImage({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit,
    this.radius = 0,
    this.hasZoom = false,
    this.hasShadow = false,
    this.color,
    this.imagePlaceHolder,
  });

  @override
  Widget build(BuildContext context) {
    final isValidUrl = imageUrl != null && imageUrl!.isNotEmpty;
    return GestureDetector(
      onTap: hasZoom && isValidUrl
          ? () => NavigatorMethods.pushNamed(
                context,
                ZoomImageScreen.routeName,
                arguments: ZoomImageArgs(imageUrl: imageUrl),
              )
          : null,
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(radius),
        ),
        child: isValidUrl
            ? CachedNetworkImage(
                imageUrl: imageUrl!,
                fit: fit,
                width: width,
                height: height,
                placeholder: (context, url) => CupertinoActivityIndicator(
                  color: AppColor.mainAppColor,
                ),
                errorWidget: (context, url, error) => _buildErrorWidget(),
              )
            : _buildErrorWidget(),
      ),
    );
  }

  Widget _buildErrorWidget() {
    return Image.asset(
      imagePlaceHolder ?? AppImages.logoIcon,
      width: width,
      height: height,
      fit: fit ?? BoxFit.contain,
    );
  }
}
