import 'package:flutter/material.dart';
import 'package:flutter_lakshman1020/dummy_data.dart';
import 'package:flutter_lakshman1020/features/others/presentation/widgets/company_appbar.dart';
import 'package:flutter_lakshman1020/features/others/presentation/widgets/pending_request_filter.dart';
import 'package:flutter_lakshman1020/features/others/presentation/widgets/pending_request_item.dart';

import '../widgets/company_drawer.dart';

class PendingReqScreen extends StatelessWidget {
  const PendingReqScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CompanyAppbar(),
      drawer: CompanyDrawer(),
      body: Container(
        padding: EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              PendingRequestFilter(),
              SizedBox(height: 16),
              Column(
                children: shipments.map((shipment) {
                  return PendingRequestItem(shipment: shipment);
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
