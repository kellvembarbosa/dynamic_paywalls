import 'dart:io';

import 'package:dynamic_paywalls/dynamic_paywalls.dart';
import 'package:dynamic_paywalls/src/repositories/paywall_connect.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class Paywalls {
  static late final CustomConfig? _customConfig;
  static late final PaywallService paywallService;
  static late final ConfigPaywall _paywallFallback;
  static final PaywallConnect _paywallConnect = PaywallConnect();
  static late final String _paywallUrl;
  static bool _isInitialized = false; // Variável para rastrear se o init() já foi chamado

  Paywalls._internal();

  /// Initialize Qonversion SDK
  static init({
    required String projectKey,

    /// The paywall url to be used if the remote config is available
    required String paywallUrl,

    /// The fallback paywall to be used if the remote config is not available
    required ConfigPaywall paywallFallback,
    QLaunchMode launchMode = QLaunchMode.subscriptionManagement,
    bool enableSearchAds = false,
    bool isDesignMode = false,
    QEnvironment environment = QEnvironment.production,
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

    // Start Qonversion SDK
    final config = QonversionConfigBuilder(projectKey, launchMode).setEnvironment(environment).build();
    Qonversion.initialize(config);

    // Enable Search Ads
    if (enableSearchAds) {
      Qonversion.getSharedInstance().collectAppleSearchAdsAttribution();
    }

    // Custom configs
    _customConfig = customConfig;

    // Paywall url
    _paywallUrl = paywallUrl;

    // Paywall fallback
    _paywallFallback = paywallFallback;

    // Others configs
    if (othersConfigs != null) {
      othersConfigs();
    }

    try {
      final Map<String, QProduct> products = await Qonversion.getSharedInstance().products();
      paywallService.products = products;
    } catch (e) {
      debugPrint(e.toString());
    }

    // get remote configs
    updateRemoteConfigs(isDesignMode: Platform.isAndroid || Platform.isIOS ? isDesignMode : true);
  }

  /// Get the paywall widget
  static Widget getPaywall({bool isDesignMode = false, ConfigPaywall? data}) {
    updateRemoteConfigs(isDesignMode: isDesignMode, data: data);
    return Paywall();
  }

  // get remote configs
  static updateRemoteConfigs({bool isDesignMode = false, ConfigPaywall? data}) async {
    debugPrint("updateRemoteConfigs $isDesignMode $data");

    if (isDesignMode) {
      paywallService.setQRemoteConfig(data ?? _paywallFallback);
      return;
    } else {
      if (Platform.isAndroid || Platform.isIOS) {
        try {
          final remoteConfig = await Qonversion.getSharedInstance().remoteConfig();

          if (remoteConfig.experiment == null || remoteConfig.payload.toString() == "{}") {
            final paywallRemote = await _paywallConnect.getPaywallRemote(_paywallUrl);

            paywallService.setQRemoteConfig(ConfigPaywall.fromJson(paywallRemote));
          } else {
            paywallService.setQRemoteConfig(ConfigPaywall.fromJson(remoteConfig.payload));
          }
        } catch (e) {
          debugPrint(e.toString());
          paywallService.setQRemoteConfig(_paywallFallback);
        }
      }
    }
  }

  /// Check if the user is a premium user
  static Future<void> checkPermissions() async {
    try {
      final Map<String, QEntitlement> entitlements = await Qonversion.getSharedInstance().checkEntitlements();
      final premium = entitlements[_customConfig?.entitlements ?? 'premium'];
      if (premium != null && premium.isActive) {
        switch (premium.renewState) {
          case QEntitlementRenewState.willRenew:
          case QEntitlementRenewState.nonRenewable:
            // .willRenew is the state of an auto-renewable subscription
            // .nonRenewable is the state of consumable/non-consumable IAPs that could unlock lifetime access
            Get.find<PaywallService>().isPremiumUser = true;
            break;
          case QEntitlementRenewState.billingIssue:
            // Grace period: entitlement is active, but there was some billing issue.
            // Prompt the user to update the payment method.
            break;
          case QEntitlementRenewState.canceled:
            // The user has turned off auto-renewal for the subscription, but the subscription has not expired yet.
            // Prompt the user to resubscribe with a special offer.
            Get.find<PaywallService>().isPremiumUser = false;
            break;
          default:
            break;
        }
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  /// Purchase a product
  static Future<void> purchase(String productId, {Function? showUserCancel}) async {
    paywallService.isLoading = true;
    try {
      final Map<String, QEntitlement> entitlements = await Qonversion.getSharedInstance().purchase(productId);
      final premium = entitlements[_customConfig?.entitlements ?? 'premium'];

      if (premium != null && premium.isActive) {
        paywallService.isLoading = false;
        switch (premium.renewState) {
          case QEntitlementRenewState.willRenew:
          case QEntitlementRenewState.nonRenewable:
            // .willRenew is the state of an auto-renewable subscription
            // .nonRenewable is the state of consumable/non-consumable IAPs that could unlock lifetime access
            Get.find<PaywallService>().isPremiumUser = true;
            Get.back();
            break;
          case QEntitlementRenewState.billingIssue:
            // Grace period: entitlement is active, but there was some billing issue.
            // Prompt the user to update the payment method.
            break;
          case QEntitlementRenewState.canceled:
            // The user has turned off auto-renewal for the subscription, but the subscription has not expired yet.
            // Prompt the user to resubscribe with a special offer.
            Get.find<PaywallService>().isPremiumUser = false;
            break;
          default:
            break;
        }
      }
    } on QPurchaseException catch (e) {
      paywallService.isLoading = false;
      if (e.isUserCancelled) {
        // Purchase canceled by the user
        if (showUserCancel != null) {
          showUserCancel();
        }
        return;
      }

      debugPrint(e.toString());
    }
  }

  // restore purchases
  static Future<bool> restorePurchases() async {
    try {
      paywallService.isLoading = true;
      final Map<String, QEntitlement> entitlements = await Qonversion.getSharedInstance().restore();
      final premium = entitlements[_customConfig?.entitlements ?? 'premium'];
      if (premium != null && premium.isActive) {
        paywallService.isLoading = false;
        switch (premium.renewState) {
          case QEntitlementRenewState.willRenew:
          case QEntitlementRenewState.nonRenewable:
            // .willRenew is the state of an auto-renewable subscription
            // .nonRenewable is the state of consumable/non-consumable IAPs that could unlock lifetime access
            Get.find<PaywallService>().isPremiumUser = true;
            return true;
          case QEntitlementRenewState.billingIssue:
            // Grace period: entitlement is active, but there was some billing issue.
            // Prompt the user to update the payment method.
            return false;
          case QEntitlementRenewState.canceled:
            // The user has turned off auto-renewal for the subscription, but the subscription has not expired yet.
            // Prompt the user to resubscribe with a special offer.
            Get.find<PaywallService>().isPremiumUser = false;
            return false;
          default:
            return false;
        }
      }
      return false;
    } catch (e) {
      paywallService.isLoading = false;
      debugPrint(e.toString());
      return false;
    }
  }

  /// Get QonversionId
  static Future<String?> getQonversionId() async {
    try {
      final userInfo = await Qonversion.getSharedInstance().userInfo();
      return userInfo.qonversionId;
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  // Get identityId
  static Future<String?> getIdentityId() async {
    try {
      final userInfo = await Qonversion.getSharedInstance().userInfo();
      return userInfo.identityId;
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  // set Identify id
  static Future<void> setUserId(String userId) async {
    try {
      await Qonversion.getSharedInstance().identify(userId);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  // set customUserId property
  static Future<void> setUserProperty(String key, String value) async {
    try {
      await Qonversion.getSharedInstance().setProperty(QUserProperty.customUserId, value);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  // set email property
  static Future<void> setEmail(String email) async {
    try {
      await Qonversion.getSharedInstance().setProperty(QUserProperty.email, email);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  // set name property
  static Future<void> setName(String name) async {
    try {
      await Qonversion.getSharedInstance().setProperty(QUserProperty.name, name);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  // set facebook property
  static Future<void> setFacebook(String facebook) async {
    try {
      await Qonversion.getSharedInstance().setProperty(QUserProperty.facebookAttribution, facebook);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  // set appsFlyerUserId property
  static Future<void> setAppsFlyerUserId(String appsFlyerUserId) async {
    try {
      await Qonversion.getSharedInstance().setProperty(QUserProperty.appsFlyerUserId, appsFlyerUserId);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  // set firebaseUserId property
  static Future<void> setFirebaseUserId(String firebaseUserId) async {
    try {
      await Qonversion.getSharedInstance().setProperty(QUserProperty.firebaseAppInstanceId, firebaseUserId);
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
