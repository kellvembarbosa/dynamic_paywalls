import 'package:animate_do/animate_do.dart';
import 'package:dynamic_paywalls/dynamic_paywalls.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:styled_widget/styled_widget.dart';

class BtnCloseOneWidget extends StatelessWidget {
  final bool showBtnCloseTimer;
  final Color btnCloseColor;
  final Function onPaywallClose;

  const BtnCloseOneWidget({super.key, this.showBtnCloseTimer = false, this.btnCloseColor = Colors.white, required this.onPaywallClose});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          showBtnCloseTimer
              ? FadeIn(
                  child: IconButton(
                    onPressed: () {
                      Get.back();
                    },
                    icon: Icon(Icons.close, color: btnCloseColor),
                  ),
                )
              : const SizedBox.shrink(),
          const Spacer(),
          const Text("Restore").fontSize(16).fontWeight(FontWeight.w400).textColor(btnCloseColor).gestures(
            onTap: () async {
              debugPrint("Restore tapped");
              final result = await Paywalls.restorePurchases();

              if (result) {
                debugPrint("Restore success");
                Get.snackbar("Success".tr, "Purchase restored".tr);
                onPaywallClose.call();
              } else {
                debugPrint("Restore failed");
                Get.snackbar("Not found".tr, "Purchase not found".tr);
              }
            },
          ).padding(bottom: 4),
        ],
      ).padding(horizontal: 12).safeArea(top: true),
    );
  }
}
