import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/network/api_client.dart';
import '../../../../core/network/constants/api_constants.dart';
import '../../../../core/network/services/auth_storage_service.dart';
import '../../../chat/data/chat_repository.dart';
import '../../../home/controller/driver_home_controller.dart';
import '../../../home/data/models/load_model.dart';
import '../../../home/presentations/screens/driver_home_screen.dart';
import '../../../notification/presentation/screens/chat_detail_screen.dart';
import '../../data/services/geocoding_service.dart';

class DeliveryDetailsController extends GetxController {
  var deliveryList = <Map<String, String>>[].obs;
  var selectedIndex = 0.obs;

  /// Dynamic title used by the page app bar. Defaults to a fallback title.
  final currentTitle = 'Delivery Details'.obs;

  /// 0 - pending, 1 - processing, 2 - delivered
  final currentStep = 0.obs;

  final pickupDateString = ''.obs;

  /// The raw order status string as returned by the backend (e.g. 'pending', 'processing', 'asked').
  final orderStatus = ''.obs;

  /// Local UI flag when user taps Accept to progress visually, without
  /// changing the server-side orderStatus (remains processing).
  final accepted = false.obs;

  final String? initialLoadId;

  /// Local loading flag for price-action calls
  final isActionLoading = false.obs;

  /// Loading flag when marking delivery as complete
  final isCompletingDelivery = false.obs;

  /// Payment-related fields
  final price = 0.0.obs;
  final isPaymentLoading = false.obs;

  /// Auth storage service for getting user ID
  final AuthStorageService _authStorageService = AuthStorageService();

  /// Chat repository for creating chats
  final ChatRepository _chatRepository = ChatRepository();

  /// Loading state for create chat
  final isCreatingChat = false.obs;

  /// Current driver ID for the load
  String? currentDriverId;

  DeliveryDetailsController({this.initialLoadId});

  @override
  void onInit() {
    super.onInit();
    if (initialLoadId != null && initialLoadId!.isNotEmpty) {
      // If an ID was passed to the page, use it as the source of truth
      fetchLoadDetailById(initialLoadId!);
    } else {
      fetchDeliveryDetails();
    }
  }

  /// Simulates an API call using the model you provided in the task.
  /// Maps the API keys into UI-friendly labels that the existing
  /// `DeliveryInfoCard` widget expects.
  Future<void> fetchDeliveryDetails() async {
    try {
      // Simulate network latency
      await Future.delayed(const Duration(milliseconds: 700));

      // Dummy API response based on the model you provided
      final apiResponse = {
        "data": {
          "title": "Furniture Delivery",
          "description":
              "Delivery of office furniture from warehouse to client",
          "category": "furniture",
          "pickupLocation": "23.8160968,90.4280376",
          "deliveryLocation": "23.7808132,90.4074913",
          "companyToken": "68e9cee3c24ab343ad8335b1",
          "loadBy": "68f468d660f8f7494c8bb030",
          "orderStatus": "pending",
          "pickupDate": "2023-12-15T10:00:00.000Z",
          "note": "Fragile items, handle with care",
          "_id": "68f4778f32d6fe9a7cbd688b",
          "createdAt": "2025-10-19T05:30:55.424Z",
          "updatedAt": "2025-10-19T05:30:55.424Z",
          "__v": 0,
        },
      };

      final data = apiResponse['data'] ?? {};

      // capture raw order status from dummy response
      orderStatus.value = (data['orderStatus'] ?? '').toString();

      // If API returned an ID, attempt to fetch the full load details from backend
      final serverId = data['_id']?.toString();

      final geocoding = GeocodingService();
      // Resolve pickup and delivery addresses (will simulate if no API key)
      final pickupLatLng = (data['pickupLocation'] ?? '').toString();
      final deliveryLatLng = (data['deliveryLocation'] ?? '').toString();

      // Debug: log the raw lat/lng values
      print(
        'DeliveryDetailsController: pickupLatLng="$pickupLatLng" deliveryLatLng="$deliveryLatLng"',
      );

      final pickupAddressModel = await geocoding.getAddressFromLatLng(
        pickupLatLng,
      );
      print(
        'DeliveryDetailsController: resolved pickupAddress="${pickupAddressModel.formattedAddress}"',
      );

      final deliveryAddressModel = await geocoding.getAddressFromLatLng(
        deliveryLatLng,
      );
      print(
        'DeliveryDetailsController: resolved deliveryAddress="${deliveryAddressModel.formattedAddress}"',
      );

      // Build the UI-friendly map. Keys intentionally human-readable because
      // DeliveryInfoCard shows the map keys as labels.
      final mapped = <String, String>{
        'title': (data['title'] ?? 'Delivery Details').toString(),
        // Driver info will be updated when fetchLoadDetailById is called
        'Driver Name': 'N/A',
        'Mobile': 'N/A',
        'Pickup Address': pickupAddressModel.formattedAddress,
        'Delivery Address': deliveryAddressModel.formattedAddress,
        'Delivered Date': _formatDateSafe(data['pickupDate']?.toString()),
        'Delivered ID': '#ABC567#7BG6',
        // productDescription is used by ProductDetailsCard below
        'productDescription': (data['description'] ?? '').toString(),
      };

      // Set the title for the app bar dynamically
      currentTitle.value = mapped['title'] ?? currentTitle.value;

      deliveryList.value = [mapped];

      if (serverId != null && serverId.isNotEmpty) {
        // fire and set status/date from server if available
        await fetchLoadDetailById(serverId);
      }
    } catch (e) {
      // Keep the list empty and log the error
      print('Error fetching delivery details: $e');
      deliveryList.value = [];
    }
  }

  Future<void> fetchLoadDetailById(String id) async {
    try {
      final apiClient = ApiClient();
      final endpoint = ApiConstants.load.getById(id);

      final response = await apiClient.get<Map<String, dynamic>>(
        endpoint,
        fromJsonT: (json) => json as Map<String, dynamic>,
      );

      response.fold(
        (failure) {
          // ignore failures and keep current UI
        },
        (success) {
          final data = success.data;
          // data is expected to be the load object
          final load = LoadModel.fromJson(data);

          // Extract askPrice from load if available
          if (load.askPrice != null && load.askPrice! > 0) {
            price.value = load.askPrice!;
            print('💰 askPrice extracted from load: ${price.value}');
          } else {
            print('⚠️ No askPrice found in load response');
          }

          // Map orderStatus to step
          // Keep the raw orderStatus so the UI can make decisions (e.g., 'asked')
          orderStatus.value = load.orderStatus.toString();

          switch (orderStatus.value.toLowerCase()) {
            case 'ask_pending':
              // 'asked' means the first dot is completed (tick) and the second is active.
              currentStep.value = 1;
              break;
            case 'asked':
            // 'asked' means the second dot is completed (tick) and the third is active.
              currentStep.value = 2;
              break;
            case 'delivered':
              currentStep.value = 3;
              break;
            // 'processing' and other statuses are treated as pending for now
            default:
              currentStep.value = 0;
          }

          pickupDateString.value = _formatDateSafe(
            load.pickupDate.toIso8601String(),
          );

          // Resolve pickup/delivery addresses using geocoding service
          final geocoding = GeocodingService();
          // These are lat,long strings in the model
          final pickupLatLng = load.pickupLocation;
          final deliveryLatLng = load.deliveryLocation;

          // Fire geocoding (await to ensure we have addresses)
          Future.wait([
            geocoding.getAddressFromLatLng(pickupLatLng),
            geocoding.getAddressFromLatLng(deliveryLatLng),
          ]).then((results) {
            final pickupAddress = results[0].formattedAddress;
            final deliveryAddress = results[1].formattedAddress;

            // Get driver name, phone and ID using helper methods
            final driverName = load.getDriverName();
            final driverPhone = load.getDriverPhone() ?? 'N/A';
            currentDriverId = load.getDriverId(); // Store driver ID for chat creation

            print('👤 Driver Name: $driverName');
            print('📱 Driver Phone: $driverPhone');
            print('🆔 Driver ID: $currentDriverId');

            final mapped = <String, String>{
              'title': load.title,
              'Driver Name': driverName,
              'Mobile': driverPhone,
              'Pickup Address': pickupAddress,
              'Delivery Address': deliveryAddress,
              'Delivered Date': pickupDateString.value,
              'Delivered ID': load.id,
              'productDescription': load.description,
            };

            // Update title and list
            currentTitle.value = load.title;
            deliveryList.value = [mapped];
          });
        },
      );
    } catch (e) {
      print('Error fetching load by id: $e');
    }
  }

  /// Called when the user taps Accept — toggles a local accepted flag which
  /// updates the UI (buttons + indicator) but does not change server status.
  void acceptPressed() {
    accepted.value = true;
  }

  /// Send accept/reject action to the server for the current load.
  /// [action] must be either 'accepted' or 'rejected'.
  Future<void> sendPriceAction(String action) async {
    if (action != 'accepted' && action != 'rejected') {
      print('Invalid action: $action');
      return;
    }

    // Determine load id: prefer initialLoadId, otherwise use Delivered ID from deliveryList
    final loadId =
        initialLoadId ??
        (deliveryList.isNotEmpty ? deliveryList[0]['Delivered ID'] : null);
    if (loadId == null || loadId.isEmpty) {
      print('No load id available to perform price-action');
      return;
    }

    try {
      isActionLoading.value = true;
      final apiClient = ApiClient();
      final endpoint = ApiConstants.load.priceAction(loadId);

      final body = {'action': action};
      // Debug logging: print endpoint and payload so we can verify the exact request
      print('DeliveryDetailsController.sendPriceAction -> endpoint: $endpoint');
      print('DeliveryDetailsController.sendPriceAction -> body: $body');

      final response = await apiClient.post<Map<String, dynamic>>(
        endpoint,
        data: body,
        fromJsonT: (json) => json as Map<String, dynamic>,
      );

      // Handle response: if POST fails with API Not Found (400), retry with PATCH
      response.fold(
        (failure) async {
          print(
            'Price action POST failed: ${failure.message} (${failure.statusCode})',
          );
          // If server reports API Not Found, retry with PATCH (some servers expect PATCH)
          if (failure.statusCode == 400 &&
              (failure.message.toLowerCase().contains('api not found') ||
                  failure.message.toLowerCase().contains('not found'))) {
            try {
              print('Retrying price action with PATCH due to API Not Found');
              final patchResp = await apiClient.patch<Map<String, dynamic>>(
                endpoint,
                data: body,
                fromJsonT: (json) => json as Map<String, dynamic>,
              );

              patchResp.fold(
                (pf) {
                  // still failed
                  print(
                    'Price action PATCH failed: ${pf.message} (${pf.statusCode})',
                  );
                  try {
                    Get.snackbar(
                      'Action failed',
                      pf.message.isNotEmpty
                          ? pf.message
                          : 'Unknown error (${pf.statusCode})',
                      snackPosition: SnackPosition.BOTTOM,
                      duration: const Duration(seconds: 4),
                    );
                  } catch (_) {}
                },
                (psuccess) async {
                  // reuse success handling below by copying logic
                  final raw = psuccess.data;
                  final data =
                      raw.containsKey('data') &&
                          raw['data'] is Map<String, dynamic>
                      ? Map<String, dynamic>.from(raw['data'] as Map)
                      : Map<String, dynamic>.from(raw as Map);
                  // Normalize fields that may be returned as plain id strings instead of objects
                  if (data['companyToken'] != null &&
                      data['companyToken'] is String) {
                    data['companyToken'] = {'_id': data['companyToken']};
                  }
                  if (data['loadBy'] != null && data['loadBy'] is String) {
                    data['loadBy'] = {'_id': data['loadBy']};
                  }
                  final load = LoadModel.fromJson(data);

                  // Extract askPrice if available
                  if (load.askPrice != null && load.askPrice! > 0) {
                    price.value = load.askPrice!;
                    print('💰 askPrice extracted from price action (PATCH): ${price.value}');
                  }

                  orderStatus.value = load.orderStatus.toString();
                  switch (orderStatus.value.toLowerCase()) {
                    case 'ask_pending':
                      currentStep.value = 1;
                      break;
                    case 'asked':
                      currentStep.value = 2;
                      break;
                    case 'delivered':
                      currentStep.value = 3;
                      break;
                    default:
                      currentStep.value = 0;
                  }

                  pickupDateString.value = _formatDateSafe(
                    load.pickupDate.toIso8601String(),
                  );

                  final geocoding = GeocodingService();
                  final results = await Future.wait([
                    geocoding.getAddressFromLatLng(load.pickupLocation),
                    geocoding.getAddressFromLatLng(load.deliveryLocation),
                  ]);

                  final pickupAddress = results[0].formattedAddress;
                  final deliveryAddress = results[1].formattedAddress;

                  final driverName = load.getDriverName();
                  final driverPhone = load.getDriverPhone() ?? 'N/A';

                  final mapped = <String, String>{
                    'title': load.title,
                    'Driver Name': driverName,
                    'Mobile': driverPhone,
                    'Pickup Address': pickupAddress,
                    'Delivery Address': deliveryAddress,
                    'Delivered Date': pickupDateString.value,
                    'Delivered ID': load.id,
                    'productDescription': load.description,
                  };

                  currentTitle.value = load.title;
                  deliveryList.value = [mapped];
                  accepted.value = action == 'accepted';
                },
              );
            } catch (e) {
              print('PATCH retry error: $e');
              try {
                Get.snackbar(
                  'Action failed',
                  e.toString(),
                  snackPosition: SnackPosition.BOTTOM,
                  duration: const Duration(seconds: 4),
                );
              } catch (_) {}
            }
            return;
          }

          // Log failure and show a snackbar for easier debugging
          print(
            'Price action failed: ${failure.message} (${failure.statusCode})',
          );
          try {
            final title = 'Action failed';
            final msg = failure.message.isNotEmpty
                ? failure.message
                : 'Unknown error (${failure.statusCode})';
            Get.snackbar(
              title,
              msg,
              snackPosition: SnackPosition.BOTTOM,
              duration: const Duration(seconds: 4),
            );
          } catch (_) {}
        },
        (success) async {
          final raw = success.data;
          final data =
              raw.containsKey('data') && raw['data'] is Map<String, dynamic>
              ? Map<String, dynamic>.from(raw['data'] as Map)
              : Map<String, dynamic>.from(raw as Map);
          // Normalize companyToken/loadBy if server returned id strings
          if (data['companyToken'] != null && data['companyToken'] is String) {
            data['companyToken'] = {'_id': data['companyToken']};
          }
          if (data['loadBy'] != null && data['loadBy'] is String) {
            data['loadBy'] = {'_id': data['loadBy']};
          }
          final load = LoadModel.fromJson(data);

          // Extract askPrice if available
          if (load.askPrice != null && load.askPrice! > 0) {
            price.value = load.askPrice!;
            print('💰 askPrice extracted from price action (POST): ${price.value}');
          }

          // Update raw order status and computed step
          orderStatus.value = load.orderStatus.toString();
          switch (orderStatus.value.toLowerCase()) {
            case 'ask_pending':
              currentStep.value = 1;
              break;
            case 'asked':
              // 'asked' means the second dot is completed (tick) and the third is active
              currentStep.value = 2;
              break;
            case 'delivered':
              currentStep.value = 3;
              break;
            default:
              currentStep.value = 0;
          }

          pickupDateString.value = _formatDateSafe(
            load.pickupDate.toIso8601String(),
          );

          // Update deliveryList map with fresh addresses (geocoding) and title
          final geocoding = GeocodingService();
          final results = await Future.wait([
            geocoding.getAddressFromLatLng(load.pickupLocation),
            geocoding.getAddressFromLatLng(load.deliveryLocation),
          ]);

          final pickupAddress = results[0].formattedAddress;
          final deliveryAddress = results[1].formattedAddress;

          final driverName = load.getDriverName();
          final driverPhone = load.getDriverPhone() ?? 'N/A';

          final mapped = <String, String>{
            'title': load.title,
            'Driver Name': driverName,
            'Mobile': driverPhone,
            'Pickup Address': pickupAddress,
            'Delivery Address': deliveryAddress,
            'Delivered Date': pickupDateString.value,
            'Delivered ID': load.id,
            'productDescription': load.description,
          };

          currentTitle.value = load.title;
          deliveryList.value = [mapped];
          // If action was accepted, flip local accepted flag so UI updates
          accepted.value = action == 'accepted';
        },
      );
    } catch (e) {
      print('Error sending price action: $e');
      try {
        Get.snackbar(
          'Action failed',
          e.toString(),
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 4),
        );
      } catch (_) {}
    } finally {
      isActionLoading.value = false;
    }
  }

  String _formatDateSafe(String? iso) {
    if (iso == null || iso.isEmpty) return '';
    try {
      final dt = DateTime.parse(iso).toLocal();
      final dd = dt.day.toString().padLeft(2, '0');
      final mm = dt.month.toString().padLeft(2, '0');
      final yyyy = dt.year.toString();
      return '$dd/$mm/$yyyy';
    } catch (_) {
      return iso.split('T').first; // fallback to date portion if parse fails
    }
  }

  /// Create payment for the current load
  Future<String?> createOrderPayment() async {
    try {
      isPaymentLoading.value = true;

      // Get loadId from initialLoadId or deliveryList
      final loadId = initialLoadId ??
          (deliveryList.isNotEmpty ? deliveryList[0]['Delivered ID'] : null);
      
      if (loadId == null || loadId.isEmpty) {
        print('❌ No load ID available for payment');
        Get.snackbar(
          'Error',
          'Load ID not found',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 3),
        );
        return null;
      }

      // Check if price is set (you should set this from API response when status changes to 'driver_assigned')
      if (price.value <= 0) {
        print('❌ Price not available');
        Get.snackbar(
          'Error',
          'Price information not available. Please contact support.',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 3),
        );
        return null;
      }

      print('🔍 Creating order payment for load: $loadId, price: ${price.value}');

      // Get user ID from secure storage
      final userId = await _authStorageService.getUserId();
      if (userId == null || userId.isEmpty) {
        print('❌ User ID not found');
        Get.snackbar(
          'Error',
          'User authentication required. Please log in again.',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 3),
        );
        return null;
      }

      final apiClient = ApiClient();
      final payload = {
        'loadId': loadId,
        'userId': userId,
        'price': price.value,
        'type': 'order',
      };

      print('📦 Payment request payload: $payload');

      final result = await apiClient.post<Map<String, dynamic>>(
        ApiConstants.payment.createPayment,
        data: payload,
        fromJsonT: (json) => json as Map<String, dynamic>,
      );

      return result.fold(
        (failure) {
          print('❌ Failed to create payment: ${failure.message}');
          Get.snackbar(
            'Payment Error',
            failure.message,
            snackPosition: SnackPosition.BOTTOM,
            duration: const Duration(seconds: 3),
          );
          return null;
        },
        (success) {
          final clientSecret = success.data['clientSecret'] as String?;
          if (clientSecret == null || clientSecret.isEmpty) {
            print('❌ Client secret not found in response');
            Get.snackbar(
              'Payment Error',
              'Invalid payment response',
              snackPosition: SnackPosition.BOTTOM,
              duration: const Duration(seconds: 3),
            );
            return null;
          }
          
          print('✅ Payment created successfully. Client Secret: $clientSecret');
          return clientSecret;
        },
      );
    } catch (e) {
      print('❌ Exception creating payment: $e');
      Get.snackbar(
        'Error',
        'Failed to create payment: $e',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
      );
      return null;
    } finally {
      isPaymentLoading.value = false;
    }
  }

  /// Confirm payment after successful Stripe payment
  Future<bool> confirmPayment(String paymentIntentId) async {
    try {
      print('🔄 Confirming payment with Payment Intent ID: $paymentIntentId');

      final apiClient = ApiClient();
      final payload = {
        'paymentIntentId': paymentIntentId,
      };

      print('📦 Confirm payment request payload: $payload');

      final result = await apiClient.post<Map<String, dynamic>>(
        ApiConstants.payment.confirmPayment,
        data: payload,
        fromJsonT: (json) => json as Map<String, dynamic>,
      );

      return result.fold(
        (failure) {
          print('❌ Failed to confirm payment: ${failure.message}');
          // Don't show error to user since payment was successful on Stripe side
          return false;
        },
        (success) {
          print('✅ Payment confirmed successfully on backend');
          return true;
        },
      );
    } catch (e) {
      print('❌ Exception confirming payment: $e');
      // Don't show error to user since payment was successful on Stripe side
      return false;
    }
  }

  /// Mark the current load as delivered by calling the backend endpoint
  Future<void> completeDelivery() async {
    // Determine load id: prefer initialLoadId, otherwise use Delivered ID from deliveryList
    final loadId =
        initialLoadId ?? (deliveryList.isNotEmpty ? deliveryList[0]['Delivered ID'] : null);
    if (loadId == null || loadId.isEmpty) {
      print('No load id available to complete delivery');
      Get.snackbar(
        'Error',
        'Load ID not found',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
      );
      return;
    }

    try {
      isCompletingDelivery.value = true;
      final apiClient = ApiClient();
      final endpoint = ApiConstants.load.compete(loadId);
      final payload = {'orderStatus': 'delivered'};

      print('Completing delivery -> endpoint: $endpoint payload: $payload');

      final result = await apiClient.patch<Map<String, dynamic>>(
        endpoint,
        data: payload,
        fromJsonT: (json) => json as Map<String, dynamic>,
      );

      result.fold(
        (failure) {
          print('Failed to complete delivery: ${failure.message}');
          Get.snackbar(
            'Error',
            failure.message.isNotEmpty ? failure.message : 'Failed to complete delivery',
            snackPosition: SnackPosition.BOTTOM,
            duration: const Duration(seconds: 3),
          );
        },
        (success) async {
          // success.data is expected to be the updated load object or data wrapper
          final raw = success.data;
          // Try to extract the object directly
          final data = raw.containsKey('data') && raw['data'] is Map<String, dynamic>
              ? Map<String, dynamic>.from(raw['data'] as Map)
              : Map<String, dynamic>.from(raw as Map);

          // Update local orderStatus if present
          if (data['orderStatus'] != null) {
            orderStatus.value = data['orderStatus'].toString();
          }

          // Show success snack
          Get.snackbar(
            'Success',
            'Delivery marked as delivered',
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.green,
            colorText: Colors.white,
            duration: const Duration(seconds: 3),
          );

          // Small delay to ensure snackbar is visible and controller is ready
          await Future.delayed(const Duration(milliseconds: 500));

          // Refresh the driver home controller to reload loads
          try {
            final driverHomeController = Get.find<DriverHomeController>();
            await driverHomeController.refreshLoads();
          } catch (e) {
            print('⚠️ Could not refresh driver home loads: $e');
          }

          // Navigate directly to DriverHomeScreen and clear navigation stack
          Get.offAll(() => const DriverHomeScreen());
        },
      );
    } catch (e) {
      print('Exception completing delivery: $e');
      Get.snackbar(
        'Error',
        'Failed to complete delivery: $e',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
      );
    } finally {
      isCompletingDelivery.value = false;
    }
  }

  /// Create chat with driver and navigate to chat detail screen
  Future<void> contactDriver() async {
    try {
      // Validate driver ID is available
      if (currentDriverId == null || currentDriverId!.isEmpty) {
        print('❌ No driver ID available');
        Get.snackbar(
          'Error',
          'Driver information not available. Please try again later.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Get.theme.colorScheme.error,
          colorText: Get.theme.colorScheme.onError,
          duration: const Duration(seconds: 3),
        );
        return;
      }

      isCreatingChat.value = true;
      print('📞 Contacting driver with ID: $currentDriverId');

      final result = await _chatRepository.createChat(sellerId: currentDriverId!);

      result.fold(
        (failure) {
          print('❌ Failed to create chat: ${failure.message}');
          Get.snackbar(
            'Error',
            failure.message.isNotEmpty 
                ? failure.message 
                : 'Failed to create chat. Please try again.',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Get.theme.colorScheme.error,
            colorText: Get.theme.colorScheme.onError,
            duration: const Duration(seconds: 3),
          );
        },
        (chatModel) {
          print('✅ Chat created successfully with ID: ${chatModel.id}');
          
          // Navigate to chat detail screen with the new chat ID
          Get.to(
            () => ChatDetailScreen(conversationId: chatModel.id),
          );
        },
      );
    } catch (e) {
      print('❌ Exception creating chat: $e');
      Get.snackbar(
        'Error',
        'Failed to create chat: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Get.theme.colorScheme.error,
        colorText: Get.theme.colorScheme.onError,
        duration: const Duration(seconds: 3),
      );
    } finally {
      isCreatingChat.value = false;
    }
  }
}
