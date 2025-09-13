import 'package:flutter/material.dart';
import 'package:flutter_lakshman1020/dummy_data.dart';
import 'package:flutter_lakshman1020/features/home/presentations/widgets/user_home_widgets/shipment_item.dart';
import 'package:flutter_lakshman1020/features/others/presentation/widgets/company_appbar.dart';
import 'package:flutter_lakshman1020/features/others/presentation/widgets/company_drawer.dart';

class RunningLoadScreen extends StatelessWidget {
  const RunningLoadScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CompanyAppbar(),

      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              children: [
                SizedBox(
                  height: 16,
                  width: 16,
                  child: Image.asset(
                    'assets/images/running_load_icon.png',
                    fit: BoxFit.contain,
                  ),
                ),
                SizedBox(width: 8),
                Text("Running load"),
              ],
            ),
            SizedBox(height: 24),
            Expanded(
              child: ListView.builder(
                itemCount: shipments.length,
                itemBuilder: (context, index) {
                  return ShipmentItem(shipment: shipments[index]);
                },
              ),
            ),
          ],
        ),
      ),
      drawer: CompanyDrawer(),
    );
  }
}
