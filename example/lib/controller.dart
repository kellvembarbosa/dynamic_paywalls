import 'package:dynamic_paywalls/dynamic_paywalls.dart';
import 'package:get/get.dart';

class DesignController extends GetxController {
  final _isDesignMode = false.obs;
  final _paywallLayout = Rxn<ConfigPaywall>(
    ConfigPaywall(
      layoutPaywall: LayoutPaywall(
        model: PaywallModel.nika,
        args: {},
      ),
    ),
  );

  bool get isDesignMode => _isDesignMode.value;
  set isDesignMode(bool value) => _isDesignMode.value = value;

  ConfigPaywall? get paywallLayout => _paywallLayout.value;
  set paywallLayout(ConfigPaywall? value) => _paywallLayout.value = value;
}
