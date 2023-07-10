import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../dynamic_paywalls.dart';

class PaywallService extends GetxService {
  final _configPaywall = ConfigPaywall(
    layoutPaywall: LayoutPaywall(
      model: "one_product",
      args: {},
    ),
  ).obs;

  final Map<String, QProduct> _products = <String, QProduct>{}.obs;

  final _isLoading = false.obs;
  final isPremiumUserListen = false.obs;
  final _qRemoteConfig = Rxn<QRemoteConfig>();
  final _operationStatus = false.obs;

  late final GetStorage box;

  Map<String, QProduct> get products => _products;
  set products(Map<String, QProduct> value) => {_products.clear(), _products.addAll(value)};

  bool get isLoading => _isLoading.value;
  set isLoading(bool value) => _isLoading.value = value;

  bool get isPremiumUser => box.read("isPremiumUser") ?? false;
  set isPremiumUser(bool value) => (isPremiumUserListen.value = value, box.write("isPremiumUser", value));

  bool get operationStatus => _operationStatus.value;
  set operationStatus(bool value) => _operationStatus.value = value;

  ConfigPaywall get configPaywall => _configPaywall.value;
  set configPaywall(ConfigPaywall value) => _configPaywall.value = value;

  QRemoteConfig? get qRemoteConfig => _qRemoteConfig.value;

  setQRemoteConfig(ConfigPaywall payload) {
    //final payload = jsonDecode(box.read("remoteConfig"));
    configPaywall = payload;
  }

  Future<PaywallService> init() async {
    box = GetStorage("dynamic_paywalls");
    box.writeIfNull("isPremiumUser", false);

    configPaywall = loadingLayout;

    return this;
  }
}
