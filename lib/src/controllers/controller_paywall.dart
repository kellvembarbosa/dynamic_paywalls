import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

import '../../dynamic_paywalls.dart';

class PaywallService extends GetxService {
  final _configPaywall = ConfigPaywall(
    layoutPaywall: LayoutPaywall(
      model: "one_product",
      args: {},
    ),
  ).obs;

  final _offerings = Rx<Offerings?>(null);

  final _isLoading = false.obs;
  final isPremiumUserListen = false.obs;
  final _operationStatus = false.obs;

  late final GetStorage box;

  Offerings? get offerings => _offerings.value;

  bool get isLoading => _isLoading.value;
  set isLoading(bool value) => _isLoading.value = value;

  bool get isPremiumUser => box.read("isPremiumUser") ?? false;
  set isPremiumUser(bool value) => (isPremiumUserListen.value = value, box.write("isPremiumUser", value));

  bool get operationStatus => _operationStatus.value;
  set operationStatus(bool value) => _operationStatus.value = value;

  ConfigPaywall get configPaywall => _configPaywall.value;
  set configPaywall(ConfigPaywall value) => _configPaywall.value = value;

  setOfferings(Offerings? value) => _offerings.value = value;

  Future<PaywallService> init() async {
    box = GetStorage("dynamic_paywalls");
    box.writeIfNull("isPremiumUser", false);

    configPaywall = loadingLayout;

    return this;
  }
}
