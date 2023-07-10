import 'package:dynamic_paywalls/src/controllers/controller_paywall.dart';
import 'package:dynamic_paywalls/src/models/config_paywall.dart';
import 'package:dynamic_paywalls/src/widgets/mulitple_products/juliet_layout.dart';
import 'package:dynamic_paywalls/src/widgets/one_product/nika_product.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:styled_widget/styled_widget.dart';

import 'loading.dart';

class Paywall extends StatelessWidget {
  Paywall({super.key});

  final PaywallService paywallService = Get.find();

  Widget _buildWidget(ConfigPaywall configPaywall) {
    switch (configPaywall.layoutPaywall.model) {
      case "nika_paywall":
        return NikaLayout(
          configPaywall: configPaywall,
        );
      case "juliet_paywall":
        return JulietLayout(
          configPaywall: configPaywall,
        );
      default:
        return const LoadingWidget().center().backgroundColor(Colors.black12);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(
        () => Stack(
          children: [
            _buildWidget(paywallService.configPaywall),
            paywallService.isLoading ? const LoadingWidget().center().backgroundColor(Colors.black26).backgroundBlur(10) : const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}
