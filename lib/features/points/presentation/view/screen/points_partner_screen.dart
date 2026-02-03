import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hawiah_client/core/custom_widgets/custom_app_bar.dart';
import 'package:hawiah_client/core/locale/app_locale_key.dart';

class PointsPartnerScreen extends StatefulWidget {
  static const String routeName = "/pointsPartnerScreen";
  const PointsPartnerScreen({Key? key}) : super(key: key);

  @override
  _PointsPartnerScreenState createState() => _PointsPartnerScreenState();
}

class _PointsPartnerScreenState extends State<PointsPartnerScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        context,
        titleText: AppLocaleKey.pointsPartners.tr(),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [],
      ),
    );
  }
}
