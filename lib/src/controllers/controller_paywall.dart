import 'dart:convert';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:json_dynamic_widget/json_dynamic_widget.dart';

import '../../dynamic_paywalls.dart';

class PaywallService extends GetxService {
  final _isLoading = false.obs;
  final _isPremiumUser = false.obs;
  final registry = JsonWidgetRegistry.instance;
  final widget = Rxn<JsonWidgetData?>();
  final _qRemoteConfig = Rxn<QRemoteConfig>();

  final Map loadingData = {
    "type": "scaffold",
    "args": {
      "body": {
        "type": "center",
        "child": {"type": "circular_progress_indicator"}
      }
    }
  };
  late final GetStorage box;

  bool get isLoading => _isLoading.value;
  set isLoading(bool value) => _isLoading.value = value;

  bool get isPremiumUser => _isPremiumUser.value;
  set isPremiumUser(bool value) => _isPremiumUser.value = value;

  JsonWidgetData? get widgetData => widget.value;
  set widgetData(JsonWidgetData? value) => widget.value = value;

  QRemoteConfig? get qRemoteConfig => _qRemoteConfig.value;

  setQRemoteConfig() {
    final payload = jsonDecode(box.read("remoteConfig"));

    if (payload != null && payload.toString() != "{}") {
      isLoading = false;
      widgetData = JsonWidgetData.fromDynamic(payload);
    } else {
      isLoading = false;
      widgetData = JsonWidgetData.fromDynamic(loadingData);
    }
  }

  Future<PaywallService> init() async {
    box = GetStorage("dynamic_paywalls");

    box.writeIfNull("remoteConfig", "{}");
    widgetData = JsonWidgetData.fromDynamic(loadingData);

    return this;
  }
}
