import 'package:flutter/material.dart';
import 'package:flutter_lakshman1020/core/constants/app_colors.dart';
import 'package:flutter_lakshman1020/features/home/models/shipment_model.dart';
import 'package:flutter_lakshman1020/features/others/presentation/screen/assign_price_screen.dart';
import 'package:get/get.dart';

class PendingRequestItem extends StatelessWidget {
  final Shipment shipment;

  const PendingRequestItem({super.key, required this.shipment});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: TColors.white,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: TColors.personalBackground, width: 2.0),
      ),
      child: ListTile(
        onTap: () {
          // Pass the actual load ID from shipment
          Get.to(() => AssignPriceScreen(shipment: shipment, loadId: shipment.id));
        },
        leading: SizedBox(
          width: 32,
          height: 32,
          child: Image.asset('assets/images/frame.png', fit: BoxFit.contain),
        ),
        title: Text(
          shipment.title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(shipment.description),
        trailing: SizedBox(
          width: 80,
          height: 25,
          child: shipment.status ?? false
              ? Image.asset('assets/images/assign_yes.png', fit: BoxFit.contain)
              : Image.asset('assets/images/assign_no.png', fit: BoxFit.contain),
        ),
      ),
    );
  }
}
