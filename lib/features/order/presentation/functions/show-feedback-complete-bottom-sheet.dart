import 'package:flutter/material.dart';
import 'package:hawiah_client/core/custom_widgets/global-elevated-button-widget.dart';

void showThankYouBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    isScrollControlled: true,
    builder: (context) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.favorite,
              color: Colors.red,
              size: 50,
            ),
            SizedBox(height: 16),
            Text(
              'شكراً لوقتك الثمين',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'نحن نحرص بعناية دائماً تحسين مستوى خدمات تطبيق هاوية. نتمنى لك تجربة سعيدة. هل تود ظهور التقييم مرة أخرى؟',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 24),
            GlobalElevatedButton(
              label: 'بالتأكيد !',
              onPressed: () {},
              backgroundColor: Color(0xff2D01FE),
              textColor: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              borderRadius: BorderRadius.circular(10),
              fixedWidth: 0.80, // 80% of the screen width
            ),
            SizedBox(height: 16),
            GlobalElevatedButton(
              label: 'لا تسألني مجدداً',
              onPressed: () {},
              backgroundColor: Colors.white,
              textColor: Colors.red.shade300,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              borderRadius: BorderRadius.circular(20),
              fixedWidth: 0.80, // 80% of the screen width
            )
          ],
        ),
      );
    },
  );
}
