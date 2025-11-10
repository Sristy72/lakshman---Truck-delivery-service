import 'package:flutter/material.dart';
import 'package:flutter_lakshman1020/core/widgets/custom_appbar.dart';
import 'package:flutter_lakshman1020/dummy_data.dart';
import 'package:flutter_lakshman1020/features/others/presentation/widgets/pending_request_filter.dart';
import 'package:flutter_lakshman1020/features/others/presentation/widgets/pending_request_item.dart';


class PendingReqScreen1 extends StatelessWidget {
  const PendingReqScreen1({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        titleCenter: true,
        title:("Pending request"),
      ),

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
