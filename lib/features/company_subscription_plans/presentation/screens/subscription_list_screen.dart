import 'package:flutter/material.dart';
import 'package:flutter_lakshman1020/core/widgets/app_scaffold.dart';
import 'package:flutter_lakshman1020/core/widgets/custom_appbar.dart';
import 'package:get/get.dart';

import '../../data/models/subscription_model.dart';
import '../controllers/subscription_controller.dart';
import '../widgets/subscribe_button.dart';
import '../widgets/subscription_card.dart';

class SubscriptionListScreen extends StatelessWidget {
  const SubscriptionListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Use GetX to get or create the controller instance with dependency injection
    final SubscriptionController controller = Get.put(
      SubscriptionController(Get.find(), Get.find()),
      tag: 'subscription_list', // Use a tag to avoid conflicts with other instances
    );
    final List<SubscriptionPlan> plans = controller.getAllPlans();

    return AppScaffold(
      appBar: const CustomAppBar(title: "Subscription plans", titleCenter: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Column(
          children: [
            const SizedBox(height: 20),
            
            // List of all subscription cards
            ...plans.asMap().entries.map((entry) {
              SubscriptionPlan plan = entry.value;
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: SubscriptionCard(
                  plan: plan,
                  isPopular: false,
                  onSubscribe: () {
                    print("Subscribe to ${plan.name} plan");
                  },
                ),
              );
            }).toList(),
            
            const SizedBox(height: 20),
            
            // General subscribe button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: SubscribeButton(
                text: "Choose a Plan",
                onPressed: () {
                  // Show plan selection dialog or navigate
                  _showPlanSelectionDialog(context, plans);
                },
              ),
            ),
            
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  void _showPlanSelectionDialog(BuildContext context, List<SubscriptionPlan> plans) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Select a Plan"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: plans.map((plan) => ListTile(
              title: Text(plan.name),
              subtitle: Text("\$${plan.price}/${plan.period}"),
              onTap: () {
                Navigator.of(context).pop();
                print("Selected ${plan.name} plan - \$${plan.price}/${plan.period}");
                // Handle plan selection
              },
            )).toList(),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Cancel"),
            ),
          ],
        );
      },
    );
  }
}