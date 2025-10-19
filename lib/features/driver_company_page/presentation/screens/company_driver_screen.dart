import 'package:flutter/material.dart';
import 'package:flutter_lakshman1020/core/widgets/app_scaffold.dart';
import '../../../others/presentation/widgets/company_drawer.dart';
import '../../model/dariver_model.dart';
import '../controllers/driver_controller.dart';
import '../widgets/list_items.dart';

class CompanyDriverScreen extends StatefulWidget {
  const CompanyDriverScreen({super.key});

  @override
  State<CompanyDriverScreen> createState() => _CompanyDriverScreenState();
}

class _CompanyDriverScreenState extends State<CompanyDriverScreen> {
  final DriverController _driverController = DriverController();
  List<Driver> _drivers = [];
  String _currentFilter = "available"; // "available" or "on_load"
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadDrivers();
  }

  Future<void> _loadDrivers() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final drivers = await _driverController.fetchDrivers();
      setState(() {
        _drivers = drivers;
        _isLoading = false;
      });
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
      // Handle error
      print('Error loading drivers: $error');
    }
  }

  void _filterDrivers(String status) {
    setState(() {
      _currentFilter = status;
    });
  }

  List<Driver> get _filteredDrivers {
    return _driverController.filterDrivers(_drivers, _currentFilter);
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: AppBar(title: Text("Spark delivery"), centerTitle: true),
      drawer: CompanyDrawer(),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // Header with icon and title
                Padding(
                  padding: const EdgeInsets.only(left: 16, top: 16, right: 16),
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(2),
                        height: 16,
                        width: 16,
                        child: Image.asset(
                          "assets/icons/company_icon2.png",
                          fit: BoxFit.contain,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        "Driver",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Filter buttons
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      // Available button
                      GestureDetector(
                        onTap: () => _filterDrivers("available"),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 6,
                          ),
                          height: 32,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            color: _currentFilter == "available"
                                ? Color(0xffCCDCFF)
                                : Colors.transparent,
                            border: _currentFilter != "available"
                                ? Border.all(color: Colors.grey, width: 1)
                                : null,
                          ),
                          child: Text(
                            "Available",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: _currentFilter == "available"
                                  ? Color(0xFF2F80ED)
                                  : Color(0xFF18191A),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),

                      // On load button
                      GestureDetector(
                        onTap: () => _filterDrivers("on_load"),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 6,
                          ),
                          height: 32,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            color: _currentFilter == "on_load"
                                ? Color(0xffCCDCFF)
                                : Colors.transparent,
                            border: _currentFilter != "on_load"
                                ? Border.all(color: Colors.grey, width: 1)
                                : null,
                          ),
                          child: Text(
                            "On load",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: _currentFilter == "on_load"
                                  ? Color(0xFF2F80ED)
                                  : Color(0xFF18191A),
                            ),
                          ),
                        ),
                      ),

                      Spacer(),

                      // Add button
                      GestureDetector(
                        onTap: () {
                          // Handle add driver functionality
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          height: 32,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            color: Color(0xffF5FFF9),
                          ),
                          child: Row(
                            children: [
                              Text(
                                "Add",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF219653),
                                ),
                              ),
                              const SizedBox(width: 4),
                              Icon(
                                Icons.add,
                                size: 16,
                                color: Color(0xFF219653),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 16),

                // Table headers
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: Text(
                          "Name",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF18191A),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Text(
                          "Delivery",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF18191A),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Text(
                          "Rating",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF18191A),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Driver list
                Expanded(
                  child: ListView.separated(
                    itemCount: _filteredDrivers.length,
                    separatorBuilder: (context, index) => SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final driver = _filteredDrivers[index];
                      return DriverListItem(
                        name: driver.name,
                        deliveryCount: driver.deliveryCount,
                        rating: driver.rating,
                        imageUrl: driver.imageUrl,
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
