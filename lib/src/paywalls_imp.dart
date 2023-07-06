import 'package:dynamic_paywalls/dynamic_paywalls.dart';
import 'package:dynamic_paywalls/src/controllers/controller_paywall.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Paywalls {
  static late final CustomConfig? customConfig;
  Paywalls._internal();

  /// Initialize Qonversion SDK
  ///
  static init({
    required String projectKey,
    QLaunchMode launchMode = QLaunchMode.subscriptionManagement,
    bool enableSearchAds = false,
    CustomConfig? customConfigs,
    Function? othersConfigs,
  }) {
    // Inicialize o singleton aqui, se necessário
    Get.putAsync(() => PaywallService().init());

    // Start Qonversion SDK
    final config = QonversionConfigBuilder(projectKey, launchMode).build();
    Qonversion.initialize(config);

    // Enable Search Ads
    if (enableSearchAds) {
      Qonversion.getSharedInstance().collectAppleSearchAdsAttribution();
    }

    // get remote configs
    updateRemoteConfigs();

    // Custom configs
    customConfig = customConfigs;

    // Others configs
    if (othersConfigs != null) {
      othersConfigs();
    }
  }

  /// Get the paywall widget
  static Widget getPaywall() {
    return Paywall();
  }

  // get remote configs
  static updateRemoteConfigs() async {
    final remoteConfig = await Qonversion.getSharedInstance().remoteConfig();
    Get.find<PaywallService>().setQRemoteConfig(remoteConfig);
  }

  /// Check if the user is a premium user
  static Future<void> checkPermissions() async {
    try {
      final Map<String, QEntitlement> entitlements = await Qonversion.getSharedInstance().checkEntitlements();
      final premium = entitlements[customConfig?.entitlements ?? 'premium'];
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
  static Future<void> purchase(String productId, Function? showUserCancel) async {
    try {
      final Map<String, QEntitlement> entitlements = await Qonversion.getSharedInstance().purchase(productId);

      final premium = entitlements[customConfig?.entitlements ?? 'premium'];

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
    } on QPurchaseException catch (e) {
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
      final Map<String, QEntitlement> entitlements = await Qonversion.getSharedInstance().restore();
      final premium = entitlements[customConfig?.entitlements ?? 'premium'];
      if (premium != null && premium.isActive) {
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
