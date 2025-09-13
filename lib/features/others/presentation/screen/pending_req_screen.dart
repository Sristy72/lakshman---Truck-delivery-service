import 'package:flutter/material.dart';
import 'package:flutter_lakshman1020/dummy_data.dart';
import 'package:flutter_lakshman1020/features/others/presentation/widgets/company_appbar.dart';
import 'package:flutter_lakshman1020/features/others/presentation/widgets/company_drawer.dart';
import 'package:flutter_lakshman1020/features/others/presentation/widgets/pending_request_filter.dart';
import 'package:flutter_lakshman1020/features/others/presentation/widgets/pending_request_item.dart';

class PendingReqScreen extends StatelessWidget {
  const PendingReqScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CompanyAppbar(),

      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            PendingRequestFilter(),
            SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: shipments.length,
                itemBuilder: (context, index) {
                  return PendingRequestItem(shipment: shipments[index]);
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
