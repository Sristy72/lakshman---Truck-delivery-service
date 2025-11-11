import 'package:flutter/material.dart';
import 'package:flutter_lakshman1020/core/widgets/app_scaffold.dart';
import 'package:flutter_lakshman1020/core/widgets/custom_appbar.dart';
import 'package:flutter_lakshman1020/features/accounts/controller/account_controller.dart';
import 'package:get/get.dart';

import '../controllers/subscription_controller.dart';
import '../widgets/page_indicator.dart';
import '../widgets/subscribe_button.dart';
import '../widgets/subscription_card.dart';
import 'payment_details_screen.dart';

class SubscriptionScreen extends StatefulWidget {
  const SubscriptionScreen({super.key});

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  final PageController _pageController = PageController();
  late SubscriptionController _controller;
  int _currentPageIndex = 0;

  @override
  void initState() {
    super.initState();
    // Initialize controller with dependency injection
    _controller = Get.put(SubscriptionController(Get.find(), Get.find()));
    
    // Force refresh account profile to get latest company data
    try {
      final accountController = Get.find<AccountController>();
      debugPrint('🔄 Force refreshing account profile for subscription...');
      accountController.fetchProfile();
    } catch (e) {
      debugPrint('⚠️ Could not refresh account profile: $e');
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: const CustomAppBar(title: "Subscription plans", titleCenter: true),
      body: Obx(() {
        // Show loading indicator while fetching plans
        if (_controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        // Show error message if API fails
        if (_controller.errorMessage.value.isNotEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.error_outline,
                  size: 64,
                  color: Colors.red,
                ),
                const SizedBox(height: 16),
                Text(
                  _controller.errorMessage.value,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.red,
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () => _controller.fetchPlansFromApi(),
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        // Get plans from controller
        final plans = _controller.getAllPlans();

        // Show message if no plans available
        if (plans.isEmpty) {
          return const Center(
            child: Text(
              'No subscription plans available',
              style: TextStyle(fontSize: 16),
            ),
          );
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              const SizedBox(height: 29),
              
              // PageView for subscription cards
              SizedBox(
                height: 580, // Fixed height for PageView
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: _onPageChanged,
                  itemCount: plans.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: SubscriptionCard(
                        plan: plans[index],
                        isPopular: false,
                        onSubscribe: () async {
                          // Get the API plan for this index
                          final apiPlan = _controller.apiPlans[index];
                          
                          // Call the create payment API
                          final clientSecret = await _controller.createPayment(
                            planId: apiPlan.id,
                            price: apiPlan.price,
                          );
                          
                          if (clientSecret != null && clientSecret.isNotEmpty) {
                            // Navigate to payment details screen with the client secret
                            Get.to(
                              () => PaymentDetailsScreen(
                                plan: plans[index],
                                clientSecret: clientSecret,
                              ),
                              transition: Transition.rightToLeft,
                            );
                          } else {
                            // Show error if payment creation failed
                            Get.snackbar(
                              'Error',
                              'Failed to create payment. Please try again.',
                              snackPosition: SnackPosition.BOTTOM,
                            );
                          }
                        },
                      ),
                    );
                  },
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Page indicator
              PageIndicator(
                currentPage: _currentPageIndex,
                totalPages: plans.length,
              ),
              
              const SizedBox(height: 20),
              
              // Subscribe button for current plan
              SubscribeButton(
                text: "Subscribe to ${plans[_currentPageIndex].name}",
                onPressed: () async {
                  // Get the current plan
                  final currentPlan = plans[_currentPageIndex];
                  final apiPlan = _controller.apiPlans[_currentPageIndex];
                  
                  // Call the create payment API
                  final clientSecret = await _controller.createPayment(
                    planId: apiPlan.id,
                    price: apiPlan.price,
                  );
                  
                  if (clientSecret != null && clientSecret.isNotEmpty) {
                    // Navigate to payment details screen with the client secret
                    Get.to(
                      () => PaymentDetailsScreen(
                        plan: currentPlan,
                        clientSecret: clientSecret,
                      ),
                      transition: Transition.rightToLeft,
                    );
                  } else {
                    // Show error if payment creation failed
                    Get.snackbar(
                      'Error',
                      'Failed to create payment. Please try again.',
                      snackPosition: SnackPosition.BOTTOM,
                    );
                  }
                },
              ),
              
              const SizedBox(height: 30),
            ],
          ),
        );
      }),
    );
  }
}