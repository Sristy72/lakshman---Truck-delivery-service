import 'package:flutter/material.dart';
import 'package:flutter_lakshman1020/core/constants/app_colors.dart';
import 'package:flutter_lakshman1020/features/home/models/shipment_model.dart';

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
