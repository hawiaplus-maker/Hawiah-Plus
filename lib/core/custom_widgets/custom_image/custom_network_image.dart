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
          boxShadow: hasShadow ? _defaultShadow : null,
        ),
        child: isValidUrl ? _buildCachedImage() : _buildErrorWidget(),
      ),
    );
  }

  // Cache the shadow to avoid recreating it
  static final _defaultShadow = [
    BoxShadow(
      color: Colors.black.withOpacity(0.1),
      blurRadius: 4,
      offset: const Offset(0, 2),
    )
  ];

  Widget _buildCachedImage() {
    return CachedNetworkImage(
      imageUrl: imageUrl!,
      width: width,
      height: height,
      fit: fit ?? BoxFit.cover,
      // تحسين إعدادات الـ cache
      placeholder: (context, url) => _buildPlaceholder(),
      errorWidget: (context, url, error) => _buildErrorWidget(),
      // تحسين إعدادات التحميل
      placeholderFadeInDuration: Duration.zero,
      fadeInDuration: const Duration(milliseconds: 300),
      fadeOutDuration: const Duration(milliseconds: 300),
      // تحسين إعدادات الذاكرة
      memCacheWidth:
          width != null ? (width! * WidgetsBinding.instance.window.devicePixelRatio).toInt() : null,
      memCacheHeight: height != null
          ? (height! * WidgetsBinding.instance.window.devicePixelRatio).toInt()
          : null,
      // تحسين إعدادات الـ cache
      cacheKey: imageUrl,
      useOldImageOnUrlChange: true,
      maxWidthDiskCache: width != null ? (width! * 2).toInt() : null,
      maxHeightDiskCache: height != null ? (height! * 2).toInt() : null,
    );
  }

  // إضافة placeholder أثناء التحميل
  Widget _buildPlaceholder() {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        color: Colors.grey[200],
      ),
      child: Icon(
        Icons.image,
        size: _calculateIconSize(),
        color: Colors.grey[400],
      ),
    );
  }

  Widget _buildErrorWidget() {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        color: Colors.grey[100],
      ),
      child: Image.asset(
        imagePlaceHolder ?? AppImages.hawiahPlus,
        width: _calculatePlaceholderSize(),
        height: _calculatePlaceholderSize(),
        fit: BoxFit.contain,
      ),
    );
  }

  // حساب حجم الأيقونة بناء على حجم الصورة
  double _calculateIconSize() {
    final baseSize = width ?? height ?? 48.0;
    return baseSize * 0.4;
  }

  // حساب حجم placeholder
  double _calculatePlaceholderSize() {
    final baseSize = width ?? height ?? 48.0;
    return baseSize * 0.6;
  }
}
