import 'package:flutter_lakshman1020/core/base/base_controller.dart';
import 'package:flutter_lakshman1020/features/accounts/controller/account_controller.dart';
import 'package:flutx_core/flutx_core.dart';
import 'package:get/get.dart';

import '../../data/models/create_payment_request_model.dart';
import '../../data/models/fetch_plans_request_model.dart';
import '../../data/models/fetch_plans_response_model.dart';
import '../../data/models/subscription_model.dart';
import '../../domain/payment_repo.dart';
import '../../domain/subscription_repo.dart';

class SubscriptionController extends BaseController {
  final SubscriptionRepository _subscriptionRepository;
  final PaymentRepository _paymentRepository;
  AccountController? _accountController;

  SubscriptionController(this._subscriptionRepository, this._paymentRepository);

  // Observable list of plans from API
  final RxList<FetchPlansResponseModel> apiPlans =
      <FetchPlansResponseModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    // Try to get AccountController safely
    try {
      _accountController = Get.find<AccountController>();
      DPrint.log("✅ AccountController found successfully");
      
      // ALWAYS trigger profile fetch to get the latest company data
      DPrint.log("� Force fetching latest profile data...");
      _accountController!.fetchProfile();
      
    } catch (e) {
      DPrint.error("❌ Failed to find AccountController: $e");
      DPrint.error("❌ Will try to initialize it...");
      // Try to create it if it doesn't exist
      try {
        Get.lazyPut<AccountController>(() => AccountController(Get.find()), fenix: true);
        _accountController = Get.find<AccountController>();
        DPrint.log("✅ AccountController initialized successfully");
        // Fetch profile after initialization
        _accountController!.fetchProfile();
      } catch (e2) {
        DPrint.error("❌ Failed to initialize AccountController: $e2");
      }
    }
    
    // Wait for user info to be available before fetching plans
    _waitForUserInfoAndFetch();
  }

  // Wait for user info to load, then fetch plans
  Future<void> _waitForUserInfoAndFetch() async {
    DPrint.log("========== WAITING FOR USER INFO ==========");
    
    // First, check if AccountController exists
    if (_accountController == null) {
      DPrint.error("❌ AccountController is null, cannot fetch plans");
      setError('AccountController not initialized');
      return;
    }
    
    // Wait for userInfo to be populated (max 5 seconds)
    int attempts = 0;
    while ((_accountController?.userInfo.value?.email == null || 
            _accountController!.userInfo.value!.email.isEmpty) && 
           attempts < 50) {
      DPrint.log("⏳ Waiting for user info... Attempt $attempts/50");
      DPrint.log("📧 Current email value: ${_accountController?.userInfo.value?.email}");
      DPrint.log("👤 Current user info: ${_accountController?.userInfo.value}");
      await Future.delayed(const Duration(milliseconds: 100));
      attempts++;
    }
    
    final finalEmail = _accountController?.userInfo.value?.email;
    DPrint.log("========== USER INFO LOADED ==========");
    DPrint.log("✅ Final email: $finalEmail");
    DPrint.log("📊 Total attempts: $attempts");
    DPrint.log("👤 Full user info: ${_accountController?.userInfo.value}");
    DPrint.log("=====================================");
    
    // Now fetch plans
    await fetchPlansFromApi();
  }

  // Fetch plans from API
  Future<void> fetchPlansFromApi() async {
    try {
      DPrint.log("========== FETCH PLANS FROM API STARTED ==========");
      setLoading(true);
      setError('');

      if (_accountController == null) {
        final errorMsg = 'AccountController not initialized';
        setError(errorMsg);
        setLoading(false);
        DPrint.error("❌ Cannot fetch plans: AccountController is null");
        return;
      }

      final email = _accountController?.userInfo.value?.email;
      DPrint.log("📧 Extracted email: $email");
      DPrint.log("👤 User info object: ${_accountController?.userInfo.value}");
      DPrint.log("🔍 User info is null: ${_accountController?.userInfo.value == null}");
      
      if (email == null || email.isEmpty) {
        final errorMsg = 'User email not found. Please try again.';
        setError(errorMsg);
        setLoading(false);
        DPrint.error("❌ Cannot fetch plans: User email is null or empty");
        DPrint.error("❌ AccountController userInfo: ${_accountController?.userInfo.value}");
        return;
      }

      DPrint.log("🔍 Fetching plans for email: $email");

      final request = FetchPlansRequestModel(email: email);
      DPrint.log("📦 Request model created: ${request.toJson()}");
      
      final result = await _subscriptionRepository.fetchPlans(request);

      result.fold(
        (failure) {
          setError(failure.message);
          DPrint.error("❌ Failed to fetch plans: ${failure.message}");
          setLoading(false);
        },
        (success) {
          apiPlans.value = success.data;
          DPrint.log(
              "✅ Successfully loaded ${success.data.length} plans from API");
          setLoading(false);
        },
      );
    } catch (e) {
      setError(e.toString());
      DPrint.error("❌ Exception fetching plans: $e");
      setLoading(false);
    }
  }

  // Convert API plan to SubscriptionPlan for UI compatibility
  SubscriptionPlan convertToSubscriptionPlan(FetchPlansResponseModel apiPlan) {
    return SubscriptionPlan(
      name: apiPlan.name,
      price: apiPlan.price.toString(),
      period: "m",
      features: apiPlan.features
          .map((feature) => SubscriptionFeature(
                title: feature,
                value: true,
              ))
          .toList(),
    );
  }

    // Get all subscription plans (now from API)
  List<SubscriptionPlan> getAllPlans() {
    if (apiPlans.isEmpty) {
      // Return empty list if API hasn't loaded yet
      return [];
    }
    return apiPlans.map((plan) => convertToSubscriptionPlan(plan)).toList();
  }

  // Create payment for a subscription plan
  Future<String?> createPayment({
    required String planId,
    required double price,
  }) async {
    try {
      setLoading(true);
      setError('');

      if (_accountController == null) {
        setError('AccountController not initialized');
        setLoading(false);
        DPrint.error("❌ Cannot create payment: AccountController is null");
        return null;
      }

      final userId = _accountController?.userInfo.value?.id;
      if (userId == null || userId.isEmpty) {
        setError('User ID not found. Please try again.');
        setLoading(false);
        DPrint.error("❌ Cannot create payment: User ID is null");
        return null;
      }

      DPrint.log("🔍 Creating payment for user: $userId, plan: $planId, price: $price");

      final request = CreatePaymentRequestModel(
        userId: userId,
        planId: planId,
        price: price,
        type: 'order',
      );

      final result = await _paymentRepository.createPayment(request);

      return result.fold(
        (failure) {
          setError(failure.message);
          DPrint.error("❌ Failed to create payment: ${failure.message}");
          setLoading(false);
          return null;
        },
        (success) {
          DPrint.log("✅ Payment created successfully! Client Secret: ${success.data.clientSecret}");
          setLoading(false);
          return success.data.clientSecret;
        },
      );
    } catch (e) {
      setError(e.toString());
      DPrint.error("❌ Exception creating payment: $e");
      setLoading(false);
      return null;
    }
  }
}
