import 'dart:ui' as ui;

import 'package:country_picker/country_picker.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hawiah_client/core/custom_widgets/custom_button.dart';
import 'package:hawiah_client/core/custom_widgets/svg_prefix_icon.dart';
import 'package:hawiah_client/core/extension/context_extension.dart';
import 'package:hawiah_client/core/theme/app_colors.dart';
import 'package:hawiah_client/core/theme/app_text_style.dart';
import 'package:hawiah_client/core/utils/country_code_methods.dart';

enum FormFieldBorder { underLine, outLine, none }

class CustomTextField extends StatefulWidget {
  final TextEditingController? controller;
  final void Function(String)? onChanged;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final bool isPassword;
  final String? hintText;
  final int? maxLines;
  final String? initialValue;
  final void Function()? onTap;
  final bool readOnly;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final double radius;
  final Color? fillColor;
  final Color? focusColor;
  final Color? unFocusColor;
  final Color? passwordColor;
  final String? title;
  final String? otherSideTitle;
  final ui.TextDirection? textDirection;
  final Country? country;
  final List<TextInputFormatter>? inputFormatters;
  final void Function(Country)? onCountrySelect;
  final FormFieldBorder formFieldBorder;
  final TextStyle? titleStyle;
  final TextStyle? textStyle;
  final TextStyle? phonePickStyle;
  final TextStyle? hintStyle;
  final int? maxLength;
  final AutovalidateMode? autovalidateMode;
  final Widget? label;
  final String? labelText;
  final String? prefixIconSvg;
  final Color? prefixIconSvgColor;
  final String? suffixIconSvg;
  final Color? suffixIconSvgColor;
  final double? width;
  final TextAlign textAlign;
  final FocusNode? focusNode;
  final bool hasShadow;
  final TextInputAction? textInputAction;
  final void Function(String)? onSubmitted;
  const CustomTextField({
    super.key,
    this.initialValue,
    this.controller,
    this.onChanged,
    this.validator,
    this.keyboardType,
    this.isPassword = false,
    this.hintText,
    this.maxLines = 1,
    this.onTap,
    this.readOnly = false,
    this.prefixIcon,
    this.suffixIcon,
    this.radius = 12,
    this.fillColor,
    this.focusColor,
    this.unFocusColor,
    this.title,
    this.textDirection,
    this.otherSideTitle,
    this.country,
    this.passwordColor,
    this.formFieldBorder = FormFieldBorder.outLine,
    this.inputFormatters,
    this.onCountrySelect,
    this.titleStyle,
    this.textStyle,
    this.hintStyle,
    this.maxLength,
    this.autovalidateMode,
    this.phonePickStyle,
    this.label,
    this.labelText,
    this.prefixIconSvg,
    this.suffixIconSvg,
    this.width,
    this.textAlign = TextAlign.start,
    this.prefixIconSvgColor,
    this.suffixIconSvgColor,
    this.focusNode,
    this.hasShadow = false,
    this.onSubmitted,
    this.textInputAction,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width ?? MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(widget.radius),
        boxShadow: widget.hasShadow
            ? [
                BoxShadow(
                  offset: const Offset(0, 3),
                  color: Colors.black.withValues(alpha: 0.16),
                  blurRadius: 6,
                ),
              ]
            : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              if (widget.title != null) ...{
                Expanded(
                  child: Text(
                    widget.title!,
                    style: widget.titleStyle ?? AppTextStyle.formTitleStyle,
                  ),
                ),
              },
              if (widget.otherSideTitle != null) ...{
                Text(
                  widget.otherSideTitle!,
                  style: widget.titleStyle ?? AppTextStyle.formTitleStyle,
                ),
              },
            ],
          ),
          if (widget.title != null || widget.otherSideTitle != null) ...{
            const SizedBox(width: 10),
          },
          Directionality(
            textDirection: widget.textDirection != null
                ? widget.textDirection!
                : context.isRTL()
                    ? ui.TextDirection.rtl
                    : ui.TextDirection.ltr,
            child: TextFormField(
              onFieldSubmitted: widget.onSubmitted,
              clipBehavior: Clip.antiAlias,
              focusNode: widget.focusNode,
              onTapOutside: (event) {
                FocusManager.instance.primaryFocus?.unfocus();
              },
              controller: widget.controller,
              initialValue: widget.initialValue,
              onChanged: widget.onChanged,
              validator: widget.validator,
              onTap: widget.onTap,
              readOnly: widget.readOnly,
              keyboardType: widget.keyboardType,
              obscureText: widget.isPassword ? _obscureText : false,
              style: widget.textStyle ?? AppTextStyle.textFormStyle,
              autovalidateMode:
                  widget.autovalidateMode ?? AutovalidateMode.onUserInteraction,
              maxLines: widget.maxLines,
              cursorColor: widget.focusColor ?? AppColor.mainAppColor,
              inputFormatters: widget.inputFormatters,
              maxLength: widget.maxLength,
              textAlign: widget.textAlign,
              decoration: InputDecoration(
                label: widget.label,
                labelText: widget.labelText,
                labelStyle: AppTextStyle.labelStyle,
                hintMaxLines: 2,
                hintText: widget.hintText,
                hintStyle: widget.hintStyle ?? AppTextStyle.hintStyle,
                fillColor: widget.fillColor ??
                    (widget.formFieldBorder == FormFieldBorder.underLine
                        ? Colors.transparent
                        : AppColor.textFormFillColor),
                filled: true,
                border: _border(
                  color: widget.unFocusColor ?? AppColor.textFormBorderColor,
                ),
                disabledBorder: _border(
                  color: widget.unFocusColor ?? AppColor.textFormBorderColor,
                ),
                focusedBorder: _border(
                  color: widget.unFocusColor ?? AppColor.mainAppColor,
                ),
                enabledBorder: _border(
                  color: widget.unFocusColor ?? AppColor.textFormBorderColor,
                ),
                errorBorder: _border(color: Colors.red.shade700),
                focusedErrorBorder: _border(color: Colors.red.shade700),
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 10,
                ),
                prefixIcon: widget.country != null &&
                        context.locale == const Locale('en')
                    ? Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          widget.prefixIconSvg != null
                              ? Container(
                                  width: 45,
                                  height: 47,
                                  margin: const EdgeInsets.all(1),
                                  clipBehavior: Clip.antiAlias,
                                  decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadiusDirectional.horizontal(
                                      start: Radius.circular(widget.radius),
                                    ),
                                  ),
                                  child: Stack(
                                    children: [
                                      PositionedDirectional(
                                        bottom: 0,
                                        top: 0,
                                        start: 0,
                                        end: 2,
                                        child: SvgPrefixIcon(
                                          imagePath: widget.prefixIconSvg!,
                                          color: widget.prefixIconSvgColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : (widget.prefixIcon ?? const SizedBox()),
                          SizedBox(
                            width: 100,
                            child: Center(
                              child: CustomButton(
                                width: 80,
                                height: 32,
                                radius: 4,
                                color: AppColor.textFormBorderColor,
                                onPressed: widget.onCountrySelect != null
                                    ? _select
                                    : null,
                                child: Text(
                                  '${widget.country?.flagEmoji} +${widget.country?.phoneCode}',
                                  style: widget.phonePickStyle ??
                                      AppTextStyle.text14_400.copyWith(
                                        color: AppColor.textSecondaryColor,
                                      ),
                                  textDirection: ui.TextDirection.ltr,
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    : widget.prefixIconSvg != null
                        ? Container(
                            width: 45,
                            height: 47,
                            margin: const EdgeInsets.all(1),
                            clipBehavior: Clip.antiAlias,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadiusDirectional.horizontal(
                                start: Radius.circular(widget.radius),
                              ),
                            ),
                            child: Stack(
                              children: [
                                PositionedDirectional(
                                  bottom: 0,
                                  top: 0,
                                  start: 0,
                                  end: 2,
                                  child: SvgPrefixIcon(
                                    imagePath: widget.prefixIconSvg!,
                                    color: widget.prefixIconSvgColor,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : widget.prefixIcon,
                suffixIcon: widget.country != null &&
                        context.locale == const Locale('ar')
                    ? Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            width: 100,
                            child: Center(
                              child: CustomButton(
                                width: 80,
                                height: 32,
                                radius: 4,
                                color: Colors.transparent,
                                onPressed: widget.onCountrySelect != null
                                    ? _select
                                    : null,
                                child: Text(
                                  '${widget.country?.flagEmoji} +${widget.country?.phoneCode}',
                                  style: widget.phonePickStyle ??
                                      AppTextStyle.text14_400.copyWith(
                                        color: AppColor.textSecondaryColor,
                                      ),
                                  textDirection: ui.TextDirection.ltr,
                                ),
                              ),
                            ),
                          ),
                          widget.suffixIconSvg != null
                              ? Container(
                                  width: 45,
                                  height: 47,
                                  margin: const EdgeInsets.all(1),
                                  clipBehavior: Clip.antiAlias,
                                  decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadiusDirectional.horizontal(
                                      end: Radius.circular(widget.radius),
                                    ),
                                  ),
                                  child: Stack(
                                    children: [
                                      PositionedDirectional(
                                        bottom: 0,
                                        top: 0,
                                        start: 0,
                                        end: 2,
                                        child: SvgPrefixIcon(
                                          imagePath: widget.suffixIconSvg!,
                                          color: widget.suffixIconSvgColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : (widget.suffixIcon ?? const SizedBox()),
                        ],
                      )
                    : widget.isPassword
                        ? InkWell(
                            onTap: () {
                              setState(() {
                                _obscureText = !_obscureText;
                              });
                            },
                            child: Icon(
                              _obscureText
                                  ? Icons.visibility_off_rounded
                                  : Icons.visibility_rounded,
                              size: 20,
                              color: widget.passwordColor ?? AppColor.hintColor,
                            ),
                          )
                        : widget.suffixIconSvg != null
                            ? Container(
                                width: 45,
                                height: 47,
                                margin: const EdgeInsets.all(1),
                                clipBehavior: Clip.antiAlias,
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadiusDirectional.horizontal(
                                    end: Radius.circular(widget.radius),
                                  ),
                                ),
                                child: Stack(
                                  children: [
                                    PositionedDirectional(
                                      bottom: 0,
                                      top: 0,
                                      start: 0,
                                      end: 2,
                                      child: SvgPrefixIcon(
                                        imagePath: widget.suffixIconSvg!,
                                        color: widget.suffixIconSvgColor,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : widget.suffixIcon,
              ),
            ),
          ),
        ],
      ),
    );
  }

  InputBorder _border({required Color color}) {
    switch (widget.formFieldBorder) {
      case FormFieldBorder.outLine:
        return OutlineInputBorder(
          borderRadius: BorderRadius.circular(widget.radius),
          borderSide: BorderSide(color: color),
        );
      case FormFieldBorder.underLine:
        return UnderlineInputBorder(
          borderRadius: BorderRadius.circular(0),
          borderSide: BorderSide(color: color),
        );
      case FormFieldBorder.none:
        return InputBorder.none;
    }
  }

  void _select() {
    CountryCodeMethods.pickCountry(
      onSelect: (v) {
        widget.onCountrySelect?.call(v);
      },
      context: context,
    );
  }
}
