class PaywallListener {
  final Function onClose;
  final Function? onPurchase;
  final Function onRestore;
  final Function onTerms;
  final Function onPrivacy;

  PaywallListener({
    required this.onClose,
    this.onPurchase,
    required this.onRestore,
    required this.onTerms,
    required this.onPrivacy,
  });
}
