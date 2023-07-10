import 'package:flutter/material.dart';
import 'package:qonversion_flutter/qonversion_flutter.dart';

mixin BaseLayoutMixin<T extends StatefulWidget> on State<T> {
  Map<String, dynamic> data = <String, dynamic>{};
  Map<String, QProduct> products = <String, QProduct>{};
  bool showBtnCloseTimer = false;
  int selectedProduct = 0;

  void setData(Map<String, dynamic> newData) {
    setState(() {
      data = data..addAll(newData);
    });
  }

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

  void setProducts(Map<String, QProduct> products) {
    setState(() {
      this.products = products;
    });
  }
}
