import 'package:flutter/material.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import '../widgets/listener.dart';

mixin BaseLayoutMixin<T extends StatefulWidget> on State<T> {
  Map<String, Object> metadata = <String, Object>{};
  PaywallListener? paywallListener;
  Package? package;
  bool showBtnCloseTimer = false;
  int selectedProduct = 0;

  void setShowBtnCloseTimer(bool showBtnCloseTimer) {
    setState(() {
      this.showBtnCloseTimer = showBtnCloseTimer;
    });
  }

  void setSelectedProduct(int selectedProduct) {
    setState(() {
      this.selectedProduct = selectedProduct;
    });
  }

  void setPackages(Package package) {
    setState(() {
      this.package = package;
    });
  }

  void setMetadata(Map<String, Object> nMetadata) {
    setState(() {
      this.metadata = metadata..addAll(nMetadata);
    });
  }

  void setPaywallListener(PaywallListener paywallListener) {
    setState(() {
      this.paywallListener = paywallListener;
    });
  }

  String getMetadataString(String key, String defaultValue) {
    final value = metadata[key];
    if (value != null && value is String) {
      return value;
    }
    return defaultValue;
  }

  int getMetadataInt(String key, int defaultValue) {
    final value = metadata[key];
    if (value != null && value is int) {
      return value;
    }
    return defaultValue;
  }

  bool getMetadataBool(String key, bool defaultValue) {
    final value = metadata[key];
    if (value != null && value is bool) {
      return value;
    }
    return defaultValue;
  }

  double getMetadataDouble(String key, double defaultValue) {
    final value = metadata[key];
    if (value != null && value is double) {
      return value;
    }
    return defaultValue;
  }
}
