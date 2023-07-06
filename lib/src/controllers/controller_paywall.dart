import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:json_dynamic_widget/json_dynamic_widget.dart';

import '../../dynamic_paywalls.dart';

class PaywallService extends GetxService {
  final _isLoading = false.obs;
  final _isPremiumUser = false.obs;
  final registry = JsonWidgetRegistry.instance;
  final widget = Rxn<JsonWidgetData?>();
  final _qRemoteConfig = Rxn<QRemoteConfig>();

  late final Map loadingData;

  bool get isLoading => _isLoading.value;
  set isLoading(bool value) => _isLoading.value = value;

  bool get isPremiumUser => _isPremiumUser.value;
  set isPremiumUser(bool value) => _isPremiumUser.value = value;

  JsonWidgetData? get widgetData => widget.value;
  set widgetData(JsonWidgetData? value) => widget.value = value;

  QRemoteConfig? get qRemoteConfig => _qRemoteConfig.value;

  setQRemoteConfig(QRemoteConfig? value) {
    _qRemoteConfig.value = value;

    debugPrint("QRemote Experiment : ${jsonEncode(value?.experiment)}");
    debugPrint("QRemote Experiment name : ${jsonEncode(value?.experiment?.name)}");
    debugPrint("QRemote Experiment id : ${jsonEncode(value?.experiment?.id)}");
    debugPrint("QRemote Experiment Group ID: ${jsonEncode(value?.experiment?.group.id)}");
    debugPrint("QRemote Experiment Group  Name: ${jsonEncode(value?.experiment?.group.name)}");
    debugPrint("QRemote Experiment Group  Type: ${jsonEncode(value?.experiment?.group.type)}");

    debugPrint("QRemote Config: ${jsonEncode(value?.payload)}");

    if (value != null) {
      widgetData = JsonWidgetData.fromDynamic(value.payload, registry: registry);
    }
  }

  Future<PaywallService> init() async {
    loadingData = {
      "type": "scaffold",
      "args": {
        "body": {
          "type": "center",
          "child": {"type": "circular_progress_indicator"}
        }
      }
    };

    widgetData = JsonWidgetData.fromDynamic(loadingData);

    return this;
  }
}
