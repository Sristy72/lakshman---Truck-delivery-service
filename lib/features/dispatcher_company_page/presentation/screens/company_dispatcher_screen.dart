import 'package:flutter/material.dart';
import 'package:flutter_lakshman1020/core/widgets/app_scaffold.dart';
import 'package:flutter_lakshman1020/features/others/presentation/widgets/company_drawer.dart';
import '../../models/dispatcher_model.dart';
import '../controllers/dispatcher_controller.dart';
import '../widgets/dispatcheer_item.dart';

class CompanyDispatcherScreen extends StatefulWidget {
  const CompanyDispatcherScreen({super.key});

  @override
  State<CompanyDispatcherScreen> createState() =>
      _CompanyDispatcherScreenState();
}

class _CompanyDispatcherScreenState extends State<CompanyDispatcherScreen> {
  final DispatcherController _dispatcherController = DispatcherController();
  List<Dispatcher> _dispatchers = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadDispatchers();
  }

  Future<void> _loadDispatchers() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final dispatchers = await _dispatcherController.fetchDispatchers();
      setState(() {
        _dispatchers = dispatchers;
        _isLoading = false;
      });
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
      print('Error loading dispatchers: $error');
    }
  }

  void _removeDispatcher(int dispatcherId) async {
    await _dispatcherController.removeDispatcher(dispatcherId);
    _loadDispatchers(); // Reload the list
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
                        "Dispatcher",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

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
                        flex: 3,
                        child: Text(
                          "Mobile",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF18191A),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: GestureDetector(
                          onTap: () {
                            // Handle add dispatcher functionality
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
                      ),
                    ],
                  ),
                ),

                // Dispatcher list
                Expanded(
                  child: ListView.separated(
                    itemCount: _dispatchers.length,
                    separatorBuilder: (context, index) => SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final dispatcher = _dispatchers[index];
                      return DispatcherListItem(
                        name: dispatcher.name,
                        mobile: dispatcher.mobile,
                        onRemove: () => _removeDispatcher(dispatcher.id),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
