import 'package:flutter/material.dart';

import 'layout_paywall.dart';

class ConfigPaywall {
  final bool isHardPaywall;
  final int showCloseAfterSeconds;
  final LayoutPaywall layoutPaywall;
  final Function onPaywallClose;

  ConfigPaywall({
    this.isHardPaywall = false,
    this.showCloseAfterSeconds = 0,
    required this.layoutPaywall,
    this.onPaywallClose = _defaultOnPaywallClose,
  });

  static void _defaultOnPaywallClose() {
    debugPrint("Paywall closed");
  }
}
