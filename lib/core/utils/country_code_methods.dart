import 'package:country_picker/country_picker.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../extension/context_extension.dart';
import '../locale/app_locale_key.dart';
import '../theme/app_theme.dart';

class CountryCodeMethods {
  static Country getByCode(String code) {
    return CountryParser.parsePhoneCode(code);
  }

  static void pickCountry({
    required void Function(Country) onSelect,
    required BuildContext context,
  }) {
    showCountryPicker(
      context: context,
      showPhoneCode: true,
      
      countryFilter: ['EG', 'SA', 'AE', 'KW', 'QA', 'OM', 'BH'],
      favorite: [
        // 'AE',
        'SA',
        // 'QA',
        // 'BH',
        // 'KW',
        // 'OM',
        // 'YE',
        // 'LB',
        // 'SY',
        // 'PS',
        // 'JO',
        // 'IQ',
        // 'EG',
        // 'SD',
        // 'SO',
        // 'DJ',
        // 'KM',
        // 'LY',
        // 'DZ',
        // 'TN',
        // 'MA',
        // 'MR',
      ],
      countryListTheme: CountryListThemeData(
        flagSize: 25,
        backgroundColor: AppTheme.getByTheme(
          light: const Color(0xffffffff),
          dark: const Color(0xffffffff),
          listen: false,
        ),
        textStyle: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: AppTheme.getByTheme(
            light: const Color(0xff191C24),
            dark: const Color(0xff191C24),
            listen: false,
          ),
        ),
        bottomSheetHeight: context.height() * 0.8,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
        inputDecoration: InputDecoration(
          hintText: tr(AppLocaleKey.search),
          hintStyle: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: AppTheme.getByTheme(
              light: const Color(0xff8A8D9F),
              dark: const Color(0xff8A8D9F),
              listen: false,
            ),
          ),
          fillColor: AppTheme.getByTheme(
            light: const Color(0xFFF4F5F7),
            dark: const Color(0xFFF4F5F7),
            listen: false,
          ),
          filled: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: BorderSide(
              color: AppTheme.getByTheme(
                light: const Color(0xFFF4F5F7),
                dark: const Color(0xFFF4F5F7),
                listen: false,
              ),
            ),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: BorderSide(
              color: AppTheme.getByTheme(
                light: const Color(0xFFF4F5F7),
                dark: const Color(0xFFF4F5F7),
                listen: false,
              ),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: BorderSide(
              color: AppTheme.getByTheme(
                light: const Color(0xff0270EB),
                dark: const Color(0xff0270EB),
                listen: false,
              ),
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: BorderSide(
              color: AppTheme.getByTheme(
                light: const Color(0xFFF4F5F7),
                dark: const Color(0xFFF4F5F7),
                listen: false,
              ),
            ),
          ),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
        ),
      ),
      onSelect: onSelect,
    );
  }
}
