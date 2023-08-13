import 'dart:io';

import 'package:dynamic_paywalls/dynamic_paywalls.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class Paywalls {
  static late final CustomConfig? _customConfig;
  static late final PaywallService paywallService;
  static late final ConfigPaywall _paywallFallback;
  static bool _isInitialized = false; // Variável para rastrear se o init() já foi chamado

  Paywalls._internal();

  /// Initialize Qonversion SDK
  static init({
    String iOSRevenueCatApiKey = "",
    String androidRevenueCatApiKey = "",
    required String glassfyApiKey,
    bool enableSearchAds = false,
    bool isDesignMode = false,
    CustomConfig? customConfig,
    Function? othersConfigs,
  }) async {
    if (_isInitialized) {
      return; // Retorna se o init() já foi chamado
    }
    _isInitialized = true; // Marca o init() como chamado

    // Inicialize o GetStorage
    await GetStorage.init();

    // Inicialize o singleton
    if (Get.isRegistered<PaywallService>()) {
      paywallService = Get.find();
    } else {
      // Inicialize o singleton aqui, se necessário
      await Get.putAsync(() => PaywallService().init());
      paywallService = Get.find();
    }

    // Start RevenueCat SDK
    late PurchasesConfiguration purchasesConfiguration;
    if (Platform.isAndroid) {
      purchasesConfiguration = PurchasesConfiguration(androidRevenueCatApiKey);
    } else {
      purchasesConfiguration = PurchasesConfiguration(iOSRevenueCatApiKey);
    }

    await Purchases.configure(purchasesConfiguration);

    // Start Glassfy SDK
    await Glassfy.initialize(glassfyApiKey, watcherMode: true);

    // Enable Search Ads
    if (enableSearchAds) {
      Purchases.enableAdServicesAttributionTokenCollection();
    }

    // Custom configs
    _customConfig = customConfig;

    // Others configs
    if (othersConfigs != null) {
      othersConfigs();
    }
  }

  /// Get the paywall widget
  static Widget getPaywall(ConfigPaywall configPaywall, {bool isDesignMode = false, ConfigPaywall? data, required Function onPaywallClose}) {
    //updateRemoteConfigs(isDesignMode: isDesignMode, data: data, onPaywallClose: onPaywallClose);
    paywallService.configPaywall = configPaywall;
    paywallService.isLoading = false;
    return Paywall();
  }

  // get remote configs
  // static updateRemoteConfigs({Function? onPaywallClose, bool isDesignMode = false, ConfigPaywall? data}) async {
  //   debugPrint("updateRemoteConfigs $isDesignMode $data");

  //   if (isDesignMode) {
  //     // paywallService.setQRemoteConfig(data ?? _paywallFallback);
  //     paywallService.setOfferings(null);
  //     paywallService.isLoading = false;
  //     return;
  //   } else {
  //     if (Platform.isAndroid || Platform.isIOS) {
  //       // try {
  //       //   final remoteConfig = await Qonversion.getSharedInstance().remoteConfig();

  //       //   if (remoteConfig.experiment == null || remoteConfig.payload.toString() == "{}") {
  //       //     final paywallRemote = await _paywallConnect.getPaywallRemote(_paywallUrl);

  //       //     paywallService.setQRemoteConfig(ConfigPaywall.fromJson(paywallRemote, onPaywallClose: onPaywallClose));
  //       //   } else {
  //       //     paywallService.setQRemoteConfig(ConfigPaywall.fromJson(remoteConfig.payload, onPaywallClose: onPaywallClose));
  //       //   }
  //       // } catch (e) {
  //       //   debugPrint(e.toString());
  //       //   paywallService.setQRemoteConfig(_paywallFallback);
  //       // }
  //     }
  //   }
  // }

  /// Check if the user is a premium user
  static Future<void> checkPermissions() async {
    try {
      final customerInfo = await Purchases.getCustomerInfo();

      if (customerInfo.entitlements.all["premium"]?.isActive == true) {
        paywallService.isPremiumUser = true;
      } else {
        paywallService.isPremiumUser = false;
      }
    } on PlatformException catch (e) {
      // Error fetching customer info
      debugPrint("Error fetching customer info: $e");
      paywallService.isPremiumUser = false;
    }
  }

  /// Purchase a product
  static Future<void> purchase(Package package, Function onPaywallClose, {Function? showUserCancel}) async {
    paywallService.isLoading = true;
    try {
      final purchaserInfo = await Purchases.purchasePackage(package);
      if (purchaserInfo.entitlements.all["premium"]?.isActive == true) {
        paywallService.isPremiumUser = true;
      } else {
        paywallService.isPremiumUser = false;
      }
      onPaywallClose.call();
    } on PlatformException catch (e) {
      paywallService.isLoading = false;
      debugPrint(e.toString());
    }
  }

  // restore purchases
  static Future<bool> restorePurchases() async {
    try {
      paywallService.isLoading = true;
      CustomerInfo customerInfo = await Purchases.restorePurchases();
      paywallService.isLoading = false;
      if (customerInfo.entitlements.all["premium"]?.isActive == true) {
        paywallService.isPremiumUser = true;
        return true;
      } else {
        paywallService.isPremiumUser = false;
        return false;
      }
    } on PlatformException catch (e) {
      // Error restoring purchases
      debugPrint("Error restoring purchases: $e");
      paywallService.isLoading = false;
      return false;
    }
  }

  /// Get RevenueCat Id
  static Future<String?> getRevenueCatId() async {
    try {
      final userInfo = await Purchases.appUserID;
      return userInfo;
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  // set customUserId property
  static Future<void> setUserProperty(String key, String value) async {
    try {
      await Purchases.setAttributes({key: value});
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  // set facebook property
  static Future<void> setFacebook(String anonymousIDfacebook) async {
    try {
      await Purchases.setFBAnonymousID(anonymousIDfacebook);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  // set appsFlyerUserId property
  static Future<void> setAppsFlyerUserId(String appsFlyerUserId) async {
    try {
      await Purchases.setAppsflyerID(appsFlyerUserId);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  // set firebaseUserId property
  static Future<void> setFirebaseUserId(String firebaseUserId) async {
    try {
      await Purchases.setFirebaseAppInstanceId(firebaseUserId);
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
