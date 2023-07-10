class LayoutPaywall {
  final String model;
  final Map<String, dynamic> args;

  LayoutPaywall({required this.model, this.args = const {}});

  factory LayoutPaywall.fromJson(Map<String, dynamic> json) {
    return LayoutPaywall(
      model: json['model'],
      args: json['args'],
    );
  }

  Map<String, dynamic> toJson() => {
        'model': model,
        'args': args,
      };
}
