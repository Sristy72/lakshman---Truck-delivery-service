import 'package:flutter/material.dart';
import 'package:flutter_lakshman1020/core/widgets/app_scaffold.dart';
import 'package:flutter_lakshman1020/core/widgets/custom_appbar.dart';
import 'package:flutter_lakshman1020/core/widgets/primary_button.dart';
import '../../models/subscription_model.dart';
import '../controllers/subscription_controller.dart';
import '../widgets/feature_items.dart';

class SubscriptionScreen extends StatelessWidget {
  const SubscriptionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final SubscriptionController _controller = SubscriptionController();
    final SubscriptionPlan basicPlan = _controller.getBasicPlan();

    return AppScaffold(
      appBar: CustomAppBar(title: "Subscription plans", titleCenter: true),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              const SizedBox(height: 29),

              SizedBox(
                height: 600, // Adjust height as needed
                child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: 3,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: EdgeInsets.only(bottom: 16),
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Color(0xffF2F6FF),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        children: [
                          // Plan name and price
                          Padding(
                            padding: const EdgeInsets.only(top: 13, bottom: 13),
                            child: Row(
                              children: [
                                Text(
                                  basicPlan.name,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xFF18191A),
                                  ),
                                ),
                                Spacer(),
                                Text(
                                  "\$ ${basicPlan.price}/${basicPlan.period}",
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF18191A),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Features list
                          Container(
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  Color(0xFFF4788A),
                                  Color(0xFF2B5DCB),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              children: [
                                // Feature items - takes full width
                                ...basicPlan.features.map((feature) =>
                                    FeatureItem(
                                      title: feature.title,
                                      value: feature.value,
                                    )
                                ).toList(),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              context.primaryButton(onPressed: (){}, text: "Subscribe Now")
            ],
          ),
        ),
      ),
    );
  }
}