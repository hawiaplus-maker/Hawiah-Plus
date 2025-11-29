import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:hawiah_client/core/custom_widgets/custom_image/zoom_image_screen.dart';
import 'package:hawiah_client/core/images/app_images.dart';
import 'package:hawiah_client/core/utils/navigator_methods.dart';

/// Cache Manager
class AppCacheManager {
  static final instance = CacheManager(
    Config(
      'appImageCache',
      stalePeriod: const Duration(days: 7),
      maxNrOfCacheObjects: 200,
    ),
  );
}

class CustomNetworkImage extends StatelessWidget {
  /// Smart Prefetching
  static Future<void> smartPrefetch(List<String> urls) async {
    try {
      final connectivity = await Connectivity().checkConnectivity();

      if (connectivity == ConnectivityResult.wifi) {
        for (final url in urls.take(10)) {
          if (url.isNotEmpty) AppCacheManager.instance.getSingleFile(url);
        }
        return;
      }

      if (connectivity == ConnectivityResult.mobile) {
        for (final url in urls.take(3)) {
          if (url.isNotEmpty) AppCacheManager.instance.getSingleFile(url);
        }
        return;
      }
    } catch (_) {}
  }

  final String? imageUrl;
  final double? width;
  final double? height;
  final double radius;
  final BoxFit fit;
  final bool hasZoom;
  final bool hasShadow;
  final Color? color;
  final String? imagePlaceHolder;

  const CustomNetworkImage({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.radius = 0,
    this.hasZoom = false,
    this.hasShadow = false,
    this.color,
    this.imagePlaceHolder,
  });

  @override
  Widget build(BuildContext context) {
    final valid = imageUrl != null && imageUrl!.isNotEmpty;

    Widget child = ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: Container(
        color: color,
        child: valid ? _buildOptimizedImage(context) : _buildErrorWidget(),
      ),
    );

    if (hasShadow) {
      child = Material(
        elevation: 2,
        borderRadius: BorderRadius.circular(radius),
        clipBehavior: Clip.antiAlias,
        child: child,
      );
    }

    if (hasZoom && valid) {
      return InkWell(
        onTap: () => NavigatorMethods.pushNamed(
          context,
          ZoomImageScreen.routeName,
          arguments: ZoomImageArgs(imageUrl: imageUrl),
        ),
        child: child,
      );
    }

    return child;
  }

  Widget _buildOptimizedImage(BuildContext context) {
    final deviceRatio = MediaQuery.of(context).devicePixelRatio;
    final w = (width ?? 60) * deviceRatio;
    final h = (height ?? width ?? 60) * deviceRatio;

    return CachedNetworkImage(
      cacheManager: AppCacheManager.instance,
      imageUrl: imageUrl!,
      width: width,
      height: height,
      fit: fit,
      memCacheWidth: w.toInt(),
      memCacheHeight: h.toInt(),
      placeholder: (_, __) => _buildPlaceholder(),
      errorWidget: (_, __, ___) => _buildErrorWidget(),
      useOldImageOnUrlChange: true,
      fadeInDuration: Duration.zero,
      fadeOutDuration: Duration.zero,
      placeholderFadeInDuration: Duration.zero,
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        color: Colors.grey.shade200,
      ),
      child: const Center(
        child: Image(
          image: AssetImage(
            AppImages.hawiahPlus,
          ),
        ),
      ),
    );
  }

  Widget _buildErrorWidget() {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        color: Colors.grey.shade100,
      ),
      child: Center(
        child: Image.asset(
          imagePlaceHolder ?? AppImages.hawiahPlus,
          width: (width ?? 60) * 0.6,
          height: (height ?? width ?? 60) * 0.6,
        ),
      ),
    );
  }

  static Future<void> prefetchImages(List<String> urls) async {
    for (final u in urls) {
      if (u.isNotEmpty) {
        try {
          await AppCacheManager.instance.getSingleFile(u);
        } catch (_) {}
      }
    }
  }
}
