import 'package:get/get.dart';

class DeliveryDetailsController extends GetxController {
  var deliveryList = <Map<String, String>>[].obs;
  var selectedIndex = 0.obs;

  @override
  void onInit() {
    super.onInit();
    fetchDeliveryDetails();
  }

  Future<void> fetchDeliveryDetails() async {
    try {
      // Simulate API call (replace with your actual API logic)
      final data = [
        {
          'title':'Medical Equipment for Students',
          'DriverName': 'Michael ken',
          'Mobile': '+7853665363',
          'PickupAddress': 'J street, London',
          'DeliveryAddress': 'K street, London',
          'DeliveredDate': '12/10/2025',
          'DeliveredID': '#ABC567#7BG6',
          'productDescription': 'Includes items such as stethoscopes, sphygmomanometers, anatomy kits, lab coats, training dummies, and portable diagnostic tools — typically used by medical, nursing, or paramedic students.',
        },
        // Add more items as needed
      ];
      // Cast each map to Map<String, String> to ensure type safety
      deliveryList.value = data.map((item) => item.cast<String, String>()).toList();
    } catch (e) {
      print('Error fetching delivery details: $e');
      deliveryList.value = []; // Fallback to empty list on error
    }
  }
}