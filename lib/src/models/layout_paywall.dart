class LayoutPaywall {
  final PaywallModel model;
  final Map<String, Object> args;

  LayoutPaywall({required this.model, this.args = const {}});
}

enum PaywallModel { loading, nika, juliet }
