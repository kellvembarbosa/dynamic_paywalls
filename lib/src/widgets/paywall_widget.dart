import 'package:dynamic_paywalls/src/controllers/controller_paywall.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Paywall extends StatelessWidget {
  final PaywallService paywallService = Get.find();

  Paywall({super.key});

  @override
  Widget build(BuildContext context) {
    return paywallService.widgetData == null
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : paywallService.widgetData!.build(context: context);
  }
}
