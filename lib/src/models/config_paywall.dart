import 'layout_paywall.dart';

class ConfigPaywall {
  final bool isHardPaywall;
  final int showCloseAfterSeconds;

  final LayoutPaywall layoutPaywall;

  ConfigPaywall({
    this.isHardPaywall = false,
    this.showCloseAfterSeconds = 0,
    required this.layoutPaywall,
  });

  factory ConfigPaywall.fromJson(Map<String, dynamic> json) {
    return ConfigPaywall(
      isHardPaywall: json['isHardPaywall'] ?? false,
      showCloseAfterSeconds: json['showCloseAfterSeconds'] ?? 0,
      layoutPaywall: LayoutPaywall.fromJson(json['layoutPaywall']),
    );
  }

  Map<String, dynamic> toJson() => {
        'isHardPaywall': isHardPaywall,
        'showCloseAfterSeconds': showCloseAfterSeconds,
        'layoutPaywall': layoutPaywall.toJson(),
      };
}
