import 'package:cached_network_image/cached_network_image.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:styled_widget/styled_widget.dart';

import 'mixin_base_onboarding.dart';

class DefaultOnboarding extends StatefulWidget {
  final int currentStep;
  final List<OnboardingItem> items;
  final List<String> btnTexts;
  final Map<String, dynamic> data;
  final Function? onDonePressed;
  const DefaultOnboarding({
    super.key,
    this.currentStep = 0,
    required this.items,
    required this.btnTexts,
    required this.onDonePressed,
    this.data = const {},
  }) : assert(items.length == btnTexts.length, "items and btnTexts must have the same length");

  @override
  State<DefaultOnboarding> createState() => _DefaultOnboardingState();
}

class _DefaultOnboardingState extends State<DefaultOnboarding> with BaseOnboardingLayoutMixin {
  @override
  void initState() {
    super.initState();
    setItems(widget.items);
    setBtnTexts(widget.btnTexts);
    setCurrentStep(widget.currentStep);
    setOnDonePressed(widget.onDonePressed);

    // initialize data
    setData({
      "showProgressBar": true,
      "styleOnboarding": {
        "primaryColor": "#ef665a",
        "secondaryColor": "#f9ccc8",
        "accentColor": "#ea3323",
        "backgroundColor": "#fbf2f1",
        "textColor": "#ffffff",
        "textColorSecondary": "#000000",
        "textColorAccent": "#ffffff",
        "buttonTextColor": "#ffffff",
        "buttonTextFontSize": 18.0,
        "ItemTextTitleColor": "#000000",
        "ItemTextSubtitleColor": "#3c3c3c",
        "ItemTextTitleFontSize": 24.0,
        "ItemTextSubtitleFontSize": 18.0,
        "borderRadius": 8.0,
        "contentPaddingHoriontal": 24.0,
      }
    });
    setData(widget.data);
  }

  @override
  Widget build(BuildContext context) {
    final itemCount = children.isEmpty ? items.length : children.length;
    return Scaffold(
      backgroundColor: HexColor(data["styleOnboarding"]["backgroundColor"]),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          data["showProgressBar"]
              ? _ProgressBarIndicator(
                  currentStep: currentStep,
                  totalStep: children.isEmpty ? items.length : children.length,
                  data: data,
                )
              : const SizedBox.shrink(),
          const SizedBox(height: 16),
          _OnboardingItemWidget(
            item: items[currentStep],
            data: data,
          ),
          const SizedBox(height: 16),
          _ButtonNext(
              title: btnTexts[currentStep],
              onPressed: () {
                // crie logicas para quando o botão for clicado se for o ultimo item execute a ação onDone caso contrario setCurrentStep(currentStep + 1)

                debugPrint("currentStep: $currentStep - itemCount: $itemCount - itemCount: ${itemCount - 1} ");
                if (currentStep == itemCount - 1) {
                  onDonePressed?.call();
                } else {
                  setCurrentStep(currentStep + 1);
                }
              },
              data: data)
        ],
      ).paddingSymmetric(vertical: 16).safeArea(),
    );
  }
}

class OnboardingItem {
  final String title;
  final String subtitle;
  final String image;

  const OnboardingItem({required this.title, required this.subtitle, required this.image});
}

class _OnboardingItemWidget extends StatelessWidget {
  final OnboardingItem item;
  final Map<String, dynamic> data;
  const _OnboardingItemWidget({required this.item, required this.data});

  @override
  Widget build(BuildContext context) {
    final styleOnboarding = data["styleOnboarding"];
    final contentPaddingHoriontal = styleOnboarding["contentPaddingHoriontal"];
    final borderRadius = styleOnboarding["borderRadius"];
    final titlecolor = HexColor(styleOnboarding["ItemTextTitleColor"]);
    final subtitleColor = HexColor(styleOnboarding["ItemTextSubtitleColor"]);
    final titleFontSize = styleOnboarding["ItemTextTitleFontSize"];
    final subtitleFontSize = styleOnboarding["ItemTextSubtitleFontSize"];

    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: contentPaddingHoriontal),
      child: Column(
        children: [
          if (item.image.contains("http"))
            CachedNetworkImage(
              imageUrl: item.image,
              width: double.infinity,
              fit: BoxFit.contain,
            ).expanded()
          else
            Image.asset(
              item.image,
              width: double.infinity,
              fit: BoxFit.contain,
            ).expanded().clipRRect(
                  all: borderRadius,
                ),
          Text(
            item.title,
            style: TextStyle(
              color: titlecolor,
              fontSize: titleFontSize,
              fontWeight: FontWeight.w900,
            ),
          ).textAlignment(TextAlign.center),
          Text(
            item.subtitle,
            style: TextStyle(
              color: subtitleColor,
              fontSize: subtitleFontSize,
              fontWeight: FontWeight.normal,
            ),
          ).textAlignment(TextAlign.center),
        ],
      ),
    ).expanded();
  }
}

class _ButtonNext extends StatelessWidget {
  final String title;
  final Function onPressed;
  final Map<String, dynamic> data;
  const _ButtonNext({super.key, required this.title, required this.onPressed, required this.data});

  @override
  Widget build(BuildContext context) {
    final styleOnboarding = data["styleOnboarding"];
    final primaryColor = HexColor(styleOnboarding["primaryColor"]);
    final secondaryColor = HexColor(styleOnboarding["secondaryColor"]);
    final accentColor = HexColor(styleOnboarding["accentColor"]);
    final borderRadius = styleOnboarding["borderRadius"];
    final contentPaddingHoriontal = styleOnboarding["contentPaddingHoriontal"];
    final buttonTextColor = styleOnboarding["buttonTextColor"];
    final buttonTextFontSize = styleOnboarding["buttonTextFontSize"];

    // create button with TextButton with width 100%
    return Row(
      children: [
        TextButton(
          onPressed: () => onPressed(),
          style: TextButton.styleFrom(
            backgroundColor: accentColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius),
            ),
            padding: EdgeInsets.symmetric(horizontal: contentPaddingHoriontal, vertical: 16),
          ),
          child: Text(
            title,
            style: TextStyle(
              color: HexColor(buttonTextColor),
              fontSize: buttonTextFontSize,
              fontWeight: FontWeight.bold,
            ),
          ),
        ).paddingSymmetric(horizontal: contentPaddingHoriontal).expanded(),
      ],
    );
  }
}

class _ProgressBarIndicator extends StatelessWidget {
  final int currentStep;
  final int totalStep;
  final Map<String, dynamic> data;
  const _ProgressBarIndicator({required this.currentStep, required this.totalStep, required this.data});

  @override
  Widget build(BuildContext context) {
    final styleOnboarding = data["styleOnboarding"];
    final primaryColor = HexColor(styleOnboarding["primaryColor"]);
    final secondaryColor = HexColor(styleOnboarding["secondaryColor"]);
    final accentColor = HexColor(styleOnboarding["accentColor"]);
    final borderRadius = styleOnboarding["borderRadius"];
    final contentPaddingHoriontal = styleOnboarding["contentPaddingHoriontal"];

    return Container(
      width: double.infinity,
      height: 8,
      margin: EdgeInsets.symmetric(horizontal: contentPaddingHoriontal),
      decoration: BoxDecoration(
        color: secondaryColor,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: Stack(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: (MediaQuery.of(context).size.width / totalStep) * currentStep,
            height: 8,
            decoration: BoxDecoration(
              color: accentColor,
              borderRadius: BorderRadius.circular(borderRadius),
            ),
          ),
        ],
      ),
    );
  }
}
