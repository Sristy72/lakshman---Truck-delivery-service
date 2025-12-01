import 'package:flutter/material.dart';

class TripleZeroIndicator extends StatelessWidget {
  final int currentStep;
  final double size;
  final Color color;
  final double width;
  final String? orderStatus;

  const TripleZeroIndicator({
    super.key,
    required this.currentStep,
    this.size = 24.0,
    this.color = const Color(0xffDCE4F5),
    this.width = 63,
    this.orderStatus,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(4, (index) {
        // Default visuals driven by currentStep
        var isCompleted = index < currentStep;
        var isProcessing = index == currentStep;

        // If orderStatus is provided, override visuals to match product rules:
        // - 'ask_pending' => first dot tick, second dot processing (amber border)
        // - 'asked' => first AND second dots tick, third dot processing (amber border)
        // - 'processing' => first dot processing (amber border), others pending
        if (orderStatus != null) {
          final s = orderStatus!.toLowerCase();
          if (s == 'asked') {
            isCompleted = index == 0; // first tick
            isProcessing = index == 1; // second shows processing ring
          } else if (s == 'driver_assigned') {
            isCompleted = index < 2; // first AND second tick
            isProcessing = index == 2; // third shows processing ring
          } else if (s == 'processing') {
            isCompleted = false; // none ticked
            isProcessing = index == 0; // first shows processing ring
          } else {
            // keep defaults for other statuses
            isCompleted = index < currentStep;
            isProcessing = index == currentStep;
          }
        }

        return Row(
          children: [
            if (index > 0)
              Container(width: width, height: 1, color: color.withOpacity(0.5)),
            Container(
              width: 34,
              height: 24,
              decoration: BoxDecoration(
                color: isCompleted
                    ? Colors.green
                    : (isProcessing ? Colors.transparent : Color(0xffE5EDFF)),
                shape: BoxShape.circle,
                border: isProcessing
                    ? Border.all(color: Colors.amber, width: 2)
                    : null,
              ),
              child: Center(
                child: isCompleted
                    ? Icon(Icons.check, size: size * 0.6, color: Colors.white)
                    : null,
              ),
            ),
          ],
        );
      }),
    );
  }
}
