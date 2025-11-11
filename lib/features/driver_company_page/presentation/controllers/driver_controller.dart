

import '../../model/dariver_model.dart';

class DriverController {
  // Demo data that simulates API response
  List<Driver> drivers = [
    Driver(
      id: 1,
      name: "Michael ken",
      deliveryCount: 13,
      rating: 4.9,
      imageUrl: "assets/images/truck_home.png",
      status: "available",
    ),
    Driver(
      id: 2,
      name: "John Smith",
      deliveryCount: 8,
      rating: 4.7,
      imageUrl: "assets/images/truck_home.png",
      status: "available",
    ),
    Driver(
      id: 3,
      name: "Robert Johnson",
      deliveryCount: 21,
      rating: 4.8,
      imageUrl: "assets/images/truck_home.png",
      status: "on_load",
    ),
    Driver(
      id: 4,
      name: "David Wilson",
      deliveryCount: 15,
      rating: 4.6,
      imageUrl: "assets/images/truck_home.png",
      status: "available",
    ),
    Driver(
      id: 5,
      name: "James Brown",
      deliveryCount: 11,
      rating: 4.9,
      imageUrl: "assets/images/truck_home.png",
      status: "on_load",
    ),
    Driver(
      id: 6,
      name: "Thomas Davis",
      deliveryCount: 18,
      rating: 4.7,
      imageUrl: "assets/images/truck_home.png",
      status: "available",
    ),
    Driver(
      id: 7,
      name: "Christopher Miller",
      deliveryCount: 9,
      rating: 4.8,
      imageUrl: "assets/images/truck_home.png",
      status: "on_load",
    ),
    Driver(
      id: 8,
      name: "Daniel Martinez",
      deliveryCount: 14,
      rating: 4.5,
      imageUrl: "assets/images/truck_home.png",
      status: "available",
    ),
    Driver(
      id: 9,
      name: "Paul Anderson",
      deliveryCount: 16,
      rating: 4.9,
      imageUrl: "assets/images/truck_home.png",
      status: "available",
    ),
  ];

  // Simulate API call to fetch drivers
  Future<List<Driver>> fetchDrivers() async {
    // This would be your actual API call
    // final response = await http.get(Uri.parse('your_api_url_here'));
    // return parseDriversFromJson(response.body);

    // For demo, we'll just simulate a delay and return demo data
    await Future.delayed(Duration(seconds: 1));
    return drivers;
  }

  // Filter drivers by status
  List<Driver> filterDrivers(List<Driver> allDrivers, String status) {
    if (status == "all") return allDrivers;
    return allDrivers.where((driver) => driver.status == status).toList();
  }

  // Add a new driver (simulate API call)
  Future<void> addDriver(Driver newDriver) async {
    // This would be your actual API call
    // final response = await http.post(
    //   Uri.parse('your_api_url_here'),
    //   body: newDriver.toJson(),
    // );

    // For demo, just add to the local list
    drivers.add(newDriver);
  }

  // Update a driver (simulate API call)
  Future<void> updateDriver(Driver updatedDriver) async {
    // This would be your actual API call
    // final response = await http.put(
    //   Uri.parse('your_api_url_here/${updatedDriver.id}'),
    //   body: updatedDriver.toJson(),
    // );

    // For demo, update in the local list
    final index = drivers.indexWhere((driver) => driver.id == updatedDriver.id);
    if (index != -1) {
      drivers[index] = updatedDriver;
    }
  }

  // Delete a driver (simulate API call)
  Future<void> deleteDriver(int driverId) async {
    // This would be your actual API call
    // final response = await http.delete(
    //   Uri.parse('your_api_url_here/$driverId'),
    // );

    // For demo, remove from the local list
    drivers.removeWhere((driver) => driver.id == driverId);
  }
}