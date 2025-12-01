class SubscriptionFeature {
  final String title;
  final dynamic value;

  SubscriptionFeature({
    required this.title,
    required this.value,
  });
}

class SubscriptionPlan {
  final String name;
  final String price;
  final String period;
  final List<SubscriptionFeature> features;

  SubscriptionPlan({
    required this.name,
    required this.price,
    required this.period,
    required this.features,
  });
}