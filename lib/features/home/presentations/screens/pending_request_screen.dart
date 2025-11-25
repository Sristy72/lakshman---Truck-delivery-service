import 'package:flutter/material.dart';
import 'package:flutter_lakshman1020/core/widgets/custom_appbar.dart';
import 'package:flutter_lakshman1020/dummy_data.dart';
import 'package:flutter_lakshman1020/features/others/presentation/widgets/pending_request_filter.dart';
import 'package:flutter_lakshman1020/features/others/presentation/widgets/pending_request_item.dart';
import 'package:get/get.dart';

import '../../models/shipment_model.dart';
import '../controllers/load_controller.dart';


// class PendingReqScreen1 extends StatelessWidget {
//   const PendingReqScreen1({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: CustomAppBar(
//         titleCenter: true,
//         title:("Pending request"),
//       ),

//       body: Container(
//         padding: EdgeInsets.all(20),
//         child: SingleChildScrollView(
//           child: Column(
//             children: [
//               PendingRequestFilter(),
//               SizedBox(height: 16),
//               Column(
//                 children: shipments.map((shipment) {
//                   return PendingRequestItem(shipment: shipment);
//                 }).toList(),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }


class PendingReqScreen1 extends StatelessWidget {
  const PendingReqScreen1({super.key});

  @override
  Widget build(BuildContext context) {
    final LoadController loadController = Get.find<LoadController>();

    return Scaffold(
      appBar: CustomAppBar(
        titleCenter: true,
        title: "Pending request",
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Obx(
          () {
            if (loadController.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            }

            if (loadController.errorMessage.isNotEmpty) {
              return Center(
                child: Text(
                  loadController.errorMessage.value,
                  style: const TextStyle(color: Colors.red),
                ),
              );
            }

            final loads = loadController.filteredLoads;

            return Column(
              children: [
                const PendingRequestFilter(),
                const SizedBox(height: 16),
                if (loads.isEmpty)
                  const Center(
                    child: Text("No loads available"),
                  )
                else
                  Column(
                    children: loads
                        .map((load) => PendingRequestItem(
                              shipment: Shipment(
                                id: "#${load.id.substring(load.id.length - 5)}",
                                title: load.title,
                                description: load.description ?? '',
                                status: load.orderStatus.toLowerCase() == 'accepted',
                                origin: load.pickupLocation ?? '',
                                destination: load.deliveryLocation ?? '',
                              ),
                            ))
                        .toList(),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}
