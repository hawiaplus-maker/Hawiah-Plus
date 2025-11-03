import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hawiah_client/core/custom_widgets/custom_image/zoom_image_screen.dart';
import 'package:hawiah_client/core/images/app_images.dart';
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
          boxShadow: hasShadow
              ? [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  )
                ]
              : null,
        ),
        child: isValidUrl ? _buildCachedImage() : _buildErrorWidget(),
      ),
    );
  }

  Widget _buildCachedImage() {
    return CachedNetworkImage(
      imageUrl: imageUrl!,
      width: width,
      height: height,
      fit: fit ?? BoxFit.cover,
      // لا نعرض أي placeholder أو indicator نهائيًا
      placeholderFadeInDuration: Duration.zero,
      fadeInDuration: Duration.zero,
      fadeOutDuration: Duration.zero,
      memCacheWidth: width != null ? width!.toInt() : null,
      memCacheHeight: height != null ? height!.toInt() : null,
      cacheKey: imageUrl, // عشان الكاش يفضل ثابت
      useOldImageOnUrlChange: true, // لو الصورة متغيرة ما يعيدش التحميل فجأة
      errorWidget: (context, url, error) => _buildErrorWidget(),
      imageBuilder: (context, imageProvider) => Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(radius),
          image: DecorationImage(
            image: imageProvider,
            fit: fit ?? BoxFit.cover,
          ),
        ),
      ),
    );
  }

  Widget _buildErrorWidget() {
    return Image.asset(
      imagePlaceHolder ?? AppImages.hawiahPlus,
      width: width,
      height: height,
      fit: fit ?? BoxFit.contain,
    );
  }
}
