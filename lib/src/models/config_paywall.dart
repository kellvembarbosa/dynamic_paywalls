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

  factory ConfigPaywall.fromJson(Map<String, dynamic> json, {Function? onPaywallClose}) {
    return ConfigPaywall(
      isHardPaywall: json['is_hard_paywall'] ?? false,
      showCloseAfterSeconds: json['show_close_after_seconds'] ?? 0,
      layoutPaywall: LayoutPaywall.fromJson(
        json['layout_paywall'],
      ),
      onPaywallClose: onPaywallClose ?? _defaultOnPaywallClose,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'is_hard_paywall': isHardPaywall,
      'show_close_after_seconds': showCloseAfterSeconds,
      'layout_paywall': layoutPaywall.toJson(),
    };
  }
}
