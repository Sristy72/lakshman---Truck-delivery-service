import 'package:flutter/material.dart';
import 'package:flutter_lakshman1020/core/constants/app_colors.dart';
import 'package:flutter_lakshman1020/features/home/models/shipment_model.dart';
import '../../../domain/entities/load_entity.dart';

class ShipmentItem extends StatelessWidget {
  final Shipment? shipment;
  final LoadEntity? load;

  const ShipmentItem({super.key, this.shipment, this.load})
    : assert(
        shipment != null || load != null,
        'Either shipment or load must be provided',
      );

  @override
  Widget build(BuildContext context) {
    // Determine which data to use
    final String title = load?.title ?? shipment?.title ?? '';
    final String description = load?.description ?? shipment?.description ?? '';
    final String origin = load?.pickupLocation ?? shipment?.origin ?? '';
    final String destination =
        load?.deliveryLocation ?? shipment?.destination ?? '';

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
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(description),
        trailing: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              origin,
              style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 11),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
            Text(
              destination,
              style: const TextStyle(color: Colors.grey, fontSize: 11),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ],
        ),
      ),
    );
  }
}
