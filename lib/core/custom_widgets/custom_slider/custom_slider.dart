import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hawiah_client/core/theme/app_colors.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../custom_image/custom_network_image.dart';

class SliderArguments {
  String? url;
  Widget? child;
  void Function()? onTap;
  SliderArguments({this.url, this.child, this.onTap});
}

class CustomSlider extends StatefulWidget {
  final List<SliderArguments> sliderArguments;

  final bool autoPlay;
  final bool hasDots;
  final bool dotsTopOfChild;
  final bool isDotsOnContent;
  final bool hasZoom;
  final double aspectRatio;
  final double radius;
  final double? sliderWidth;
  final double? sliderHeight;
  final BoxFit fit;
  final bool hasShare;
  final Color? backgroundColor;

  const CustomSlider({
    super.key,
    required this.sliderArguments,
    this.autoPlay = true,
    this.hasDots = true,
    this.dotsTopOfChild = true,
    this.isDotsOnContent = true,
    this.hasZoom = false,
    this.aspectRatio = 333 / 158,
    this.radius = 12,
    this.fit = BoxFit.cover,
    this.hasShare = false,
    this.sliderWidth,
    this.sliderHeight,
    this.backgroundColor,
  });

  @override
  State<CustomSlider> createState() => _CustomSliderState();
}

class _CustomSliderState extends State<CustomSlider> {
  int _index = 0;
  late CarouselSliderController _carouselController;
  @override
  void initState() {
    _carouselController = CarouselSliderController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Stack(
          children: [
            CarouselSlider(
              carouselController: _carouselController,
              items: widget.sliderArguments.map((item) {
                return GestureDetector(
                  onTap: item.onTap,
                  child: Container(
                    width: widget.sliderWidth ?? double.infinity,
                    margin: EdgeInsets.only(
                      bottom: widget.isDotsOnContent ? 0.0 : 20.0,
                    ),
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      color: widget.backgroundColor ?? AppColor.whiteColor,
                      borderRadius: BorderRadius.circular(widget.radius),
                    ),
                    child: item.child ??
                        Stack(
                          children: [
                            CustomNetworkImage(
                              hasZoom: widget.hasZoom,
                              radius: widget.radius,
                              imageUrl: item.url!,
                              width: widget.sliderWidth ?? double.infinity,
                              height: 190,
                              fit: widget.fit,
                            ),
                          ],
                        ),
                  ),
                );
              }).toList(),
              options: CarouselOptions(
                aspectRatio: widget.aspectRatio,
                autoPlayAnimationDuration: const Duration(seconds: 2),
                autoPlay: widget.autoPlay,
                height: widget.sliderHeight ?? 190,
                enlargeCenterPage: true,
                viewportFraction: 1,
                onPageChanged: (i, _) {
                  setState(() {
                    _index = i;
                  });
                },
              ),
            ),
            if (widget.hasDots && widget.dotsTopOfChild) ...{
              Positioned(
                bottom: 7,
                right: 0,
                left: 0,
                child: Center(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: AnimatedSmoothIndicator(
                      activeIndex: _index,
                      count: widget.sliderArguments.isEmpty ? 1 : widget.sliderArguments.length,
                      effect: ExpandingDotsEffect(
                        dotColor: AppColor.greyColor,
                        activeDotColor: AppColor.mainAppColor,
                        dotHeight: 7,
                        dotWidth: 7,
                      ),
                      onDotClicked: (i) {
                        _carouselController.animateToPage(i);
                      },
                    ),
                  ),
                ),
              ),
            },
          ],
        ),
        if (widget.hasDots && !widget.dotsTopOfChild) ...[
          const Gap(10),
          Center(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: AnimatedSmoothIndicator(
                activeIndex: _index,
                count: widget.sliderArguments.length,
                effect: ExpandingDotsEffect(
                  dotColor: AppColor.greyColor,
                  activeDotColor: AppColor.mainAppColor,
                  dotHeight: 7,
                  dotWidth: 7,
                ),
                onDotClicked: (i) {
                  _carouselController.animateToPage(i);
                },
              ),
            ),
          ),
        ],
      ],
    );
  }
}
