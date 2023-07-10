import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dynamic_paywalls/dynamic_paywalls.dart';
import 'package:dynamic_paywalls/src/extensions.dart';
import 'package:dynamic_paywalls/src/widgets/widgets/btn_close_one.dart';
import 'package:dynamic_paywalls/src/widgets/widgets/social_proof_stars.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:url_launcher/url_launcher.dart';

import '../mixin_base_layout.dart';

class NikaLayout extends StatefulWidget {
  final ConfigPaywall configPaywall;
  const NikaLayout({super.key, required this.configPaywall});

  @override
  State<NikaLayout> createState() => _NikaLayoutState();
}

class _NikaLayoutState extends State<NikaLayout> with BaseLayoutMixin {
  Timer? _timer;

  @override
  void initState() {
    super.initState();

    setData({
      "show_btn_close_timer": 5,
      "image": "https://picsum.photos/1200/600",
      "rating": 4.5,
      "title": "Unleash creativity \nwith PREMIUM \nexperience",
      "subheadline": "What PREMIUM users get",
      "product_id": "id.newipe.lifetime",
      "btnText": "Start free trial",
      "btnSecondaryText": "Free 3-day trial, then @price/@period",
      "openTermsLink": "https://help.knksolutions.pt/newipe-eula/",
      "openPrivacyLink": "https://help.knksolutions.pt/newipe-privacy/",
      "stylePaywall": {
        "starColor": "#FFC107",
        "backgroundColor": "#ffffff",
        "titleColor": "#000000",
        "descriptionColor": "#000000",
        "priceColor": "#000000",
        "btnBackground": "#FFC107",
        "btnTextColor": "#ffffff",
        "btnTextSize": 16.0,
        "btnSecondaryTextColor": "#ffffff",
        "btnSecondaryTextSize": 10.0,
        "purchaseDrawerBackgroundColor": "#ffffff",
        "purchaseDrawerCornerRadius": 32.0,
        "btnCloseColor": "#000000",
      }
    });

    setData(widget.configPaywall.layoutPaywall.args);

    _timer = Timer(Duration(seconds: data["show_btn_close_timer"]), () {
      if (mounted) {
        setShowBtnCloseTimer(true);
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Stack(
      children: [
        Expanded(
          child: CachedNetworkImage(
            imageUrl: data["image"],
            width: width,
            height: double.infinity,
            fit: BoxFit.cover,
          ),
        ),
        SizedBox(
          height: height,
          width: width,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              BtnCloseOneWidget(
                showBtnCloseTimer: showBtnCloseTimer,
                btnCloseColor: HexColor(data["stylePaywall"]["btnCloseColor"]),
              ),
              const Spacer(),
              SizedBox(
                width: width,
                child: <Widget>[
                  SocialProofStarsWidget({
                    "rating": data["rating"],
                    "starColor": data["stylePaywall"]["starColor"],
                  }),
                  Text(
                    data["title"].toString().replaceVariablesProduct(product: products[data["product_id"]]),
                  ).fontSize(28).fontWeight(FontWeight.w900),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.king_bed, color: Colors.yellow),
                      const SizedBox(width: 8),
                      Text(data["subheadline"].toString().replaceVariablesProduct(product: products[data["product_id"]]))
                          .fontSize(16)
                          .fontWeight(FontWeight.w600),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Styled.widget(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(data["btnText"].toString().replaceVariablesProduct(product: products[data["product_id"]]))
                            .fontSize(data["stylePaywall"]["btnTextSize"])
                            .textColor(HexColor(data["stylePaywall"]["btnTextColor"]))
                            .fontWeight(FontWeight.w600),
                        Text(data["btnSecondaryText"].toString().replaceVariablesProduct(product: products[data["product_id"]]))
                            .fontSize(data["stylePaywall"]["btnSecondaryTextSize"])
                            .textColor(HexColor(data["stylePaywall"]["btnSecondaryTextColor"])),
                      ],
                    ),
                  ).width(width * 0.8).padding(vertical: 12).backgroundColor(Colors.blue).clipRRect(all: 12).gestures(
                    onTap: () async {
                      debugPrint("Button tapped");
                      await Paywalls.purchase(data["product_id"]);
                    },
                  ).center(),
                  <Widget>[
                    const Text("Privacy").textStyle(const TextStyle(decoration: TextDecoration.underline)).fontSize(12).gestures(
                          onTap: () => _launchUrl(Uri.parse(data["openPrivacyLink"])),
                        ),
                    const SizedBox(width: 4),
                    const Text("and").fontSize(12).fontWeight(FontWeight.w300),
                    const SizedBox(width: 4),
                    const Text("Terms").textStyle(const TextStyle(decoration: TextDecoration.underline)).fontSize(12).gestures(
                          onTap: () => _launchUrl(Uri.parse(data["openTermsLink"])),
                        ),
                  ]
                      .toRow(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                      )
                      .opacity(0.5)
                      .padding(bottom: 12)
                      .safeArea(bottom: true, top: false),
                ].toColumn(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.start).padding(
                      left: 32,
                      right: 32,
                    ),
              ).backgroundColor(HexColor(data["stylePaywall"]["purchaseDrawerBackgroundColor"])).clipRRect(
                    topLeft: data["stylePaywall"]["purchaseDrawerCornerRadius"],
                    topRight: data["stylePaywall"]["purchaseDrawerCornerRadius"],
                  ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _launchUrl(Uri url) async {
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }
}
