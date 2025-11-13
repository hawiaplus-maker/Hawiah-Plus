import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:hawiah_client/core/custom_widgets/custom_image/zoom_image_screen.dart';
import 'package:hawiah_client/core/images/app_images.dart';
import 'package:hawiah_client/core/utils/navigator_methods.dart';

/// مثال CacheManager مخصص
class AppCacheManager {
  static final instance = CacheManager(
    Config(
      'appImageCache',
      stalePeriod: const Duration(days: 7),
      maxNrOfCacheObjects: 200,
      repo: JsonCacheInfoRepository(databaseName: 'appImageCache'),
      // maxSizeBytes: 200 * 1024 * 1024, // اختياري: حد أقصى للمساحة (200MB)
    ),
  );
}

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

    // Gesture only when zoom enabled to avoid unnecessary GestureDetector overhead
    Widget child = ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: Container(
        color: color,
        child: isValidUrl ? _buildCachedImage() : _buildErrorWidget(),
      ),
    );

    // If need shadow, wrap with Material to use elevation (cheaper paint in many cases)
    if (hasShadow) {
      child = Material(
        elevation: 2,
        borderRadius: BorderRadius.circular(radius),
        clipBehavior: Clip.antiAlias,
        child: child,
      );
    }

    if (hasZoom && isValidUrl) {
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

  Widget _buildCachedImage() {
    // Use LayoutBuilder to know actual size rendered and set correct decode size
    return LayoutBuilder(builder: (context, constraints) {
      // determine target pixels (width x pixelRatio)
      final devicePixelRatio = MediaQuery.of(context).devicePixelRatio;

      // prefer explicit width/height if provided; otherwise use constraints or fallback
      final renderWidth = (width ?? (constraints.maxWidth.isFinite ? constraints.maxWidth : 48.0));
      final renderHeight =
          (height ?? (constraints.maxHeight.isFinite ? constraints.maxHeight : renderWidth));

      // avoid infinite or zero
      final targetW = ((renderWidth.isFinite && renderWidth > 0)
          ? (renderWidth * devicePixelRatio).toInt()
          : null);
      final targetH = ((renderHeight.isFinite && renderHeight > 0)
          ? (renderHeight * devicePixelRatio).toInt()
          : null);

      return CachedNetworkImage(
        cacheManager: AppCacheManager.instance,
        imageUrl: imageUrl!,
        width: width,
        height: height,
        fit: fit ?? BoxFit.cover,
        placeholder: (ctx, url) => _buildPlaceholder(),
        errorWidget: (ctx, url, error) => _buildErrorWidget(),
        // Use imageBuilder to wrap the provider with ResizeImage so decoding is smaller
        imageBuilder: (ctx, imageProvider) {
          ImageProvider resized = imageProvider;
          if (targetW != null || targetH != null) {
            // Wrap provider so that decode happens at target size (saves memory)
            resized = ResizeImage.resizeIfNeeded(
              targetW,
              targetH,
              imageProvider,
            );
          }
          return Image(
            image: resized,
            width: width,
            height: height,
            fit: fit ?? BoxFit.cover,
          );
        },
        // fallback memory cache hints (still useful)
        memCacheWidth: targetW,
        memCacheHeight: targetH,
        // small fade durations are okay; placeholder instant
        placeholderFadeInDuration: Duration.zero,
        fadeInDuration: const Duration(milliseconds: 220),
        fadeOutDuration: const Duration(milliseconds: 150),
        useOldImageOnUrlChange: true,
      );
    });
  }

  Widget _buildPlaceholder() {
    return LayoutBuilder(builder: (context, constraints) {
      // حاول استخدام القيمة الممررة أولًا، وإلا استخدم قيود اللياؤت لو finite،
      // وإلا fallback على 48.0
      final rawBase = width ??
          height ??
          (constraints.maxWidth.isFinite && constraints.maxWidth > 0
              ? constraints.maxWidth
              : (constraints.maxHeight.isFinite && constraints.maxHeight > 0
                  ? constraints.maxHeight
                  : 48.0));

      final baseSize = (rawBase.isFinite && rawBase > 0) ? rawBase : 48.0;
      final iconSize = baseSize * 0.4;

      return Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(radius),
          color: Colors.grey[200],
        ),
        child: Center(
          child: Icon(
            Icons.image,
            size: iconSize,
            color: Colors.grey[400],
          ),
        ),
      );
    });
  }

  Widget _buildErrorWidget() {
    return LayoutBuilder(builder: (context, constraints) {
      final rawBase = width ??
          height ??
          (constraints.maxWidth.isFinite && constraints.maxWidth > 0
              ? constraints.maxWidth
              : (constraints.maxHeight.isFinite && constraints.maxHeight > 0
                  ? constraints.maxHeight
                  : 48.0));

      final baseSize = (rawBase.isFinite && rawBase > 0) ? rawBase : 48.0;
      final placeholderSize = baseSize * 0.6;

      return Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(radius),
          color: Colors.grey[100],
        ),
        child: Center(
          child: Image.asset(
            imagePlaceHolder ?? AppImages.hawiahPlus,
            width: placeholderSize,
            height: placeholderSize,
            fit: BoxFit.contain,
          ),
        ),
      );
    });
  }

  /// Helper to prefetch a list of images (call during data load)
  static Future<void> prefetchImages(List<String> urls) async {
    for (final u in urls) {
      if (u.isNotEmpty) {
        try {
          await AppCacheManager.instance.getSingleFile(u);
        } catch (_) {
          // ignore individual errors
        }
      }
    }
  }
}
