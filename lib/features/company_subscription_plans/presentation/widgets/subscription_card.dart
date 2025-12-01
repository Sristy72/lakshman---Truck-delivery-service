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
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;
    final horizontalPadding = isMobile ? 16.0 : 20.0;
    final featurePadding = isMobile ? 16.0 : 20.0;
    
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
            padding: EdgeInsets.fromLTRB(horizontalPadding, isPopular ? 12 : 16, horizontalPadding, 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    plan.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF18191A),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8),
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

          // Features Container with Gradient - Takes remaining space
          Expanded(
            child: Container(
              width: double.infinity,
              margin: EdgeInsets.fromLTRB(horizontalPadding, 0, horizontalPadding, horizontalPadding),
              padding: EdgeInsets.all(featurePadding),
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: plan.features
                    .map((feature) => SubscriptionFeatureItem(
                          title: feature.title,
                          value: feature.value,
                        ))
                    .toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}