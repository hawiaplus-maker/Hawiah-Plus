import 'dart:io';

import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class ImageCompressor {
  // أقل من 2048KB بهامش أمان
  static const int maxBytes = 1900 * 1024;

  static Future<File> compress(File file) async {
    // لو الصورة أصلاً صغيرة سيبها
    if (await file.length() <= maxBytes) return file;

    final dir = await getTemporaryDirectory();
    int quality = 85;
    int maxSide = 1920;
    File result = file;

    while (quality >= 30) {
      final targetPath = p.join(
        dir.path,
        '${DateTime.now().microsecondsSinceEpoch}.jpg',
      );

      final compressed = await FlutterImageCompress.compressAndGetFile(
        file.absolute.path,
        targetPath,
        quality: quality,
        minWidth: maxSide,
        minHeight: maxSide,
        format: CompressFormat.jpeg,
      );

      if (compressed == null) break;

      result = File(compressed.path);
      if (await result.length() <= maxBytes) return result;

      // لسه كبيرة: قلل الجودة والأبعاد وجرب تاني
      quality -= 15;
      maxSide = (maxSide * 0.8).round();
    }

    return result;
  }
}
