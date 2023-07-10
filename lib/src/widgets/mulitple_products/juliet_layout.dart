import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:collection/collection.dart';
import 'package:dynamic_paywalls/src/extensions.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:styled_widget/styled_widget.dart';

import '../../../dynamic_paywalls.dart';
import '../widgets/btn_close_one.dart';
import '../mixin_base_layout.dart';

class JulietLayout extends StatefulWidget {
  final ConfigPaywall configPaywall;
  const JulietLayout({super.key, required this.configPaywall});

  @override
  State<JulietLayout> createState() => _JulietLayoutState();
}

class _JulietLayoutState extends State<JulietLayout> with BaseLayoutMixin {
  Timer? _timer;

  @override
  void initState() {
    super.initState();

    setProducts(Paywalls.paywallService.products);

    setData({
      "show_btn_close_timer": 5,
      "image": "https://static.superwallassets.com/ROsrEZCqyFlDhdm0pKdx7",
      "title": "Unlock",
      "spanTitle": "PREMIUM",
      "features": [
        {
          "checkmark_icon": "https://static.superwallassets.com/irOfTUnCBvFja-0cw_xsu",
          "title": "Unlimited access to all features",
        },
        {
          "checkmark_icon": "https://static.superwallassets.com/irOfTUnCBvFja-0cw_xsu",
          "title": "Unlock all templates",
        },
        {
          "checkmark_icon": "https://static.superwallassets.com/irOfTUnCBvFja-0cw_xsu",
          "title": "Unlock all fonts",
        },
        {
          "checkmark_icon": "https://static.superwallassets.com/irOfTUnCBvFja-0cw_xsu",
          "title": "Unlock all stickers",
        }
      ],
      "products": [
        {
          "product_id": "id.newipe.weekly",
          "title": "@price / @period",
          "subtitle": "7-days Free Trial, Auto-Renewable",
        },
        {
          "product_id": "id.newipe.lifetime",
          "title": "@price / @period",
          "subtitle": "Billed Yearly",
        }
      ],
      "cta_btn": [
        "Start free Trial&Plan",
        "Free 3-day trial",
      ],
      "btnText": "Start free trial",
      "btnSecondaryText": "Free 3-day trial, then @price/@period",
      "openTermsLink": "https://help.knksolutions.pt/newipe-eula/",
      "openPrivacyLink": "https://help.knksolutions.pt/newipe-privacy/",
      "stylePaywall": {
        "starColor": "#FFC107",
        "backgroundColor": "#ffffff",
        "titleColor": "#000000",
        "featuredColor": "#000000",
        "borderProductColor": "#000000",
        "btnProductTitleColor": "#000000",
        "btnProductTitleTextFontSize": 18.0,
        "btnProductSubtitleColor": "#3c3c3c",
        "btnProductSubtitleTextFontSize": 12.0,
        "btnTextColor": "#ffffff",
        "btnColor": "#ffada1",
        "btnCloseColor": "#000000",
        "btnCTATextFontSize": 16.0,
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
    _timer?.cancel(); // cancela a Future quando o widget é desmontado
  }

  Widget _buildItemList(String icon, String title) {
    return <Widget>[
      CachedNetworkImage(imageUrl: icon, height: 18, width: 18, fit: BoxFit.contain),
      const SizedBox(width: 8),
      Text(title).fontSize(14).fontWeight(FontWeight.bold).textColor(HexColor(data["stylePaywall"]["featuredColor"])),
    ]
        .toRow(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
        )
        .padding(
          horizontal: 16,
        )
        .padding(bottom: 4);
  }

  Widget _buildProductItem(int index, String productId, String title, String subtitle) {
    final product = products[productId];
    return Padding(
      padding: const EdgeInsets.only(right: 16.0, left: 16.0, bottom: 8.0),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          border: Border.all(
            color: HexColor(data["stylePaywall"]["borderProductColor"]),
            width: 2,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: <Widget>[
          Text(subtitle.replaceVariablesProduct(product: product))
              .textColor(HexColor(data["stylePaywall"]["btnProductSubtitleColor"]))
              .fontSize(data["stylePaywall"]["btnProductSubtitleTextFontSize"])
              .fontWeight(FontWeight.normal)
              .textAlignment(TextAlign.start),
          Text(title.replaceVariablesProduct(product: product))
              .textColor(HexColor(data["stylePaywall"]["btnProductTitleColor"]))
              .fontSize(data["stylePaywall"]["btnProductTitleTextFontSize"])
              .fontWeight(FontWeight.bold)
              .textAlignment(TextAlign.start),
        ]
            .toColumn(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
            )
            .padding(
              horizontal: 16,
              vertical: 8,
            ),
      ).opacity(selectedProduct == index ? 1 : 0.3).gestures(
        onTap: () {
          setState(
            () {
              selectedProduct = index;
            },
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return <Widget>[
      Column(
        children: [
          Expanded(
            child: CachedNetworkImage(
              imageUrl: data["image"],
              width: width,
              fit: BoxFit.cover,
            ),
          ),
          <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  data["title"],
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.normal,
                    color: HexColor(data["stylePaywall"]["titleColor"]),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(width: 8),
                Text(
                  data["spanTitle"],
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w900,
                    color: HexColor(data["stylePaywall"]["titleColor"]),
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            const SizedBox(height: 12),
            (data["features"] as List).map((item) => _buildItemList(item["checkmark_icon"], item["title"])).toList().toColumn(),
            const SizedBox(height: 16),
            (data["products"] as List)
                .mapIndexed((index, item) => _buildProductItem(index, item["product_id"], item["title"], item["subtitle"]))
                .toList()
                .toColumn(),
            const SizedBox(height: 16),
            Text(
              data["cta_btn"][selectedProduct],
              style: TextStyle(
                fontSize: data["stylePaywall"]["btnCTATextFontSize"],
                fontWeight: FontWeight.bold,
                color: HexColor(data["stylePaywall"]["btnTextColor"]),
              ),
              textAlign: TextAlign.center,
            )
                .padding(vertical: 16)
                .gestures(
                  onTap: () async {
                    await Paywalls.purchase(data["products"][selectedProduct]["product_id"], widget.configPaywall.onPaywallClose);
                  },
                )
                .width(double.infinity)
                .decorated(
                  color: HexColor(data["stylePaywall"]["btnColor"]),
                  borderRadius: BorderRadius.circular(8),
                )
                .padding(horizontal: 16),
          ].toColumn().padding(bottom: 16).safeArea(bottom: true, top: false),
        ],
      ),
      <Widget>[
        BtnCloseOneWidget(
          showBtnCloseTimer: showBtnCloseTimer,
          btnCloseColor: HexColor(data["stylePaywall"]["btnCloseColor"]),
          onPaywallClose: widget.configPaywall.onPaywallClose,
        ),
      ].toColumn().safeArea(top: true),
    ].toStack().backgroundColor(HexColor(data["stylePaywall"]["backgroundColor"]));
  }
}
