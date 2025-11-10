import 'package:flutter/material.dart';

import '../../data/models/subscription_model.dart';
import 'subscription_feature_item.dart';

class SubscriptionCard extends StatelessWidget {
  final SubscriptionPlan plan;
  final VoidCallback? onSubscribe;
  final bool isPopular;

  const SubscriptionCard({
    super.key,
    required this.plan,
    this.onSubscribe,
    this.isPopular = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFF2F6FF),
        borderRadius: BorderRadius.circular(20),
        border: isPopular 
          ? Border.all(color: const Color(0xFF2B5DCB), width: 2)
          : null,
      ),
      child: Column(
        children: [
          // Popular badge
          if (isPopular)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 8),
              decoration: const BoxDecoration(
                color: Color(0xFF2B5DCB),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(18),
                  topRight: Radius.circular(18),
                ),
              ),
              child: const Text(
                "Most Popular",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          
          // Plan Header
          Padding(
            padding: EdgeInsets.fromLTRB(20, isPopular ? 16 : 20, 20, 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  plan.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF18191A),
                  ),
                ),
                Text(
                  "\$${plan.price}/${plan.period}",
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF18191A),
                  ),
                ),
              ],
            ),
          ),

          // Features Container with Gradient
          Container(
            margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFFF4788A),
                  Color(0xFF2B5DCB),
                ],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: plan.features
                  .map((feature) => SubscriptionFeatureItem(
                        title: feature.title,
                        value: feature.value,
                      ))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}