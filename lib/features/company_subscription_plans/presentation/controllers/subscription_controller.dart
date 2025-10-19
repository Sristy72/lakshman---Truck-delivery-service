
import '../../models/subscription_model.dart';

class SubscriptionController {
  SubscriptionPlan getBasicPlan() {
    return SubscriptionPlan(
      name: "Basic",
      price: "99.99",
      period: "m",
      features: [
        SubscriptionFeature(title: "Order Management", value: true),
        SubscriptionFeature(title: "Client", value: true),
        SubscriptionFeature(title: "Dispather", value: 10),
        SubscriptionFeature(title: "Advanced Analytics", value: false),
        SubscriptionFeature(title: "Priority Support", value: false),
        SubscriptionFeature(title: "Custom Reports", value: false),
        SubscriptionFeature(title: "API Access", value: false),
        SubscriptionFeature(title: "White Label", value: false),
      ],
    );
  }

  SubscriptionPlan getPremiumPlan() {
    return SubscriptionPlan(
      name: "Premium",
      price: "199.99",
      period: "m",
      features: [
        SubscriptionFeature(title: "Order Management", value: true),
        SubscriptionFeature(title: "Client", value: true),
        SubscriptionFeature(title: "Dispather", value: "Unlimited"),
        SubscriptionFeature(title: "Advanced Analytics", value: true),
        SubscriptionFeature(title: "Priority Support", value: true),
        SubscriptionFeature(title: "Custom Reports", value: true),
        SubscriptionFeature(title: "API Access", value: true),
        SubscriptionFeature(title: "White Label", value: true),
      ],
    );
  }

  SubscriptionPlan getEnterprisePlan() {
    return SubscriptionPlan(
      name: "Enterprise",
      price: "299.99",
      period: "m",
      features: [
        SubscriptionFeature(title: "Order Management", value: true),
        SubscriptionFeature(title: "Client", value: true),
        SubscriptionFeature(title: "Dispather", value: "Unlimited"),
        SubscriptionFeature(title: "Advanced Analytics", value: true),
        SubscriptionFeature(title: "Priority Support", value: true),
        SubscriptionFeature(title: "Custom Reports", value: true),
        SubscriptionFeature(title: "API Access", value: true),
        SubscriptionFeature(title: "White Label", value: true),
      ],
    );
  }
}