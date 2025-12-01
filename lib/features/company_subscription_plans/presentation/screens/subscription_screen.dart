import 'package:flutter/material.dart';
import 'package:flutter_lakshman1020/core/widgets/app_scaffold.dart';
import 'package:flutter_lakshman1020/core/widgets/custom_appbar.dart';
import 'package:flutter_lakshman1020/core/widgets/skeleton_loader.dart';
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
        // Show skeleton loaders while fetching plans
        if (_controller.isLoading.value) {
          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                const SizedBox(height: 29),
                _buildSkeletonPlans(),
                const SizedBox(height: 30),
              ],
            ),
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

        // Show skeleton loaders if no plans available yet (API still loading)
        if (plans.isEmpty) {
          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                const SizedBox(height: 29),
                _buildSkeletonPlans(),
                const SizedBox(height: 30),
              ],
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

  /// Build skeleton loaders for subscription plans
  Widget _buildSkeletonPlans() {
    return Column(
      children: [
        // Skeleton for main card
        Container(
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: const Color(0xFFF2F6FF),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            children: [
              // Skeleton header with plan name and price
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Plan name skeleton
                    SkeletonLoader(
                      width: 100,
                      height: 20,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    // Price skeleton
                    SkeletonLoader(
                      width: 80,
                      height: 24,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ],
                ),
              ),
              // Features skeleton lines
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (int i = 0; i < 4; i++) ...[
                      SkeletonLoader(
                        width: double.infinity,
                        height: 16,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      const SizedBox(height: 12),
                    ],
                  ],
                ),
              ),
              // Button skeleton
              Padding(
                padding: const EdgeInsets.all(20),
                child: SkeletonLoader(
                  width: double.infinity,
                  height: 48,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ],
          ),
        ),
        
        const SizedBox(height: 12),
        
        // Page indicator skeleton
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            for (int i = 0; i < 3; i++) ...[
              SkeletonLoader(
                width: 8,
                height: 8,
                borderRadius: BorderRadius.circular(4),
              ),
              if (i < 2) const SizedBox(width: 8),
            ],
          ],
        ),
        
        const SizedBox(height: 20),
        
        // Subscribe button skeleton
        SkeletonLoader(
          width: double.infinity,
          height: 48,
          borderRadius: BorderRadius.circular(8),
        ),
      ],
    );
  }
}