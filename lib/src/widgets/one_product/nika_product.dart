import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dynamic_paywalls/dynamic_paywalls.dart';
import 'package:dynamic_paywalls/src/extensions.dart';
import 'package:dynamic_paywalls/src/widgets/widgets/btn_close_one.dart';
import 'package:dynamic_paywalls/src/widgets/widgets/social_proof_stars.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:styled_widget/styled_widget.dart';

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
    setMetadata(widget.configPaywall.layoutPaywall.args);

    _timer = Timer(Duration(seconds: getMetadataInt("show_btn_close_timer", 0)), () {
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
        CachedNetworkImage(
          imageUrl: getMetadataString("image", "https://picsum.photos/1200/600"),
          width: width,
          height: height,
          fit: BoxFit.cover,
        ),
        SizedBox(
          height: height,
          width: width,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              BtnCloseOneWidget(
                showBtnCloseTimer: showBtnCloseTimer,
                btnCloseColor: HexColor(getMetadataString("btn_close_color", "#000000")),
                onPaywallClose: widget.configPaywall.onPaywallClose,
              ),
              const Spacer(),
              SizedBox(
                width: width,
                child: <Widget>[
                  SocialProofStarsWidget({
                    "rating": getMetadataDouble("rating", 4.5),
                    "starColor": getMetadataString("star_color", "#FFC107"),
                  }),
                  Text(
                    getMetadataString("title", "Unleash creativity \nwith PREMIUM \nexperience").toString().replaceVariablesProduct(product: null),
                  ).fontSize(28).fontWeight(FontWeight.w900),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.king_bed, color: Colors.yellow),
                      const SizedBox(width: 8),
                      Text(getMetadataString("subheadline", "What PREMIUM users get").toString().replaceVariablesProduct(product: null))
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
                        Text(getMetadataString("btn_text", "Start Free Trial").toString().replaceVariablesProduct(product: null))
                            .fontSize(getMetadataDouble("btn_text_size", 16.0))
                            .textColor(HexColor(getMetadataString("btn_text_color", "#ffffff")))
                            .fontWeight(FontWeight.w600),
                        Text(getMetadataString("btn_secondary_text", "#ffffff").toString().replaceVariablesProduct(product: null))
                            .fontSize(getMetadataDouble("btn_secondary_text_size", 10.0))
                            .textColor(HexColor(getMetadataString("btn_secondary_text_color", "#ffffff"))),
                      ],
                    ),
                  ).width(width * 0.8).padding(vertical: 12).backgroundColor(Colors.blue).clipRRect(all: 12).gestures(
                    onTap: () async {
                      debugPrint("Button tapped");
                      //await Paywalls.purchase(data["product_id"], widget.configPaywall.onPaywallClose);
                    },
                  ).center(),
                  <Widget>[
                    const Text("Privacy")
                        .textStyle(
                          const TextStyle(
                            decoration: TextDecoration.underline,
                          ),
                        )
                        .fontSize(12)
                        .gestures(
                          onTap: () => {paywallListener?.onPrivacy.call()},
                        ),
                    const SizedBox(width: 4),
                    const Text("and").fontSize(12).fontWeight(FontWeight.w300),
                    const SizedBox(width: 4),
                    const Text("Terms").textStyle(const TextStyle(decoration: TextDecoration.underline)).fontSize(12).gestures(
                          onTap: () => {paywallListener?.onTerms.call()},
                        ),
                  ]
                      .toRow(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                      )
                      .opacity(0.5)
                      .padding(vertical: 12)
                      .safeArea(bottom: true, top: false),
                ]
                    .toColumn(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                    )
                    .padding(
                      left: 32,
                      right: 32,
                    ),
              )
                  .backgroundColor(
                    HexColor(
                      getMetadataString("purchase_drawer_background_color", "#ffffff"),
                    ),
                  )
                  .clipRRect(
                    topLeft: getMetadataDouble("purchase_drawer_corner_radius", 32.0), //data["purchaseDrawerCornerRadius"],
                    topRight: getMetadataDouble("purchase_drawer_corner_radius", 32.0),
                  ),
            ],
          ),
        ),
      ],
    );
  }
}
